import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/providers/ad_provider.dart';
import '../../core/providers/gpa_provider.dart';
import '../../core/providers/locale_provider.dart';
import '../../core/l10n/app_localizations.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final adProvider = context.watch<AdProvider>();
    final gpa = context.watch<GpaProvider>();
    final l = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(l.profile)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Center(
                child: Text(
                  auth.isLoggedIn
                      ? (auth.displayName?.substring(0, 1).toUpperCase() ?? 'U')
                      : 'G',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              auth.isLoggedIn ? (auth.displayName ?? 'User') : l.guest,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (auth.isLoggedIn && auth.email != null) ...[
              const SizedBox(height: 4),
              Text(
                auth.email!,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),
            ],
            if (!auth.isLoggedIn) ...[
              const SizedBox(height: 8),
              Text(
                l.loginRequired,
                style: const TextStyle(color: AppColors.textHint, fontSize: 13),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/register'),
                  child: Text(l.register),
                ),
              ),
            ],
            const SizedBox(height: 32),
            _buildStatCard(gpa, l),
            const SizedBox(height: 20),
            _buildSettingsSection(context, auth, adProvider, l),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(GpaProvider gpa, AppLocalizations l) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStat('GPA', gpa.currentGpa.toStringAsFixed(2)),
          Container(width: 1, height: 40, color: AppColors.divider),
          _buildStat(l.courses, '${gpa.courses.length}'),
          Container(width: 1, height: 40, color: AppColors.divider),
          _buildStat(l.credit, gpa.totalCredits.toStringAsFixed(0)),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildSettingsSection(BuildContext context, AuthProvider auth, AdProvider adProvider, AppLocalizations l) {
    final localeProvider = context.watch<LocaleProvider>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l.settings,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 14),
        _buildSettingsTile(
          icon: Icons.language,
          title: l.language,
          subtitle: localeProvider.isTr ? l.turkish : l.english,
          trailing: Switch(
            value: localeProvider.isTr,
            activeTrackColor: AppColors.primary,
            onChanged: (_) => localeProvider.toggleLocale(),
          ),
        ),
        if (auth.isLoggedIn)
          _buildSettingsTile(
            icon: Icons.campaign,
            title: l.showAds,
            subtitle: adProvider.adsEnabled ? 'Aktif / Active' : 'Kapalı / Off',
            trailing: Switch(
              value: adProvider.adsEnabled,
              activeTrackColor: AppColors.primary,
              onChanged: (v) => adProvider.setAdsEnabled(v),
            ),
          ),
        if (auth.isAdmin)
          _buildSettingsTile(
            icon: Icons.admin_panel_settings,
            title: l.adminPanel,
            subtitle: l.adminPanelSub,
            iconColor: AppColors.error,
            onTap: () => Navigator.pushNamed(context, '/admin'),
          ),
        _buildSettingsTile(
          icon: Icons.info_outline,
          title: l.isTr ? 'Hakkında' : 'About',
          subtitle: 'NCC Campus v1.0.0',
          onTap: () {},
        ),
        if (auth.isLoggedIn)
          _buildSettingsTile(
            icon: Icons.logout,
            title: l.logout,
            subtitle: '',
            iconColor: AppColors.error,
            titleColor: AppColors.error,
            onTap: () async {
              await auth.logout();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(context, '/welcome', (_) => false);
              }
            },
          ),
      ],
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    Color? iconColor,
    Color? titleColor,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor ?? AppColors.textSecondary, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: titleColor ?? AppColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (subtitle.isNotEmpty)
                    Text(
                      subtitle,
                      style: const TextStyle(color: AppColors.textHint, fontSize: 13),
                    ),
                ],
              ),
            ),
            ?trailing,
          ],
        ),
      ),
    );
  }
}
