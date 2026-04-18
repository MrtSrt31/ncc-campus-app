import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../../core/models/campus_models.dart';
import '../../core/services/firestore_service.dart';

class AdminCafeteriaScreen extends StatefulWidget {
  const AdminCafeteriaScreen({super.key});

  @override
  State<AdminCafeteriaScreen> createState() => _AdminCafeteriaScreenState();
}

class _AdminCafeteriaScreenState extends State<AdminCafeteriaScreen> {
  final _firestore = FirestoreService();

  void _showAddEditDialog({CafeteriaMenu? item}) {
    DateTime selectedDate = item?.date ?? DateTime.now();
    final soupC = TextEditingController(text: item?.soup.join(', ') ?? '');
    final mainC = TextEditingController(text: item?.mainCourse.join(', ') ?? '');
    final sideC = TextEditingController(text: item?.sideDish.join(', ') ?? '');
    final extraC = TextEditingController(text: item?.extra.join(', ') ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
          child: SingleChildScrollView(
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
                  item == null ? 'Yeni Menü' : 'Menü Düzenle',
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2024),
                      lastDate: DateTime(2030),
                    );
                    if (picked != null) setModalState(() => selectedDate = picked);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.surfaceLight),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today, color: AppColors.textHint, size: 18),
                        const SizedBox(width: 12),
                        Text(
                          DateFormat('dd MMMM yyyy', 'tr').format(selectedDate),
                          style: const TextStyle(color: AppColors.textPrimary, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: soupC,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: const InputDecoration(hintText: 'Çorba (virgülle ayır)'),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: mainC,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: const InputDecoration(hintText: 'Ana Yemek (virgülle ayır)'),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: sideC,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: const InputDecoration(hintText: 'Yan Yemek (virgülle ayır)'),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: extraC,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: const InputDecoration(hintText: 'Ekstra (virgülle ayır)'),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () async {
                      final dateKey = DateFormat('yyyy-MM-dd').format(selectedDate);
                      final menu = CafeteriaMenu(
                        id: item?.id ?? dateKey,
                        date: selectedDate,
                        soup: _splitInput(soupC.text),
                        mainCourse: _splitInput(mainC.text),
                        sideDish: _splitInput(sideC.text),
                        extra: _splitInput(extraC.text),
                      );
                      await _firestore.setCafeteriaMenu(menu);
                      if (ctx.mounted) Navigator.pop(ctx);
                    },
                    child: Text(item == null ? 'Ekle' : 'Güncelle'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<String> _splitInput(String input) {
    return input.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Yemekhane Menüsü')),
      body: StreamBuilder<List<CafeteriaMenu>>(
        stream: _firestore.streamCafeteriaMenu(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }
          final items = snapshot.data ?? [];
          if (items.isEmpty) {
            return const Center(
              child: Text('Henüz menü eklenmedi', style: TextStyle(color: AppColors.textSecondary)),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.restaurant, color: AppColors.primary, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          DateFormat('dd MMMM yyyy', 'tr').format(item.date),
                          style: const TextStyle(
                            color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.edit, color: AppColors.primary, size: 20),
                          onPressed: () => _showAddEditDialog(item: item),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 20),
                          onPressed: () => _firestore.deleteCafeteriaMenu(item.id),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (item.soup.isNotEmpty)
                      _buildMenuRow('🥣 Çorba', item.soup.join(', ')),
                    if (item.mainCourse.isNotEmpty)
                      _buildMenuRow('🍖 Ana Yemek', item.mainCourse.join(', ')),
                    if (item.sideDish.isNotEmpty)
                      _buildMenuRow('🥗 Yan Yemek', item.sideDish.join(', ')),
                    if (item.extra.isNotEmpty)
                      _buildMenuRow('🍰 Ekstra', item.extra.join(', ')),
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
        label: const Text('Menü Ekle', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildMenuRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13)),
          ),
        ],
      ),
    );
  }
}
