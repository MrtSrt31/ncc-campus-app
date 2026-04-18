import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/firestore_service.dart';

enum UserRole { guest, user, admin }

class AuthProvider extends ChangeNotifier {
  final SharedPreferences _prefs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestore = FirestoreService();

  UserRole _role = UserRole.guest;
  AppUser? _appUser;
  bool _isLoggedIn = false;

  AuthProvider(this._prefs) {
    _loadFromPrefs();
  }

  UserRole get role => _role;
  String? get email => _appUser?.email ?? _prefs.getString('email');
  String? get displayName => _appUser?.displayName ?? _prefs.getString('displayName');
  bool get isLoggedIn => _isLoggedIn;
  bool get isGuest => _role == UserRole.guest;
  bool get isAdmin => _role == UserRole.admin;
  AppUser? get appUser => _appUser;
  User? get currentUser => _auth.currentUser;

  void _loadFromPrefs() {
    _isLoggedIn = _prefs.getBool('isLoggedIn') ?? false;
    final roleStr = _prefs.getString('role') ?? 'guest';
    _role = UserRole.values.firstWhere((r) => r.name == roleStr, orElse: () => UserRole.guest);
    if (_auth.currentUser != null) {
      _syncFromFirestore();
    }
  }

  Future<void> _syncFromFirestore() async {
    final user = _auth.currentUser;
    if (user == null) return;
    try {
      _appUser = await _firestore.getUser(user.uid);
      if (_appUser != null) {
        _isLoggedIn = true;
        _role = _appUser!.isAdmin ? UserRole.admin : UserRole.user;
        await _prefs.setString('role', _role.name);
        notifyListeners();
      }
    } catch (_) {}
  }

  Future<bool> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) return false;
    try {
      final cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
      if (cred.user == null) return false;

      _appUser = await _firestore.getUser(cred.user!.uid);
      _isLoggedIn = true;
      _role = _appUser?.isAdmin == true ? UserRole.admin : UserRole.user;

      await _prefs.setBool('isLoggedIn', true);
      await _prefs.setString('email', email);
      await _prefs.setString('displayName', _appUser?.displayName ?? email.split('@').first);
      await _prefs.setString('role', _role.name);

      notifyListeners();
      return true;
    } on FirebaseAuthException {
      return false;
    }
  }

  Future<bool> register(String email, String password, String name) async {
    if (email.isEmpty || password.isEmpty || name.isEmpty) return false;
    if (!email.endsWith('.edu.tr')) return false;
    try {
      final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      if (cred.user == null) return false;

      _appUser = AppUser(
        uid: cred.user!.uid,
        email: email,
        displayName: name,
        role: 'user',
        adsEnabled: true,
      );
      await _firestore.createUser(_appUser!);

      _isLoggedIn = true;
      _role = UserRole.user;

      await _prefs.setBool('isLoggedIn', true);
      await _prefs.setString('email', email);
      await _prefs.setString('displayName', name);
      await _prefs.setString('role', 'user');

      notifyListeners();
      return true;
    } on FirebaseAuthException {
      return false;
    }
  }

  void continueAsGuest() {
    _role = UserRole.guest;
    _isLoggedIn = false;
    _appUser = null;
    notifyListeners();
  }

  Future<void> logout() async {
    await _auth.signOut();
    _role = UserRole.guest;
    _appUser = null;
    _isLoggedIn = false;

    await _prefs.remove('isLoggedIn');
    await _prefs.remove('email');
    await _prefs.remove('displayName');
    await _prefs.remove('role');

    notifyListeners();
  }
}
