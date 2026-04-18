import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String uid;
  final String email;
  final String displayName;
  final String role; // 'guest', 'user', 'admin'
  final bool adsEnabled;
  final DateTime? createdAt;

  AppUser({
    required this.uid,
    required this.email,
    required this.displayName,
    this.role = 'user',
    this.adsEnabled = true,
    this.createdAt,
  });

  bool get isAdmin => role == 'admin';
  bool get isGuest => role == 'guest';

  Map<String, dynamic> toFirestore() => {
        'email': email,
        'displayName': displayName,
        'role': role,
        'adsEnabled': adsEnabled,
        'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      };

  factory AppUser.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppUser(
      uid: doc.id,
      email: data['email'] ?? '',
      displayName: data['displayName'] ?? '',
      role: data['role'] ?? 'user',
      adsEnabled: data['adsEnabled'] ?? true,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  factory AppUser.guest() => AppUser(
        uid: 'guest',
        email: '',
        displayName: 'Misafir',
        role: 'guest',
        adsEnabled: true,
      );
}
