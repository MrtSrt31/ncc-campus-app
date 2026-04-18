import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/models/user_model.dart';
import '../../core/services/firestore_service.dart';

class AdminUsersScreen extends StatelessWidget {
  const AdminUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firestore = FirestoreService();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Kullanıcılar')),
      body: StreamBuilder<List<AppUser>>(
        stream: firestore.streamAllUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }
          final users = snapshot.data ?? [];
          if (users.isEmpty) {
            return const Center(
              child: Text('Henüz kullanıcı yok', style: TextStyle(color: AppColors.textSecondary)),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(
                        color: _roleColor(user.role).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          user.displayName.isNotEmpty ? user.displayName[0].toUpperCase() : '?',
                          style: TextStyle(
                            color: _roleColor(user.role), fontSize: 18, fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user.displayName, style: const TextStyle(
                            color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w600,
                          )),
                          Text(user.email, style: const TextStyle(color: AppColors.textHint, fontSize: 12)),
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert, color: AppColors.textHint, size: 20),
                      color: AppColors.surface,
                      itemBuilder: (_) => [
                        const PopupMenuItem(value: 'admin', child: Text('Admin Yap', style: TextStyle(color: AppColors.textPrimary))),
                        const PopupMenuItem(value: 'user', child: Text('Kullanıcı Yap', style: TextStyle(color: AppColors.textPrimary))),
                      ],
                      onSelected: (role) {
                        firestore.updateUser(user.uid, {'role': role});
                      },
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _roleColor(user.role).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        _roleLabel(user.role),
                        style: TextStyle(
                          color: _roleColor(user.role), fontSize: 11, fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Color _roleColor(String role) {
    switch (role) {
      case 'admin':
        return AppColors.error;
      case 'user':
        return AppColors.primary;
      default:
        return AppColors.textHint;
    }
  }

  String _roleLabel(String role) {
    switch (role) {
      case 'admin':
        return 'Admin';
      case 'user':
        return 'Üye';
      default:
        return 'Misafir';
    }
  }
}
