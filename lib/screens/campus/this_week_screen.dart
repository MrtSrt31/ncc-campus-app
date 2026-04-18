import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_theme.dart';
import '../../core/l10n/app_localizations.dart';
import '../../widgets/ad_banner_widget.dart';

class ThisWeekScreen extends StatelessWidget {
  const ThisWeekScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l.thisWeekTitle),
        actions: [
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
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildWeekHeader(context),
                const SizedBox(height: 20),
                ..._sampleEvents.map((e) => _EventCard(event: e)),
              ],
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
      child: const Row(
        children: [
          Icon(Icons.event_note, color: AppColors.primary, size: 32),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '13 – 19 Nisan / April 2026',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'ODTÜ KKK Kampüs Etkinlikleri',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EventData {
  final String date;
  final String time;
  final String title;
  final String location;
  final String organizer;
  final Color color;

  const _EventData({
    required this.date,
    required this.time,
    required this.title,
    required this.location,
    required this.organizer,
    required this.color,
  });
}

const _sampleEvents = [
  _EventData(
    date: '15.04.2026 Çarşamba / Wednesday',
    time: '15:40 – 16:30',
    title: 'GPC 495: Seminar in Guidance and Counseling\n"Zamanı Durduramazsın ama Yönetebilirsin!"',
    location: 'Culture and Convention Center, Amfi 3',
    organizer: 'Rehberlik ve Psikolojik Danışmanlık Programı',
    color: AppColors.primary,
  ),
  _EventData(
    date: '16.04.2026 Perşembe / Thursday',
    time: '12:40',
    title: 'SCIENCE FOR LUNCH\nEngineering Ethics in the Age of "AI"',
    location: 'Academic Block, S-106',
    organizer: 'Dr. Hüseyin Sevay',
    color: AppColors.accent,
  ),
  _EventData(
    date: '17.04.2026 Cuma / Friday',
    time: '09:00 – 12:30',
    title: 'Open Day (Tanıtım Günü) Etkinliği',
    location: 'Culture and Convention Center',
    organizer: 'ODTÜ KKK',
    color: AppColors.success,
  ),
  _EventData(
    date: '17.04.2026 Cuma / Friday',
    time: '19:00',
    title: 'Film Gösterimi / Cinema\n"Whiplash"',
    location: 'Sega Cafe',
    organizer: 'Müzik Topluluğu / Music Club',
    color: AppColors.warning,
  ),
  _EventData(
    date: '18.04.2026 Cumartesi / Saturday',
    time: '15:00',
    title: 'Workshop\n"Python"',
    location: 'Information Technologies Building, IZ-04',
    organizer: 'Endüstri Müh., Robotik, Teknofest Toplulukları',
    color: Colors.orange,
  ),
  _EventData(
    date: '19.04.2026 Pazar / Sunday',
    time: '19:00',
    title: 'Film Gösterimi / Cinema\n"The Ninth Gate"',
    location: 'Culture and Convention Center, Amfi 2',
    organizer: 'Fantastik Kurgu Topluluğu',
    color: Colors.teal,
  ),
];

class _EventCard extends StatelessWidget {
  final _EventData event;

  const _EventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.card,
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
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  event.location,
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.group_outlined, size: 14, color: AppColors.textHint),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  event.organizer,
                  style: const TextStyle(color: AppColors.textHint, fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
