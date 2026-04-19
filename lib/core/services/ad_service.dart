import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io';

class AdService {
  static final AdService _instance = AdService._internal();
  static AdService get instance => _instance;
  factory AdService() => _instance;
  AdService._internal();

  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  bool _isInitialized = false;
  bool _isDisabled = false;

  /// Call this to permanently disable ads (e.g. placeholder Firebase config)
  void disable() {
    _isDisabled = true;
  }

  // Test ad unit IDs - replace with real ones before release
  String get _bannerAdUnitId => Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111' // Android test
      : 'ca-app-pub-3940256099942544/2934735716'; // iOS test

  String get _interstitialAdUnitId => Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/1033173712' // Android test
      : 'ca-app-pub-3940256099942544/4411468910'; // iOS test

  // Rewarded ad unit IDs for future use
  // String get _rewardedAdUnitId => Platform.isAndroid
  //     ? 'ca-app-pub-3940256099942544/5224354917' // Android test
  //     : 'ca-app-pub-3940256099942544/1712485313'; // iOS test

  Future<void> initialize() async {
    if (_isInitialized || _isDisabled) return;
    if (!Platform.isAndroid && !Platform.isIOS) {
      debugPrint('AdService: Ads not supported on this platform');
      return;
    }
    await MobileAds.instance.initialize();
    _isInitialized = true;
  }

  bool get isSupported => Platform.isAndroid || Platform.isIOS;

  BannerAd createBannerAd({Function? onLoaded, Function? onFailed}) {
    return BannerAd(
      adUnitId: _bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) => onLoaded?.call(),
        onAdFailedToLoad: (ad, error) {
          try { ad.dispose(); } catch (_) {}
          onFailed?.call();
        },
      ),
    );
  }

  Future<void> loadInterstitialAd() async {
    if (!isSupported) return;
    await InterstitialAd.load(
      adUnitId: _interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _interstitialAd = ad,
        onAdFailedToLoad: (error) => _interstitialAd = null,
      ),
    );
  }

  Future<void> showInterstitialAd() async {
    if (!isSupported) return;
    if (_interstitialAd != null) {
      await _interstitialAd!.show();
      _interstitialAd = null;
      loadInterstitialAd(); // preload next
    }
  }

  void dispose() {
    try {
      _bannerAd?.dispose();
      _interstitialAd?.dispose();
    } catch (_) {}
  }
}
