# unity_ads_plugin

[![Pub](https://img.shields.io/pub/v/unity_ads_plugin.svg)](https://pub.dev/packages/unity_ads_plugin)

[Unity Ads](https://unity.com/solutions/unity-ads) plugin for Flutter Applications (Android).  This plugin is able to display Unity Banner Ads and Unity Video Ads.

iOS support is in development.

## Getting Started

### 1. Initialization:

```dart
UnityAds.init(gameId: "game_id");
```
Set your Game id.
For testing purposes set `testMode` to `true`.


### 2. Show Banner Ad:

![Banner Ad](https://github.com/pavzay/flutter_unity_ads/raw/master/example/images/banner.gif "Banner Ad")


Place `UnityBannerAd` widget in your app.


```dart
UnityBannerAd(
  placementId: "banner_placement_id",
)
```

### 3. Show Rewarded Video Ad:

![Rewarded Video Ad](https://github.com/pavzay/flutter_unity_ads/raw/master/example/images/rewarded.gif "Rewarded Video Ad")


```dart
UnityAds.showVideoAd(
  placementId: 'rewarded_video_placement_id',
  listener: (state, args) {
    if (state == UnityAdState.complete) {
      print('User watched a video. User should get a reward!');
    } else if (state == UnityAdState.skipped) {
      print('User cancel video.');
    }
  },
);
```

### 4. Show Interstitial Video Ad:

![Interstitial Video Ad](https://github.com/pavzay/flutter_unity_ads/raw/master/example/images/interstitial.gif "Interstitial Video Ad")


```dart
UnityAds.showVideoAd(
  placementId: 'video_placement_id',
  listener: (state, args) {
    if (state == UnityAdState.started) {
      print('User started watching the video!');
    }
  },
);
```
