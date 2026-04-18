import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/models/social_models.dart';
import '../../core/providers/auth_provider.dart';
import '../../widgets/ad_banner_widget.dart';
import 'package:timeago/timeago.dart' as timeago;

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  FirebaseFirestore get _db => FirebaseFirestore.instance;
  bool get _fbAvailable => Firebase.apps.isNotEmpty;
  String _selectedCategory = 'all';

  static const _categories = [
    'all', 'books', 'electronics', 'clothing', 'furniture', 'other',
  ];

  String _categoryLabel(String cat, AppLocalizations l) {
    switch (cat) {
      case 'all': return l.all;
      case 'books': return l.books;
      case 'electronics': return l.electronics;
      case 'clothing': return l.clothing;
      case 'furniture': return l.furniture;
      default: return l.other;
    }
  }

  IconData _categoryIcon(String cat) {
    switch (cat) {
      case 'books': return Icons.menu_book;
      case 'electronics': return Icons.devices;
      case 'clothing': return Icons.checkroom;
      case 'furniture': return Icons.chair;
      default: return Icons.category;
    }
  }

  void _showAddDialog() {
    final auth = context.read<AuthProvider>();
    final l = AppLocalizations.of(context);
    if (!auth.isLoggedIn) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.loginRequired), backgroundColor: AppColors.error),
      );
      return;
    }

    final titleC = TextEditingController();
    final descC = TextEditingController();
    final priceC = TextEditingController();
    final contactC = TextEditingController();
    String cat = 'electronics';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
        child: StatefulBuilder(
          builder: (context, setModalState) => SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(width: 40, height: 4,
                    decoration: BoxDecoration(color: AppColors.surfaceLight, borderRadius: BorderRadius.circular(2))),
                ),
                const SizedBox(height: 20),
                Text(l.addListing, style: const TextStyle(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.w700)),
                const SizedBox(height: 20),
                TextField(
                  controller: titleC,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: InputDecoration(hintText: l.title),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descC,
                  maxLines: 3,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: InputDecoration(hintText: l.description),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: priceC,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: InputDecoration(hintText: '${l.price} (₺)'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: contactC,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: InputDecoration(hintText: l.contact),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.surfaceLight),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: cat,
                      isExpanded: true,
                      dropdownColor: AppColors.surface,
                      style: const TextStyle(color: AppColors.textPrimary, fontSize: 16),
                      items: _categories.where((c) => c != 'all').map((c) =>
                        DropdownMenuItem(value: c, child: Text(_categoryLabel(c, l)))).toList(),
                      onChanged: (v) => setModalState(() => cat = v!),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () async {
                      final title = titleC.text.trim();
                      final price = double.tryParse(priceC.text.trim());
                      if (title.isEmpty || price == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l.fillAllFields), backgroundColor: AppColors.error),
                        );
                        return;
                      }
                      await _db.collection('marketplace').add(MarketplaceListing(
                        id: '',
                        title: title,
                        description: descC.text.trim(),
                        price: price,
                        category: cat,
                        userId: auth.currentUser?.uid ?? '',
                        userName: auth.displayName ?? '',
                        contactInfo: contactC.text.trim(),
                      ).toFirestore());
                      if (ctx.mounted) Navigator.pop(ctx);
                    },
                    child: Text(l.addListing),
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
    final l = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(l.marketplaceTitle)),
      body: Column(
        children: [
          const AdBannerWidget(),
          _buildCategoryFilter(l),
          Expanded(child: _buildListingsList(l)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddDialog,
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(l.addListing, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildCategoryFilter(AppLocalizations l) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final cat = _categories[index];
          final selected = cat == _selectedCategory;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => setState(() => _selectedCategory = cat),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: selected ? AppColors.primary : AppColors.card,
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                child: Text(
                  _categoryLabel(cat, l),
                  style: TextStyle(
                    color: selected ? Colors.white : AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildListingsList(AppLocalizations l) {
    if (!_fbAvailable) return _buildEmpty(l);
    Query<Map<String, dynamic>> query = _db
        .collection('marketplace')
        .where('isSold', isEqualTo: false)
        .orderBy('createdAt', descending: true);
    if (_selectedCategory != 'all') {
      query = query.where('category', isEqualTo: _selectedCategory);
    }

    return StreamBuilder<QuerySnapshot>(
      stream: query.limit(50).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmpty(l);
        }

        final listings = snapshot.data!.docs
            .map((d) => MarketplaceListing.fromFirestore(d))
            .toList();

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
          itemCount: listings.length,
          itemBuilder: (context, index) => _ListingCard(
            listing: listings[index],
            l: l,
            categoryIcon: _categoryIcon(listings[index].category),
          ),
        );
      },
    );
  }

  Widget _buildEmpty(AppLocalizations l) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.storefront, size: 64, color: AppColors.textHint.withValues(alpha: 0.5)),
          const SizedBox(height: 16),
          Text(l.noListings, style: const TextStyle(color: AppColors.textSecondary, fontSize: 16)),
          const SizedBox(height: 8),
          Text(l.listingHint, style: const TextStyle(color: AppColors.textHint, fontSize: 14)),
        ],
      ),
    );
  }
}

class _ListingCard extends StatelessWidget {
  final MarketplaceListing listing;
  final AppLocalizations l;
  final IconData categoryIcon;

  const _ListingCard({
    required this.listing,
    required this.l,
    required this.categoryIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(categoryIcon, color: AppColors.accent, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(listing.title,
                        style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w600)),
                    Text(listing.userName,
                        style: const TextStyle(color: AppColors.textHint, fontSize: 12)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${listing.price.toStringAsFixed(0)} ₺',
                  style: const TextStyle(color: AppColors.success, fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          if (listing.description.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(listing.description,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 14, height: 1.4),
                maxLines: 3, overflow: TextOverflow.ellipsis),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              if (listing.contactInfo.isNotEmpty) ...[
                const Icon(Icons.phone, size: 14, color: AppColors.textHint),
                const SizedBox(width: 6),
                Text(listing.contactInfo,
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                const Spacer(),
              ],
              if (listing.createdAt != null)
                Text(timeago.format(listing.createdAt!, locale: 'tr'),
                    style: const TextStyle(color: AppColors.textHint, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}
