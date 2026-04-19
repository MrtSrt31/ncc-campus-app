import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../../core/models/campus_models.dart';
import '../../core/services/firestore_service.dart';
import '../../widgets/ad_banner_widget.dart';

class AnnouncementsScreen extends StatelessWidget {
  const AnnouncementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firestore = FirestoreService();

    return Scaffold(
      backgroundColor: AppColors.bg(context),
      appBar: AppBar(title: const Text('Bugün Kampüste')),
      body: Column(
        children: [
          const AdBannerWidget(),
          Expanded(
            child: StreamBuilder<List<Announcement>>(
              stream: firestore.streamAnnouncements(activeOnly: true),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                }
                final items = snapshot.data ?? [];
                if (items.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.event_busy, size: 64, color: AppColors.txtHint(context).withValues(alpha: 0.5)),
                        const SizedBox(height: 16),
                        Text('Şu an aktif duyuru yok',
                          style: TextStyle(color: AppColors.txtSec(context), fontSize: 16)),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return _AnnouncementCard(announcement: item);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _AnnouncementCard extends StatelessWidget {
  final Announcement announcement;
  const _AnnouncementCard({required this.announcement});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _categoryColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: _categoryColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(_categoryIcon, color: _categoryColor, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      _categoryLabel,
                      style: TextStyle(color: _categoryColor, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Text(
                DateFormat('dd MMM', 'tr').format(announcement.date),
                style: TextStyle(color: AppColors.txtHint(context), fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            announcement.title,
            style: TextStyle(
              color: AppColors.txt(context), fontSize: 18, fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            announcement.description,
            style: TextStyle(color: AppColors.txtSec(context), fontSize: 14, height: 1.5),
          ),
        ],
      ),
    );
  }

  Color get _categoryColor {
    switch (announcement.category) {
      case 'event': return AppColors.primary;
      case 'exam': return AppColors.error;
      case 'announcement': return AppColors.warning;
      default: return AppColors.accent;
    }
  }

  IconData get _categoryIcon {
    switch (announcement.category) {
      case 'event': return Icons.celebration;
      case 'exam': return Icons.quiz;
      case 'announcement': return Icons.campaign;
      default: return Icons.info;
    }
  }

  String get _categoryLabel {
    switch (announcement.category) {
      case 'event': return 'Etkinlik';
      case 'exam': return 'Sınav';
      case 'announcement': return 'Duyuru';
      default: return 'Genel';
    }
  }
}
