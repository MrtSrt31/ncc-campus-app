import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../../core/models/campus_models.dart';
import '../../core/services/firestore_service.dart';

class CafeteriaScreen extends StatelessWidget {
  const CafeteriaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firestore = FirestoreService();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Yemekhane Menüsü')),
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
                  Icon(Icons.restaurant, size: 64, color: AppColors.textHint.withValues(alpha: 0.5)),
                  const SizedBox(height: 16),
                  const Text('Menü henüz eklenmedi',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
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
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.card,
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
                          DateFormat('dd MMMM yyyy', 'tr').format(item.date),
                          style: const TextStyle(
                            color: AppColors.textPrimary, fontSize: 17, fontWeight: FontWeight.w700,
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
                            child: const Text(
                              'Bugün',
                              style: TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (item.soup.isNotEmpty)
                      _buildRow('🥣', 'Çorba', item.soup),
                    if (item.mainCourse.isNotEmpty)
                      _buildRow('🍖', 'Ana Yemek', item.mainCourse),
                    if (item.sideDish.isNotEmpty)
                      _buildRow('🥗', 'Yan Yemek', item.sideDish),
                    if (item.extra.isNotEmpty)
                      _buildRow('🍰', 'Ekstra', item.extra),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildRow(String emoji, String label, List<String> items) {
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
                Text(label, style: const TextStyle(color: AppColors.textHint, fontSize: 12)),
                const SizedBox(height: 2),
                Text(
                  items.join(', '),
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
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
