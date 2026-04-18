import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/data/sample_data.dart';
import '../../core/models/business_model.dart';
import '../../core/services/firestore_service.dart';
import '../../widgets/ad_banner_widget.dart';
import 'business_detail_screen.dart';

class CampusDirectoryScreen extends StatefulWidget {
  const CampusDirectoryScreen({super.key});

  @override
  State<CampusDirectoryScreen> createState() => _CampusDirectoryScreenState();
}

class _CampusDirectoryScreenState extends State<CampusDirectoryScreen> {
  String _selectedCategory = 'Tümü';
  String _searchQuery = '';
  bool _showOnlyOpen = false;
  final _firestore = FirestoreService();

  List<Business> _filterList(List<Business> list) {
    var result = list;
    if (_selectedCategory != 'Tümü') {
      result = result.where((b) => b.category == _selectedCategory).toList();
    }
    if (_showOnlyOpen) {
      result = result.where((b) => b.isOpen).toList();
    }
    if (_searchQuery.isNotEmpty) {
      result = result
          .where((b) => b.name.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l.campusDirectory),
        actions: [
          IconButton(
            icon: Icon(
              _showOnlyOpen ? Icons.toggle_on : Icons.toggle_off_outlined,
              color: _showOnlyOpen ? AppColors.success : AppColors.textHint,
              size: 32,
            ),
            tooltip: l.onlyOpenOnes,
            onPressed: () => setState(() => _showOnlyOpen = !_showOnlyOpen),
          ),
        ],
      ),
      body: Column(
        children: [
          const AdBannerWidget(),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: TextField(
              onChanged: (v) => setState(() => _searchQuery = v),
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: l.searchBusiness,
                prefixIcon: const Icon(Icons.search, color: AppColors.textHint),
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: SampleData.categories.length,
              itemBuilder: (context, index) {
                final cat = SampleData.categories[index];
                final isSelected = cat == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    selected: isSelected,
                    label: Text(_localizedCategory(cat, l)),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                    backgroundColor: AppColors.surface,
                    selectedColor: AppColors.primary,
                    checkmarkColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onSelected: (_) => setState(() => _selectedCategory = cat),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: StreamBuilder<List<Business>>(
              stream: _firestore.streamBusinesses(),
              builder: (context, snapshot) {
                // Use Firestore data if available, otherwise fall back to sample data
                final businesses = (snapshot.hasData && snapshot.data!.isNotEmpty)
                    ? snapshot.data!
                    : SampleData.businesses;
                final filtered = _filterList(businesses);
                if (filtered.isEmpty) {
                  return Center(
                    child: Text(
                      l.noBusinessFound,
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                  );
                }
                return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      return _buildBusinessCard(filtered[index]);
                    },
                  );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBusinessCard(Business business) {
    final l = AppLocalizations.of(context);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BusinessDetailScreen(business: business),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                _categoryIcon(business.category),
                color: AppColors.primary,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          (!l.isTr && business.nameEn.isNotEmpty) ? business.nameEn : business.name,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: business.isOpen
                              ? AppColors.success.withValues(alpha: 0.15)
                              : AppColors.error.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          business.isOpen ? l.open : l.closed,
                          style: TextStyle(
                            color: business.isOpen ? AppColors.success : AppColors.error,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        _localizedCategory(business.category, l),
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.star, color: AppColors.warning, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        '${business.rating} (${business.reviewCount})',
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textHint),
          ],
        ),
      ),
    );
  }

  String _localizedCategory(String cat, AppLocalizations l) {
    switch (cat) {
      case 'Tümü': return l.all;
      case 'Kafe': return l.cafe;
      case 'Restoran': return l.restaurant;
      case 'Market': return l.market;
      case 'Hizmet': return l.service;
      default: return cat;
    }
  }

  IconData _categoryIcon(String category) {
    switch (category) {
      case 'Kafe':
        return Icons.coffee;
      case 'Restoran':
        return Icons.restaurant;
      case 'Market':
        return Icons.shopping_bag;
      case 'Hizmet':
        return Icons.build;
      default:
        return Icons.store;
    }
  }
}
