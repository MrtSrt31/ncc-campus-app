import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../core/providers/ad_provider.dart';
import '../core/services/ad_service.dart';
import '../core/theme/app_theme.dart';

class AdBannerWidget extends StatefulWidget {
  const AdBannerWidget({super.key});

  @override
  State<AdBannerWidget> createState() => _AdBannerWidgetState();
}

class _AdBannerWidgetState extends State<AdBannerWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  bool get _isAdSupported => Platform.isAndroid || Platform.isIOS;

  @override
  void initState() {
    super.initState();
    if (_isAdSupported) _loadAd();
  }

  void _loadAd() {
    try {
      _bannerAd = AdService.instance.createBannerAd(
        onLoaded: () {
          if (mounted) setState(() => _isLoaded = true);
        },
        onFailed: () {
          if (mounted) setState(() => _isLoaded = false);
        },
      );
      _bannerAd?.load();
    } catch (e) {
      debugPrint('AdBannerWidget: Failed to load ad: $e');
    }
  }

  @override
  void dispose() {
    try {
      _bannerAd?.dispose();
    } catch (_) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final adProvider = context.watch<AdProvider>();

    if (!adProvider.shouldShowBanner()) return const SizedBox.shrink();

    if (_isLoaded && _bannerAd != null) {
      return Container(
        width: double.infinity,
        height: 60,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        alignment: Alignment.center,
        child: AdWidget(ad: _bannerAd!),
      );
    }

    // Fallback placeholder while ad loads
    return Container(
      width: double.infinity,
      height: 60,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: const Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.campaign_outlined, color: AppColors.textHint, size: 18),
            SizedBox(width: 8),
            Text(
              'Reklam Alanı',
              style: TextStyle(color: AppColors.textHint, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
