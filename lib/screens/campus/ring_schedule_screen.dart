import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/models/campus_models.dart';
import '../../core/services/firestore_service.dart';

class RingScheduleScreen extends StatelessWidget {
  const RingScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firestore = FirestoreService();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Ring Saatleri')),
      body: StreamBuilder<List<RingSchedule>>(
        stream: firestore.streamRingSchedule(),
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
                  Icon(Icons.schedule, size: 64, color: AppColors.textHint.withValues(alpha: 0.5)),
                  const SizedBox(height: 16),
                  const Text('Ring saatleri henüz eklenmedi',
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
              final isEven = index % 2 == 0;
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: (isEven ? AppColors.primary : AppColors.accent).withValues(alpha: 0.15),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 52, height: 52,
                      decoration: BoxDecoration(
                        color: (isEven ? AppColors.primary : AppColors.accent).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Text(
                          '${item.period}',
                          style: TextStyle(
                            color: isEven ? AppColors.primary : AppColors.accent,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${item.period}. Ders',
                            style: const TextStyle(
                              color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.access_time, color: AppColors.textHint, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                '${item.startTime} - ${item.endTime}',
                                style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
