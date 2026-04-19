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
      backgroundColor: AppColors.bg(context),
      appBar: AppBar(title: const Text('Kullanıcılar')),
      body: StreamBuilder<List<AppUser>>(
        stream: firestore.streamAllUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }
          final users = snapshot.data ?? [];
          if (users.isEmpty) {
            return Center(
              child: Text('Henüz kullanıcı yok', style: TextStyle(color: AppColors.txtSec(context))),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cardBg(context),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(
                        color: _roleColor(context, user.role).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          user.displayName.isNotEmpty ? user.displayName[0].toUpperCase() : '?',
                          style: TextStyle(
                            color: _roleColor(context, user.role), fontSize: 18, fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user.displayName, style: TextStyle(
                            color: AppColors.txt(context), fontSize: 15, fontWeight: FontWeight.w600,
                          )),
                          Text(user.email, style: TextStyle(color: AppColors.txtHint(context), fontSize: 12)),
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      icon: Icon(Icons.more_vert, color: AppColors.txtHint(context), size: 20),
                      color: AppColors.surf(context),
                      itemBuilder: (_) => [
                        PopupMenuItem(value: 'admin', child: Text('Admin Yap', style: TextStyle(color: AppColors.txt(context)))),
                        PopupMenuItem(value: 'user', child: Text('Kullanıcı Yap', style: TextStyle(color: AppColors.txt(context)))),
                      ],
                      onSelected: (role) {
                        firestore.updateUser(user.uid, {'role': role});
                      },
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _roleColor(context, user.role).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        _roleLabel(user.role),
                        style: TextStyle(
                          color: _roleColor(context, user.role), fontSize: 11, fontWeight: FontWeight.w600,
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

  Color _roleColor(BuildContext context, String role) {
    switch (role) {
      case 'admin':
        return AppColors.error;
      case 'user':
        return AppColors.primary;
      default:
        return AppColors.txtHint(context);
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
