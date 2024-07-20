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

[Flutter Unity Ads Example for Andoid](https://play.google.com/store/apps/details?id=com.rebeloid.unity_ads_example)

## Table of Contents

- [Getting Started](#getting-started)
    - [1. Initialization](#1-initialization)
    - [2. Show Rewarded/Interstitial Video Ad](#2-show-rewardedinterstitial-video-ad)
    - [3. Show Banner Ad](#3-show-banner-ad)
    - [Privacy consent](#privacy-consent)
    - [FAQ](#faq)
        - [Getting 'Unhandled Exception: PlatformException(error, Field loadTimeoutMs_ for j2.b2 not found....' when running the application on Android in release mode](#getting-unhandled-exception-platformexceptionerror-field-loadtimeoutms_-for-j2b2-not-found-when-running-the-application-on-android-in-release-mode)
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

`UnityAds.isInitialized()` can be used to check if the SDK is initialized successfully.

---

_Android only:_ To change ads behavior in Firebase Test Lab use `firebaseTestLabMode` parameter. Possible values:

Mode | Description 
--- | --- 
disableAds | Ads are not displayed in the Firebase Test Lab (by default)
showAdsInTestMode | Ads are displayed in test mode.
showAds | Real ads are displayed, if testMode is false.


Add `shrinkResources false` and `minifyEnabled false` to the `/android/app/build.gradle` file to prevent the runtime exception when running the application on Android in release mode.

```gradle
android {
...
    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig signingConfigs.debug

            shrinkResources false
            minifyEnabled false
        }
    }
}
```

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
  onShown: (placementId) => print('Banner shown: $placementId'),
  onFailed: (placementId, error, message) => print('Banner Ad $placementId failed: $error $message'),
)
```

### Privacy consent

Read more about privacy consent in [Unity Ads documentation](https://docs.unity.com/ads/ImplementingDataPrivacy.html).

Use the following code to pass the appropriate consent flags to the Unity Ads SDK:

```dart
UnityAds.setPrivacyConsent(<Privacy Consent type>, true)
```

### FAQ

#### Getting 'Unhandled Exception: PlatformException(error, Field loadTimeoutMs_ for j2.b2 not found....' when running the application on Android in release mode

Adding `shrinkResources false` and `minifyEnabled false` to the `/android/app/build.gradle` file resolves the problem.

```gradle
android {
...
    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig signingConfigs.debug

            shrinkResources false
            minifyEnabled false
        }
    }
}
```

## Donate

If you find this package helpful and would like to support its continued development, please consider making a donation. Your contributions are greatly appreciated and motivate the further enhancement of this and other plugins.

[![Donate](https://www.paypalobjects.com/en_US/PL/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/donate/?hosted_button_id=QE4E8RX8FW6P4)
[![Buy Me A Coffee](https://img.buymeacoffee.com/button-api/?text=Buy%20me%20a%20coffee&emoji=&slug=rebeloid&button_colour=FFDD00&font_colour=000000&font_family=Cookie&outline_colour=000000&coffee_colour=ffffff)](https://www.buymeacoffee.com/rebeloid)
[![PayPal](https://img.shields.io/badge/Donate-PayPal-066BB7?logo=paypal)](https://paypal.me/pavelzaichyk)

Your support helps in maintaining and improving this package, ensuring it remains up-to-date and useful for the community.

Thank you for your generosity!