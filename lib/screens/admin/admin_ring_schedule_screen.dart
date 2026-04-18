import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/models/campus_models.dart';
import '../../core/services/firestore_service.dart';

class AdminRingScheduleScreen extends StatefulWidget {
  const AdminRingScheduleScreen({super.key});

  @override
  State<AdminRingScheduleScreen> createState() => _AdminRingScheduleScreenState();
}

class _AdminRingScheduleScreenState extends State<AdminRingScheduleScreen> {
  final _firestore = FirestoreService();

  void _showAddEditDialog({RingSchedule? item}) {
    final periodC = TextEditingController(text: item?.period.toString() ?? '');
    final startC = TextEditingController(text: item?.startTime ?? '');
    final endC = TextEditingController(text: item?.endTime ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight, borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              item == null ? 'Ders Saati Ekle' : 'Düzenle',
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: periodC,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: const InputDecoration(hintText: 'Ders No (ör: 1)'),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: startC,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: const InputDecoration(hintText: 'Başlangıç (ör: 08:40)'),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: endC,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: const InputDecoration(hintText: 'Bitiş (ör: 09:30)'),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () async {
                  final period = int.tryParse(periodC.text.trim());
                  if (period == null) return;
                  final rs = RingSchedule(
                    id: item?.id ?? 'period_$period',
                    period: period,
                    startTime: startC.text.trim(),
                    endTime: endC.text.trim(),
                  );
                  await _firestore.setRingSchedule(rs);
                  if (ctx.mounted) Navigator.pop(ctx);
                },
                child: Text(item == null ? 'Ekle' : 'Güncelle'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Ring Saatleri')),
      body: StreamBuilder<List<RingSchedule>>(
        stream: _firestore.streamRingSchedule(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }
          final items = snapshot.data ?? [];
          if (items.isEmpty) {
            return const Center(
              child: Text('Henüz ders saati eklenmedi', style: TextStyle(color: AppColors.textSecondary)),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.accent.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          '${item.period}',
                          style: const TextStyle(
                            color: AppColors.accent, fontSize: 18, fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${item.period}. Ders', style: const TextStyle(
                            color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w600,
                          )),
                          Text('${item.startTime} - ${item.endTime}',
                            style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: AppColors.primary, size: 20),
                      onPressed: () => _showAddEditDialog(item: item),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 20),
                      onPressed: () => _firestore.deleteRingSchedule(item.id),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEditDialog(),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Saat Ekle', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
