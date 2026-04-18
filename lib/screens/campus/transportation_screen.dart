import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/l10n/app_localizations.dart';
import '../../widgets/ad_banner_widget.dart';

class TransportationScreen extends StatelessWidget {
  const TransportationScreen({super.key});

  static const _semesterToCampus = [
    '08:45', '09:45', '10:45', '11:45', '12:45',
    '13:45', '14:45', '15:45', '16:45', '17:45', '18:45',
    '20:45', '22:45',
  ];
  static const _semesterFromTerminal = [
    '08:05', '09:05', '10:05', '11:05', '12:05',
    '13:05', '14:05', '15:05', '16:05', '17:05', '18:05',
    '20:05', '22:05',
  ];

  static const _holidayToCampus = [
    '10:45', '12:45', '14:45', '16:45', '18:45', '20:45', '22:45',
  ];
  static const _holidayFromTerminal = [
    '10:05', '12:05', '14:05', '16:05', '18:05', '20:05', '22:05',
  ];

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(l.transportationTitle),
          bottom: TabBar(
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            tabs: [
              Tab(text: l.semesterSchedule),
              Tab(text: l.holidaySchedule),
            ],
          ),
        ),
        body: Column(
          children: [
            const AdBannerWidget(),
            Expanded(
              child: TabBarView(
                children: [
                  _ScheduleTab(
                    toCampus: _semesterToCampus,
                    fromTerminal: _semesterFromTerminal,
                    l: l,
                  ),
                  _ScheduleTab(
                    toCampus: _holidayToCampus,
                    fromTerminal: _holidayFromTerminal,
                    l: l,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScheduleTab extends StatelessWidget {
  final List<String> toCampus;
  final List<String> fromTerminal;
  final AppLocalizations l;

  const _ScheduleTab({
    required this.toCampus,
    required this.fromTerminal,
    required this.l,
  });

  String _currentTimeStr() {
    final now = TimeOfDay.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  bool _isPast(String time) {
    return time.compareTo(_currentTimeStr()) < 0;
  }

  bool _isNext(String time, List<String> times) {
    final now = _currentTimeStr();
    for (final t in times) {
      if (t.compareTo(now) >= 0) return t == time;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDirectionCard(
            context,
            icon: Icons.arrow_forward,
            title: l.campusToTerminal,
            times: toCampus,
            color: AppColors.primary,
          ),
          const SizedBox(height: 20),
          _buildDirectionCard(
            context,
            icon: Icons.arrow_back,
            title: l.terminalToCampus,
            times: fromTerminal,
            color: AppColors.accent,
          ),
        ],
      ),
    );
  }

  Widget _buildDirectionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required List<String> times,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: color,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: times.map((time) {
                final past = _isPast(time);
                final next = _isNext(time, times);
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: next
                        ? color.withValues(alpha: 0.2)
                        : past
                            ? AppColors.surfaceLight.withValues(alpha: 0.5)
                            : AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: next
                        ? Border.all(color: color, width: 1.5)
                        : null,
                  ),
                  child: Text(
                    time,
                    style: TextStyle(
                      color: past
                          ? AppColors.textHint
                          : next
                              ? color
                              : AppColors.textPrimary,
                      fontSize: 15,
                      fontWeight: next ? FontWeight.w700 : FontWeight.w500,
                      decoration: past ? TextDecoration.lineThrough : null,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
