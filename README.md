# Unity Ads Plugin

[![Pub](https://img.shields.io/pub/v/unity_ads_plugin.svg)](https://pub.dev/packages/unity_ads_plugin)
[![License](https://img.shields.io/github/license/pavelzaichyk/flutter_unity_ads)](https://github.com/pavelzaichyk/flutter_unity_ads/blob/master/LICENSE)
[![Pub likes](https://badgen.net/pub/likes/unity_ads_plugin)](https://pub.dev/packages/unity_ads_plugin/score)
[![Pub popularity](https://badgen.net/pub/popularity/unity_ads_plugin)](https://pub.dev/packages/unity_ads_plugin/score)
[![Pub points](https://badgen.net/pub/points/unity_ads_plugin)](https://pub.dev/packages/unity_ads_plugin/score)
[![Flutter platform](https://badgen.net/pub/flutter-platform/unity_ads_plugin)](https://pub.dev/packages/unity_ads_plugin)


[![Buy Me A Coffee](https://img.shields.io/badge/Donate-Buy%20me%20a%20coffee-FFDD00?logo=buymeacoffee)](https://www.buymeacoffee.com/rebeloid)
[![PayPal](https://img.shields.io/badge/Donate-PayPal-066BB7?logo=paypal)](https://paypal.me/pavelzaichyk)

[Unity Ads](https://docs.unity.com/ads/UnityAdsHome.htm) plugin for Flutter Applications. This plugin is able to display Unity Banner Ads and Unity Video Ads.

> If you want to try [Unity Mediation (Beta)](https://docs.unity.com/mediation/IntroToMediation.htm) use [Unity Mediation plugin](https://pub.dev/packages/unity_mediation) instead of this one.

- [Getting Started](#getting-started)
    - [1. Initialization](#1-initialization)
    - [2. Show Rewarded/Interstitial Video Ad](#2-show-rewardedinterstitial-video-ad)
    - [3. Show Banner Ad](#3-show-banner-ad)
- [Donate](#donate)

## Getting Started

### 1. Initialization:

```dart
UnityAds.init(
  gameId: 'PROJECT_GAME_ID',
  onComplete: () => print('Initialization Complete'),
  onFailed: (error, message) => print('Initialization Failed: $error $message'),
);
```

Set your Game ID.
For testing purposes set `testMode` to `true`.

---

_Android only:_ To change ads behavior in Firebase Test Lab use `firebaseTestLabMode` parameter. Possible values:

Mode | Description 
--- | --- 
disableAds | Ads are not displayed in the Firebase Test Lab (by default)
showAdsInTestMode | Ads are displayed in test mode.
showAds | Real ads are displayed, if testMode is false.

### 2. Show Rewarded/Interstitial Video Ad:

![Rewarded Video Ad](https://i.giphy.com/media/InPCZIuZspVEfmTGga/giphy.gif "Rewarded Video Ad")
![Interstitial Video Ad](https://i.giphy.com/media/8wEtgrnfLNqUY4mllS/giphy.gif "Interstitial Video Ad")

Load a video ad before show it.

```dart
UnityAds.load(
  placementId: 'PLACEMENT_ID',
  onComplete: (placementId) => print('Load Complete $placementId'),
  onFailed: (placementId, error, message) => print('Load Failed $placementId: $error $message'),
);
```

Show a loaded ad.

```dart
UnityAds.showVideoAd(
  placementId: 'PLACEMENT_ID',
  onStart: (placementId) => print('Video Ad $placementId started'),
  onClick: (placementId) => print('Video Ad $placementId click'),
  onSkipped: (placementId) => print('Video Ad $placementId skipped'),
  onComplete: (placementId) => print('Video Ad $placementId completed'),
  onFailed: (placementId, error, message) => print('Video Ad $placementId failed: $error $message'),
);
```

#### Server-to-server redeem callbacks

`UnityAds.showVideoAd` has `serverId` parameter.

To use server-to-server callbacks, you need to set this parameter.

Read more on [docs.unity.com](https://docs.unity.com/ads/ImplementingS2SRedeemCallbacks.htm).

### 3. Show Banner Ad:

![Banner Ad](https://i.giphy.com/media/aQvnz1i8xn6EWO5bo0/giphy.gif "Banner Ad")

Place `UnityBannerAd` widget in your app.

```dart
UnityBannerAd(
  placementId: 'PLACEMENT_ID',
  onLoad: (placementId) => print('Banner loaded: $placementId'),
  onClick: (placementId) => print('Banner clicked: $placementId'),
  onFailed: (placementId, error, message) => print('Banner Ad $placementId failed: $error $message'),
)
```

## Donate

If you found this plugin helpful and would like to thank me:

[![Buy Me A Coffee](https://img.shields.io/badge/Donate-Buy%20me%20a%20coffee-FFDD00?logo=buymeacoffee)](https://www.buymeacoffee.com/rebeloid)
[![PayPal](https://img.shields.io/badge/Donate-PayPal-066BB7?logo=paypal)](https://paypal.me/pavelzaichyk)
