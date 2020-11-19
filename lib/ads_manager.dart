import 'package:ShareJoy/theme_data.dart';
import 'package:fb_audience_network_ad/ad/ad_banner.dart';
import 'package:fb_audience_network_ad/ad/ad_interstitial.dart';
import 'package:fb_audience_network_ad/ad/ad_native.dart';
import 'package:flutter/material.dart';

const MINITUE_IN_SECONDS = 60;
enum AdStatus { loading, success, error }

class AdsManager {
  DateTime lastAdRequested;
  int adLoadedThresholdInSeconds = MINITUE_IN_SECONDS * 5;
  int adErrorThresholdInSeconds = MINITUE_IN_SECONDS * 1;
  AdStatus status;

  static AdsManager instance;
  static void init() {
    if (instance == null) {
      instance = AdsManager();
    }
  }

  Widget fetchBannerOrNativeAd(int index, int step) {
    return index % step == 0
        ? index % (step * 2) == step
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: FacebookNativeAd(
                  placementId: "1265998170441655_1294758274232311",
                  adType: NativeAdType.NATIVE_AD_TEMPLATE,
                  listener: (result, value) {
                    print("Banner Ad $result --> $value");
                  },
                ),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: FacebookBannerAd(
                  placementId: "1265998170441655_1266012507106888",
                  bannerSize: BannerSize.STANDARD,
                  listener: (result, value) {
                    print("Banner Ad $result --> $value");
                  },
                ),
              )
        : CustomTheme.placeHolder;
  }

  void fetchInterestialAd() {
    if (status == AdStatus.loading) return;
    if (lastAdRequested == null) {
      _loadAd();
      return;
    }
    if (status == AdStatus.success &&
        lastAdRequested.difference(DateTime.now()).inSeconds >=
            adLoadedThresholdInSeconds) {
      _loadAd();
      return;
    }
    if (status == AdStatus.error &&
        lastAdRequested.difference(DateTime.now()).inSeconds >=
            adErrorThresholdInSeconds) {
      _loadAd();
      return;
    }
  }

  void _loadAd() {
    status = AdStatus.loading;
    lastAdRequested = DateTime.now();
    FacebookInterstitialAd.loadInterstitialAd(
        placementId: "1265998170441655_1298112503896888",
        listener: (InterstitialAdResult res, value) {
          print("interestial $value $res");
          if (res == InterstitialAdResult.LOADED) {
            print("show interstital ad");
            status = AdStatus.success;

            FacebookInterstitialAd.showInterstitialAd();
          } else {
            status = AdStatus.error;
          }
        });
  }
}
