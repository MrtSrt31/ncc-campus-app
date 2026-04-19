import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/models/campus_models.dart';
import '../../core/services/firestore_service.dart';

class CafeteriaScreen extends StatelessWidget {
  const CafeteriaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firestore = FirestoreService();
    final l = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.bg(context),
      appBar: AppBar(title: Text(l.cafeteriaMenu)),
      body: StreamBuilder<List<CafeteriaMenu>>(
        stream: firestore.streamCafeteriaMenu(),
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
                  Icon(Icons.restaurant, size: 64, color: AppColors.txtHint(context).withValues(alpha: 0.5)),
                  const SizedBox(height: 16),
                  Text(l.noMenuYet,
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
              final isToday = _isToday(item.date);
              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.cardBg(context),
                  borderRadius: BorderRadius.circular(16),
                  border: isToday
                      ? Border.all(color: AppColors.primary.withValues(alpha: 0.4), width: 1.5)
                      : null,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          DateFormat('dd MMMM yyyy', l.isTr ? 'tr' : 'en').format(item.date),
                          style: TextStyle(
                            color: AppColors.txt(context), fontSize: 17, fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (isToday) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              l.today,
                              style: const TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (item.soup.isNotEmpty)
                      _buildRow(context, '🥣', l.soup, item.soup),
                    if (item.mainCourse.isNotEmpty)
                      _buildRow(context, '🍖', l.mainCourseName, item.mainCourse),
                    if (item.sideDish.isNotEmpty)
                      _buildRow(context, '🥗', l.sideDish, item.sideDish),
                    if (item.extra.isNotEmpty)
                      _buildRow(context, '🍰', l.extra, item.extra),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildRow(BuildContext context, String emoji, String label, List<String> items) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(color: AppColors.txtHint(context), fontSize: 12)),
                const SizedBox(height: 2),
                Text(
                  items.join(', '),
                  style: TextStyle(color: AppColors.txt(context), fontSize: 15),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }
}
