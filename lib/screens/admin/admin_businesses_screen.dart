import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/models/business_model.dart';
import '../../core/services/firestore_service.dart';

class AdminBusinessesScreen extends StatefulWidget {
  const AdminBusinessesScreen({super.key});

  @override
  State<AdminBusinessesScreen> createState() => _AdminBusinessesScreenState();
}

class _AdminBusinessesScreenState extends State<AdminBusinessesScreen> {
  final _firestore = FirestoreService();

  void _showAddEditDialog({Business? business}) {
    final nameC = TextEditingController(text: business?.name ?? '');
    final categoryC = TextEditingController(text: business?.category ?? '');
    final phoneC = TextEditingController(text: business?.phone ?? '');
    final descC = TextEditingController(text: business?.description ?? '');
    final hoursC = TextEditingController(text: business?.openHours ?? '');
    bool isOpen = business?.isOpen ?? true;

    final menuControllers = <_MenuItemControllers>[];
    if (business != null) {
      for (final item in business.menu) {
        menuControllers.add(_MenuItemControllers(
          name: TextEditingController(text: item.name),
          price: TextEditingController(text: item.price.toString()),
        ));
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => DraggableScrollableSheet(
          initialChildSize: 0.9,
          maxChildSize: 0.95,
          minChildSize: 0.5,
          expand: false,
          builder: (_, scrollController) => SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40, height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  business == null ? 'Yeni İşletme' : 'İşletme Düzenle',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 24),
                _buildField(nameC, 'İşletme Adı'),
                _buildField(categoryC, 'Kategori (Kafe, Restoran, Market, Hizmet)'),
                _buildField(phoneC, 'Telefon'),
                _buildField(descC, 'Açıklama', maxLines: 3),
                _buildField(hoursC, 'Çalışma Saatleri (ör: 08:00 - 22:00)'),
                const SizedBox(height: 8),
                SwitchListTile(
                  title: const Text('Açık mı?', style: TextStyle(color: AppColors.textPrimary)),
                  value: isOpen,
                  activeTrackColor: AppColors.success,
                  contentPadding: EdgeInsets.zero,
                  onChanged: (v) => setModalState(() => isOpen = v),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text(
                      'Menü Öğeleri',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.add_circle, color: AppColors.primary),
                      onPressed: () {
                        setModalState(() {
                          menuControllers.add(_MenuItemControllers(
                            name: TextEditingController(),
                            price: TextEditingController(),
                          ));
                        });
                      },
                    ),
                  ],
                ),
                ...menuControllers.asMap().entries.map((entry) {
                  final i = entry.key;
                  final mc = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextField(
                            controller: mc.name,
                            style: const TextStyle(color: AppColors.textPrimary),
                            decoration: const InputDecoration(hintText: 'Ürün adı'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 1,
                          child: TextField(
                            controller: mc.price,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: AppColors.textPrimary),
                            decoration: const InputDecoration(hintText: '₺'),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline, color: AppColors.error, size: 20),
                          onPressed: () => setModalState(() => menuControllers.removeAt(i)),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () async {
                      final menuItems = menuControllers
                          .where((mc) => mc.name.text.trim().isNotEmpty)
                          .map((mc) => MenuItem(
                                name: mc.name.text.trim(),
                                price: double.tryParse(mc.price.text.trim()) ?? 0,
                              ))
                          .toList();

                      final biz = Business(
                        id: business?.id ?? '',
                        name: nameC.text.trim(),
                        category: categoryC.text.trim(),
                        phone: phoneC.text.trim(),
                        description: descC.text.trim(),
                        openHours: hoursC.text.trim(),
                        isOpen: isOpen,
                        menu: menuItems,
                        rating: business?.rating ?? 0.0,
                        reviewCount: business?.reviewCount ?? 0,
                      );

                      if (business == null) {
                        await _firestore.addBusiness(biz);
                      } else {
                        await _firestore.updateBusiness(business.id, biz.toFirestore());
                      }

                      if (ctx.mounted) Navigator.pop(ctx);
                    },
                    child: Text(business == null ? 'Ekle' : 'Güncelle'),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController c, String hint, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: c,
        maxLines: maxLines,
        style: const TextStyle(color: AppColors.textPrimary),
        decoration: InputDecoration(hintText: hint),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('İşletme Yönetimi')),
      body: StreamBuilder<List<Business>>(
        stream: _firestore.streamBusinesses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }
          final businesses = snapshot.data ?? [];
          if (businesses.isEmpty) {
            return const Center(
              child: Text('Henüz işletme eklenmedi', style: TextStyle(color: AppColors.textSecondary)),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: businesses.length,
            itemBuilder: (context, index) {
              final biz = businesses[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
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
                        color: (biz.isOpen ? AppColors.success : AppColors.error).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        biz.isOpen ? Icons.store : Icons.store_outlined,
                        color: biz.isOpen ? AppColors.success : AppColors.error,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(biz.name, style: const TextStyle(
                            color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w600,
                          )),
                          Text('${biz.category} • ${biz.menu.length} menü öğesi',
                            style: const TextStyle(color: AppColors.textHint, fontSize: 12)),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: AppColors.primary, size: 20),
                      onPressed: () => _showAddEditDialog(business: biz),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 20),
                      onPressed: () => _confirmDelete(biz),
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
        label: const Text('İşletme Ekle', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  void _confirmDelete(Business biz) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Silmek istediğine emin misin?', style: TextStyle(color: AppColors.textPrimary)),
        content: Text('"${biz.name}" silinecek.', style: const TextStyle(color: AppColors.textSecondary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('İptal')),
          TextButton(
            onPressed: () {
              _firestore.deleteBusiness(biz.id);
              Navigator.pop(ctx);
            },
            child: const Text('Sil', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}

class _MenuItemControllers {
  final TextEditingController name;
  final TextEditingController price;
  _MenuItemControllers({required this.name, required this.price});
}
