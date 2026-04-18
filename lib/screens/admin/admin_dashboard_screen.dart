import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/services/firestore_service.dart';
import 'admin_businesses_screen.dart';
import 'admin_announcements_screen.dart';
import 'admin_ring_schedule_screen.dart';
import 'admin_cafeteria_screen.dart';
import 'admin_users_screen.dart';
import 'admin_reviews_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final _firestore = FirestoreService();
  Map<String, int> _stats = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    try {
      final stats = await _firestore.getStats();
      setState(() {
        _stats = stats;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Admin Panel'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() => _loading = true);
              _loadStats();
            },
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : RefreshIndicator(
              onRefresh: _loadStats,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Genel Bakış',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            icon: Icons.people,
                            label: 'Kullanıcı',
                            value: '${_stats['users'] ?? 0}',
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StatCard(
                            icon: Icons.store,
                            label: 'İşletme',
                            value: '${_stats['businesses'] ?? 0}',
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            icon: Icons.rate_review,
                            label: 'Yorum',
                            value: '${_stats['reviews'] ?? 0}',
                            color: AppColors.accent,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StatCard(
                            icon: Icons.campaign,
                            label: 'Duyuru',
                            value: '${_stats['announcements'] ?? 0}',
                            color: AppColors.warning,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'Yönetim',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _AdminTile(
                      icon: Icons.store,
                      title: 'İşletme Yönetimi',
                      subtitle: 'Ekle, düzenle, sil',
                      color: AppColors.success,
                      onTap: () => _navigateTo(const AdminBusinessesScreen()),
                    ),
                    _AdminTile(
                      icon: Icons.campaign,
                      title: 'Duyuru & Etkinlik',
                      subtitle: 'Kampüs duyuruları yönet',
                      color: AppColors.warning,
                      onTap: () => _navigateTo(const AdminAnnouncementsScreen()),
                    ),
                    _AdminTile(
                      icon: Icons.schedule,
                      title: 'Ring Saatleri',
                      subtitle: 'Ders saatlerini düzenle',
                      color: AppColors.accent,
                      onTap: () => _navigateTo(const AdminRingScheduleScreen()),
                    ),
                    _AdminTile(
                      icon: Icons.restaurant,
                      title: 'Yemekhane Menüsü',
                      subtitle: 'Günlük menü ekle',
                      color: AppColors.primary,
                      onTap: () => _navigateTo(const AdminCafeteriaScreen()),
                    ),
                    _AdminTile(
                      icon: Icons.people,
                      title: 'Kullanıcı Yönetimi',
                      subtitle: 'Kullanıcıları ve rolleri yönet',
                      color: Colors.teal,
                      onTap: () => _navigateTo(const AdminUsersScreen()),
                    ),
                    _AdminTile(
                      icon: Icons.rate_review,
                      title: 'Yorum Yönetimi',
                      subtitle: 'Yorumları incele ve yönet',
                      color: Colors.orange,
                      onTap: () => _navigateTo(const AdminReviewsScreen()),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  void _navigateTo(Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color.withValues(alpha: 0.7),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _AdminTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(color: AppColors.textHint, fontSize: 13),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textHint),
          ],
        ),
      ),
    );
  }
}
