import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_theme.dart';
import '../core/providers/auth_provider.dart';
import '../core/l10n/app_localizations.dart';
import '../core/providers/locale_provider.dart';
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
    final l = AppLocalizations.of(context);
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.divider, width: 0.5)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_outlined),
              activeIcon: const Icon(Icons.home),
              label: l.navHome,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.calculate_outlined),
              activeIcon: const Icon(Icons.calculate),
              label: l.navGpa,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.store_outlined),
              activeIcon: const Icon(Icons.store),
              label: l.navCampus,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person_outline),
              activeIcon: const Icon(Icons.person),
              label: l.navProfile,
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
    final l = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final maxContentWidth = 900.0;
            final isWide = screenWidth > maxContentWidth;

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxContentWidth),
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: isWide ? 32 : 20),
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
                                  auth.isLoggedIn
                                      ? l.greeting(auth.displayName ?? '')
                                      : l.greetingGuest,
                                  style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 26,
                                    fontWeight: FontWeight.w800,
                                  ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l.welcomeSubtitle,
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.read<LocaleProvider>().toggleLocale(),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Text(
                          l.isTr ? 'TR' : 'EN',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const AdBannerWidget(),
              const SizedBox(height: 20),
              Text(
                l.quickAccess,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              _buildResponsiveGrid(
                screenWidth: screenWidth - (isWide ? 64 : 40),
                children: [
                  _QuickActionCard(
                    icon: Icons.calculate,
                    title: l.gpaCalculate,
                    subtitle: l.gpaCalculateSub,
                    color: AppColors.primary,
                    onTap: () => Navigator.pushNamed(context, '/gpa'),
                  ),
                  _QuickActionCard(
                    icon: Icons.science,
                    title: l.simulator,
                    subtitle: l.simulatorSub,
                    color: AppColors.accent,
                    onTap: () => Navigator.pushNamed(context, '/gpa-simulator'),
                  ),
                  _QuickActionCard(
                    icon: Icons.store,
                    title: l.businesses,
                    subtitle: l.businessesSub,
                    color: AppColors.success,
                    onTap: () => Navigator.pushNamed(context, '/campus'),
                  ),
                  _QuickActionCard(
                    icon: Icons.restaurant_menu,
                    title: l.cafeteria,
                    subtitle: l.cafeteriaSub,
                    color: AppColors.warning,
                    onTap: () => Navigator.pushNamed(context, '/cafeteria'),
                  ),
                  _QuickActionCard(
                    icon: Icons.directions_bus,
                    title: l.transportation,
                    subtitle: l.transportationSub,
                    color: Colors.indigo,
                    onTap: () => Navigator.pushNamed(context, '/transportation'),
                  ),
                  _QuickActionCard(
                    icon: Icons.event_note,
                    title: l.thisWeek,
                    subtitle: l.thisWeekSub,
                    color: Colors.deepPurple,
                    onTap: () => Navigator.pushNamed(context, '/this-week'),
                  ),
                  _QuickActionCard(
                    icon: Icons.chat_bubble_outline,
                    title: l.confessions,
                    subtitle: l.confessionsSub,
                    color: Colors.pink,
                    onTap: () => Navigator.pushNamed(context, '/confessions'),
                  ),
                  _QuickActionCard(
                    icon: Icons.storefront,
                    title: l.marketplace,
                    subtitle: l.marketplaceSub,
                    color: Colors.brown,
                    onTap: () => Navigator.pushNamed(context, '/marketplace'),
                  ),
                  _QuickActionCard(
                    icon: Icons.directions_car,
                    title: l.carpool,
                    subtitle: l.carpoolSub,
                    color: Colors.cyan,
                    onTap: () => Navigator.pushNamed(context, '/carpool'),
                  ),
                  if (auth.isAdmin)
                    _QuickActionCard(
                      icon: Icons.admin_panel_settings,
                      title: l.adminPanel,
                      subtitle: l.adminPanelSub,
                      color: AppColors.error,
                      onTap: () => Navigator.pushNamed(context, '/admin'),
                    ),
                ],
              ),
              const SizedBox(height: 32),
              Text(
                l.comingSoon,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              _buildComingSoonCard(
                Icons.smart_toy,
                l.aiAssistant,
                l.aiAssistantSub,
                l,
              ),
              _buildComingSoonCard(
                Icons.map,
                l.campusMap,
                l.campusMapSub,
                l,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildResponsiveGrid({
    required double screenWidth,
    required List<Widget> children,
  }) {
    const spacing = 14.0;
    // 2 cols for narrow (<500), 3 for medium (<750), 4 for wide
    final crossAxisCount = screenWidth < 500 ? 2 : (screenWidth < 750 ? 3 : 4);
    final totalSpacing = spacing * (crossAxisCount - 1);
    final itemWidth = (screenWidth - totalSpacing) / crossAxisCount;

    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      children: children.map((child) => SizedBox(
        width: itemWidth,
        child: child,
      )).toList(),
    );
  }

  Widget _buildComingSoonCard(IconData icon, String title, String subtitle, AppLocalizations l) {
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
          const SizedBox(width: 8),
          Flexible(
            flex: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                l.soon,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
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
