import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_theme.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/models/business_model.dart';
import 'reviews_screen.dart';

class BusinessDetailScreen extends StatelessWidget {
  final Business business;

  const BusinessDetailScreen({super.key, required this.business});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final displayName = (!l.isTr && business.nameEn.isNotEmpty) ? business.nameEn : business.name;
    final displayDesc = (!l.isTr && business.descriptionEn.isNotEmpty) ? business.descriptionEn : business.description;
    return Scaffold(
      backgroundColor: AppColors.bg(context),
      appBar: AppBar(
        title: Text(displayName),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 200,
              color: AppColors.primary.withValues(alpha: 0.15),
              child: Center(
                child: Icon(
                  _categoryIcon(business.category),
                  size: 80,
                  color: AppColors.primary.withValues(alpha: 0.5),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          displayName,
                          style: TextStyle(
                            color: AppColors.txt(context),
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: business.isOpen
                              ? AppColors.success.withValues(alpha: 0.15)
                              : AppColors.error.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          business.isOpen ? l.open : l.closed,
                          style: TextStyle(
                            color: business.isOpen ? AppColors.success : AppColors.error,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: AppColors.warning, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        '${business.rating}',
                        style: TextStyle(
                          color: AppColors.txt(context),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${business.reviewCount} ${l.isTr ? 'değerlendirme' : 'reviews'})',
                        style: TextStyle(color: AppColors.txtSec(context), fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    displayDesc,
                    style: TextStyle(
                      color: AppColors.txtSec(context),
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildInfoRow(context, Icons.access_time, business.openHours),
                  if (business.phone.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () => _makeCall(business.phone),
                      child: _buildInfoRow(context, Icons.phone, business.phone, isLink: true),
                    ),
                  ],
                  const SizedBox(height: 12),
                  _buildInfoRow(context, Icons.category, business.category),
                  if (business.menu.isNotEmpty) ...[
                    const SizedBox(height: 32),
                    Text(
                      'Menü / Menu',
                      style: TextStyle(
                        color: AppColors.txt(context),
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...business.menu.map((item) => _buildMenuItem(context, item)),
                  ],
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ReviewsScreen(
                              targetId: business.id,
                              targetType: 'business',
                              targetName: business.name,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.rate_review),
                      label: Text(l.isTr ? 'Yorumları Gör' : 'See Reviews'),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String text, {bool isLink = false}) {
    return Row(
      children: [
        Icon(icon, color: AppColors.txtHint(context), size: 20),
        SizedBox(width: 12),
        Text(
          text,
          style: TextStyle(
            color: isLink ? AppColors.accent : AppColors.txtSec(context),
            fontSize: 15,
            decoration: isLink ? TextDecoration.underline : null,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(BuildContext context, MenuItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              item.name,
              style: TextStyle(
                color: AppColors.txt(context),
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            '₺${item.price.toStringAsFixed(0)}',
            style: const TextStyle(
              color: AppColors.accent,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _makeCall(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone.replaceAll(' ', ''));
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
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
