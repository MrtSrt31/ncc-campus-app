import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../../core/models/campus_models.dart';
import '../../core/services/firestore_service.dart';

class AdminAnnouncementsScreen extends StatefulWidget {
  const AdminAnnouncementsScreen({super.key});

  @override
  State<AdminAnnouncementsScreen> createState() => _AdminAnnouncementsScreenState();
}

class _AdminAnnouncementsScreenState extends State<AdminAnnouncementsScreen> {
  final _firestore = FirestoreService();
  final _categories = ['event', 'announcement', 'exam', 'general'];
  final _categoryLabels = {
    'event': 'Etkinlik',
    'announcement': 'Duyuru',
    'exam': 'Sınav',
    'general': 'Genel',
  };

  void _showAddEditDialog({Announcement? item}) {
    final titleC = TextEditingController(text: item?.title ?? '');
    final descC = TextEditingController(text: item?.description ?? '');
    String selectedCategory = item?.category ?? 'general';
    DateTime selectedDate = item?.date ?? DateTime.now();
    bool isActive = item?.isActive ?? true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surf(context),
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
                      color: AppColors.surfLight(context),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  item == null ? 'Yeni Duyuru / Etkinlik' : 'Düzenle',
                  style: TextStyle(
                    color: AppColors.txt(context), fontSize: 22, fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: titleC,
                  style: TextStyle(color: AppColors.txt(context)),
                  decoration: const InputDecoration(hintText: 'Başlık'),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: descC,
                  maxLines: 3,
                  style: TextStyle(color: AppColors.txt(context)),
                  decoration: const InputDecoration(hintText: 'Açıklama'),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: AppColors.surf(context),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.surfLight(context)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedCategory,
                      isExpanded: true,
                      dropdownColor: AppColors.surf(context),
                      style: TextStyle(color: AppColors.txt(context), fontSize: 16),
                      items: _categories
                          .map((c) => DropdownMenuItem(
                                value: c,
                                child: Text(_categoryLabels[c] ?? c),
                              ))
                          .toList(),
                      onChanged: (v) => setModalState(() => selectedCategory = v!),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                GestureDetector(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2024),
                      lastDate: DateTime(2030),
                    );
                    if (picked != null) {
                      setModalState(() => selectedDate = picked);
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.surf(context),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.surfLight(context)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today, color: AppColors.txtHint(context), size: 18),
                        const SizedBox(width: 12),
                        Text(
                          DateFormat('dd MMMM yyyy', 'tr').format(selectedDate),
                          style: TextStyle(color: AppColors.txt(context), fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SwitchListTile(
                  title: Text('Aktif', style: TextStyle(color: AppColors.txt(context))),
                  value: isActive,
                  activeTrackColor: AppColors.success,
                  contentPadding: EdgeInsets.zero,
                  onChanged: (v) => setModalState(() => isActive = v),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () async {
                      final a = Announcement(
                        id: item?.id ?? '',
                        title: titleC.text.trim(),
                        description: descC.text.trim(),
                        category: selectedCategory,
                        date: selectedDate,
                        isActive: isActive,
                      );
                      if (item == null) {
                        await _firestore.addAnnouncement(a);
                      } else {
                        await _firestore.updateAnnouncement(item.id, a.toFirestore());
                      }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg(context),
      appBar: AppBar(title: const Text('Duyuru & Etkinlik')),
      body: StreamBuilder<List<Announcement>>(
        stream: _firestore.streamAnnouncements(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }
          final items = snapshot.data ?? [];
          if (items.isEmpty) {
            return Center(
              child: Text('Henüz duyuru yok', style: TextStyle(color: AppColors.txtSec(context))),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cardBg(context),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _categoryColor(item.category).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            _categoryLabels[item.category] ?? item.category,
                            style: TextStyle(
                              color: _categoryColor(item.category),
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (!item.isActive)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.error.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'Pasif',
                              style: TextStyle(color: AppColors.error, fontSize: 11),
                            ),
                          ),
                        const Spacer(),
                        Text(
                          DateFormat('dd/MM/yyyy').format(item.date),
                          style: TextStyle(color: AppColors.txtHint(context), fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(item.title, style: TextStyle(
                      color: AppColors.txt(context), fontSize: 16, fontWeight: FontWeight.w600,
                    )),
                    const SizedBox(height: 4),
                    Text(item.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: AppColors.txtSec(context), fontSize: 13),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: AppColors.primary, size: 20),
                          onPressed: () => _showAddEditDialog(item: item),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 20),
                          onPressed: () => _firestore.deleteAnnouncement(item.id),
                        ),
                      ],
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
        label: const Text('Duyuru Ekle', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Color _categoryColor(String category) {
    switch (category) {
      case 'event':
        return AppColors.primary;
      case 'announcement':
        return AppColors.warning;
      case 'exam':
        return AppColors.error;
      default:
        return AppColors.accent;
    }
  }
}
