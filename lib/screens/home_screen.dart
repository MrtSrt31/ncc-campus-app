import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_theme.dart';
import '../core/providers/auth_provider.dart';
import '../widgets/ad_banner_widget.dart';
import 'gpa/gpa_screen.dart';
import 'campus/campus_directory_screen.dart';
import 'profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    _HomePage(),
    GpaScreen(),
    CampusDirectoryScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.divider, width: 0.5)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Ana Sayfa',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calculate_outlined),
              activeIcon: Icon(Icons.calculate),
              label: 'GPA',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.store_outlined),
              activeIcon: Icon(Icons.store),
              label: 'Kampüs',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}

class _HomePage extends StatelessWidget {
  const _HomePage();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Merhaba${auth.isLoggedIn ? ", ${auth.displayName}" : ""} 👋',
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'NCC Campus\'a hoş geldin',
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Center(
                      child: Text(
                        'NCC',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const AdBannerWidget(),
              const SizedBox(height: 20),
              const Text(
                'Hızlı Erişim',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _QuickActionCard(
                      icon: Icons.calculate,
                      title: 'GPA Hesapla',
                      subtitle: 'Ortalamanı hesapla',
                      color: AppColors.primary,
                      onTap: () => Navigator.pushNamed(context, '/gpa'),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _QuickActionCard(
                      icon: Icons.science,
                      title: 'Simülatör',
                      subtitle: 'Not simülasyonu',
                      color: AppColors.accent,
                      onTap: () => Navigator.pushNamed(context, '/gpa-simulator'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _QuickActionCard(
                      icon: Icons.store,
                      title: 'İşletmeler',
                      subtitle: 'Kampüs rehberi',
                      color: AppColors.success,
                      onTap: () => Navigator.pushNamed(context, '/campus'),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _QuickActionCard(
                      icon: Icons.restaurant_menu,
                      title: 'Yemekhane',
                      subtitle: 'Günlük menü',
                      color: AppColors.warning,
                      onTap: () => Navigator.pushNamed(context, '/cafeteria'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _QuickActionCard(
                      icon: Icons.campaign,
                      title: 'Duyurular',
                      subtitle: 'Kampüs haberleri',
                      color: Colors.orange,
                      onTap: () => Navigator.pushNamed(context, '/announcements'),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _QuickActionCard(
                      icon: Icons.schedule,
                      title: 'Ring Saatleri',
                      subtitle: 'Ders saatleri',
                      color: Colors.teal,
                      onTap: () => Navigator.pushNamed(context, '/ring-schedule'),
                    ),
                  ),
                ],
              ),
              if (auth.isAdmin) ...[
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: _QuickActionCard(
                    icon: Icons.admin_panel_settings,
                    title: 'Admin Panel',
                    subtitle: 'Yönetim paneli',
                    color: AppColors.error,
                    onTap: () => Navigator.pushNamed(context, '/admin'),
                  ),
                ),
              ],
              const SizedBox(height: 32),
              const Text(
                'Yakında Geliyor',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              _buildComingSoonCard(
                Icons.smart_toy,
                'AI Ders Yardımcısı',
                'Akıllı ders önerileri',
              ),
              _buildComingSoonCard(
                Icons.map,
                'Kampüs Haritası',
                'İnteraktif kampüs rehberi',
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildComingSoonCard(IconData icon, String title, String subtitle) {
    return Container(
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
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: AppColors.textHint, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 15,
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Yakında',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
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
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                color: color.withValues(alpha: 0.7),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
