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
    if (_isInitialized) return;
    await MobileAds.instance.initialize();
    _isInitialized = true;
  }

  BannerAd createBannerAd({Function? onLoaded, Function? onFailed}) {
    return BannerAd(
      adUnitId: _bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) => onLoaded?.call(),
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          onFailed?.call();
        },
      ),
    );
  }

  Future<void> loadInterstitialAd() async {
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
    if (_interstitialAd != null) {
      await _interstitialAd!.show();
      _interstitialAd = null;
      loadInterstitialAd(); // preload next
    }
  }

  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
  }
}
