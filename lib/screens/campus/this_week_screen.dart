import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/models/campus_event_model.dart';
import '../../core/providers/this_week_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/l10n/app_localizations.dart';
import '../../widgets/ad_banner_widget.dart';

class ThisWeekScreen extends StatefulWidget {
  const ThisWeekScreen({super.key});

  @override
  State<ThisWeekScreen> createState() => _ThisWeekScreenState();
}

class _ThisWeekScreenState extends State<ThisWeekScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ThisWeekProvider>().loadEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final provider = context.watch<ThisWeekProvider>();

    return Scaffold(
      backgroundColor: AppColors.bg(context),
      appBar: AppBar(
        title: Text(l.thisWeekTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: l.isTr ? 'Yenile' : 'Refresh',
            onPressed: () => context.read<ThisWeekProvider>().loadEvents(),
          ),
          IconButton(
            icon: const Icon(Icons.open_in_new),
            tooltip: 'Web',
            onPressed: () => launchUrl(
              Uri.parse('https://ncc.metu.edu.tr/tr/kamp%C3%BCste-bu-hafta'),
              mode: LaunchMode.externalApplication,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const AdBannerWidget(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => context.read<ThisWeekProvider>().loadEvents(),
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _buildWeekHeader(context),
                  const SizedBox(height: 20),
                  if (provider.loading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (provider.error != null)
                    _ErrorCard(message: provider.error!)
                  else
                    ...provider.events.map((e) => _EventCard(event: e)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.2),
            AppColors.accent.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(Icons.event_note, color: AppColors.primary, size: 32),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kampüste Bu Hafta',
                  style: TextStyle(
                    color: AppColors.txt(context),
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Canlı etkinlik akışı',
                  style: TextStyle(color: AppColors.txtSec(context), fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final CampusEvent event;

  const _EventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(16),
        border: Border(
          left: BorderSide(color: event.color, width: 3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.calendar_today, size: 14, color: event.color),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  event.date,
                  style: TextStyle(
                    color: event.color,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: event.color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  event.time,
                  style: TextStyle(
                    color: event.color,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            event.title,
            style: TextStyle(
              color: AppColors.txt(context),
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.location_on_outlined, size: 14, color: AppColors.txtSec(context)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  event.location,
                  style: TextStyle(color: AppColors.txtSec(context), fontSize: 13),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.group_outlined, size: 14, color: AppColors.txtHint(context)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  event.organizer,
                  style: TextStyle(color: AppColors.txtHint(context), fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final String message;

  const _ErrorCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.error),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: AppColors.txt(context)),
            ),
          ),
        ],
      ),
    );
  }
}
