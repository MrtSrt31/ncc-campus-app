import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/firestore_service.dart';

enum UserRole { guest, user, admin }

class AuthProvider extends ChangeNotifier {
  final SharedPreferences _prefs;
  FirebaseAuth? _auth;
  final FirestoreService _firestore = FirestoreService();

  bool get _firebaseAvailable => Firebase.apps.isNotEmpty;
  FirebaseAuth get _firebaseAuth {
    _auth ??= FirebaseAuth.instance;
    return _auth!;
  }

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
  User? get currentUser => _firebaseAvailable ? _firebaseAuth.currentUser : null;

  void _loadFromPrefs() {
    _isLoggedIn = _prefs.getBool('isLoggedIn') ?? false;
    final roleStr = _prefs.getString('role') ?? 'guest';
    _role = UserRole.values.firstWhere((r) => r.name == roleStr, orElse: () => UserRole.guest);
    if (_firebaseAvailable && _firebaseAuth.currentUser != null) {
      _syncFromFirestore();
    }
  }

  Future<void> _syncFromFirestore() async {
    if (!_firebaseAvailable) return;
    final user = _firebaseAuth.currentUser;
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

    // Demo admin login
    if (email == 'admin' && password == 'admin') {
      _appUser = AppUser(
        uid: 'demo-admin',
        email: 'admin@ncc.metu.edu.tr',
        displayName: 'Admin',
        role: 'admin',
        adsEnabled: false,
      );
      _isLoggedIn = true;
      _role = UserRole.admin;
      await _prefs.setBool('isLoggedIn', true);
      await _prefs.setString('email', 'admin@ncc.metu.edu.tr');
      await _prefs.setString('displayName', 'Admin');
      await _prefs.setString('role', 'admin');
      notifyListeners();
      return true;
    }

    if (!_firebaseAvailable) return false;
    try {
      final cred = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
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
    if (!_firebaseAvailable) return false;
    try {
      final cred = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
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
    if (_firebaseAvailable) await _firebaseAuth.signOut();
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
