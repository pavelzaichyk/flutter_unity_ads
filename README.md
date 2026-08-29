# Unity Ads Plugin

[![Pub](https://img.shields.io/pub/v/unity_ads_plugin.svg)](https://pub.dev/packages/unity_ads_plugin)
[![License](https://img.shields.io/github/license/pavelzaichyk/flutter_unity_ads)](https://github.com/pavelzaichyk/flutter_unity_ads/blob/master/LICENSE)
[![Pub likes](https://badgen.net/pub/likes/unity_ads_plugin)](https://pub.dev/packages/unity_ads_plugin/score)
[![Monthly downloads](https://badgen.net/pub/dm/unity_ads_plugin)](https://pub.dev/packages/unity_ads_plugin/score)
[![Pub points](https://badgen.net/pub/points/unity_ads_plugin)](https://pub.dev/packages/unity_ads_plugin/score)
[![Flutter platform](https://badgen.net/pub/flutter-platform/unity_ads_plugin)](https://pub.dev/packages/unity_ads_plugin)

[![Buy Me A Coffee](https://img.shields.io/badge/Donate-Buy%20me%20a%20coffee-FFDD00?logo=buymeacoffee)](https://www.buymeacoffee.com/rebeloid)
[![PayPal](https://img.shields.io/badge/Donate-PayPal-066BB7?logo=paypal)](https://paypal.me/pavelzaichyk)

📢 Follow for updates: [t.me/pavelzaichyk_dev](https://t.me/pavelzaichyk_dev)

A Flutter plugin for integrating [Unity Ads](https://docs.unity.com/ads/UnityAdsHome.htm) into your mobile applications. Easily display Unity Banner Ads and Unity Video Ads (Rewarded & Interstitial) with simple Dart APIs.

---

## Features

- Display Unity Banner, Rewarded, and Interstitial Video Ads
- Simple initialization and ad loading
- Server-to-server reward callback support
- Privacy consent management
- Firebase Test Lab support (Android)
- Null safety

---

## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Usage Example](#usage-example)
- [Getting Started](#getting-started)
  - [1. Initialization](#1-initialization)
  - [2. Show Rewarded/Interstitial Video Ad](#2-show-rewardedinterstitial-video-ad)
  - [3. Show Banner Ad](#3-show-banner-ad)
  - [Privacy Consent](#privacy-consent)
- [Troubleshooting](#troubleshooting)
  - [Android: the ad shows up as a separate app in Recent Apps](#android-the-ad-shows-up-as-a-separate-app-in-recent-apps)
- [Donate](#donate)

---

## Installation

Add the plugin to your `pubspec.yaml`:

```yaml
dependencies:
  unity_ads_plugin: ^<latest_version>
```

Then run:

```sh
flutter pub get
```

---

## Usage Example

Here is a minimal example of using the plugin:

```dart
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

void main() {
  UnityAds.init(
    gameId: 'YOUR_GAME_ID',
    testMode: true,
    onComplete: () => print('Unity Ads Initialized'),
    onFailed: (error, message) => print('Unity Ads Initialization Failed: $error $message'),
  );
}
```

For more detailed usage, see the [Getting Started](#getting-started) section.

---

## Getting Started

### 1. Initialization

```dart
UnityAds.init(
  gameId: 'PROJECT_GAME_ID',
  onComplete: () => print('Initialization Complete'),
  onFailed: (error, message) => print('Initialization Failed: $error $message'),
);
```

Set your Game ID.
For testing purposes, set `testMode` to `true`.

`UnityAds.isInitialized()` can be used to check if the SDK has initialized successfully.

---

_Android only:_ To change ad behavior in Firebase Test Lab, use the `firebaseTestLabMode` parameter. Possible values:

| Mode              | Description                                              |
|-------------------|----------------------------------------------------------|
| disableAds        | Ads are not displayed in Firebase Test Lab (default)     |
| showAdsInTestMode | Ads are displayed in test mode.                          |
| showAds           | Real ads are displayed if `testMode` is false.           |

### 2. Show Rewarded/Interstitial Video Ad

![Rewarded Video Ad](https://i.giphy.com/media/InPCZIuZspVEfmTGga/giphy.gif "Rewarded Video Ad")
![Interstitial Video Ad](https://i.giphy.com/media/8wEtgrnfLNqUY4mllS/giphy.gif "Interstitial Video Ad")

Load a video ad before showing it.

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

#### Server-to-server Redeem Callbacks

`UnityAds.showVideoAd` has a `serverId` parameter. To use server-to-server callbacks, set this parameter. Read more at [docs.unity.com](https://docs.unity.com/ads/ImplementingS2SRedeemCallbacks.htm).

### 3. Show Banner Ad

![Banner Ad](https://i.giphy.com/media/aQvnz1i8xn6EWO5bo0/giphy.gif "Banner Ad")

Place the `UnityBannerAd` widget in your app.

```dart
UnityBannerAd(
  placementId: 'PLACEMENT_ID',
  onLoad: (placementId) => print('Banner loaded: $placementId'),
  onClick: (placementId) => print('Banner clicked: $placementId'),
  onShown: (placementId) => print('Banner shown: $placementId'),
  onFailed: (placementId, error, message) => print('Banner Ad $placementId failed: $error $message'),
)
```

### Privacy Consent

Read more about privacy consent in the [Unity Ads documentation](https://docs.unity.com/ads/ImplementingDataPrivacy.html).

Use the following code to pass the appropriate consent flags to the Unity Ads SDK:

```dart
UnityAds.setPrivacyConsent(<Privacy Consent type>, true)
```

---

## Troubleshooting

### Android: the ad shows up as a separate app in Recent Apps

**Symptom.** While a fullscreen ad (interstitial or rewarded) is playing, opening Recent Apps
shows *two* cards for your app: your app and the ad. The user can swipe the ad away in one
gesture, so the ad never completes and the impression is lost.

**Why it happens.** Android groups screens into *tasks* — one task is one card in Recent Apps.
Which task a screen joins is decided by a label called *task affinity*: by default every screen
in your app shares the same affinity (your package name) and therefore the same card.

Unity's ad screen is launched with `FLAG_ACTIVITY_NEW_TASK`. That flag doesn't mean "make a new
card" — it means "put me in the task I belong to", and Android picks that task by matching
affinities ([Tasks and the back stack](https://developer.android.com/guide/components/activities/tasks-and-back-stack)):

> If there's an existing task with the same affinity as the new activity, the activity is
> launched into that task. If not, it begins a new task.

Since 2024 the Flutter app template stamps `MainActivity` with a *blank* affinity
([flutter#144018](https://github.com/flutter/flutter/pull/144018)), while Unity's ad screen keeps
the default one. The labels don't match, so Android opens a second task — a second card.

**Fix.** Delete one line from your app's `android/app/src/main/AndroidManifest.xml`:

```xml
<activity
    android:name=".MainActivity"
    android:taskAffinity=""     <!-- delete this line -->
    ...>
```

Both screens then share the default affinity, the ad joins your app's task, and Recent Apps
shows a single card again. This is a change in *your app* — the plugin cannot override it,
because the attribute lives in your manifest and the ad screen is declared inside Unity's SDK.

**Trade-off.** `android:taskAffinity=""` is there to block *task hijacking*, where a malicious
app already installed on the device claims your affinity and slips a fake screen (say, a login
form) in front of your user.

How much you give up depends on your `minSdk`. Per Android's own
[StrandHogg / task affinity](https://developer.android.com/privacy-and-security/risks/strandhogg)
page:

> Android SDK versions 30 and newer (Android 11) contain the appropriate OS patches to avoid
> this vulnerability.

> While it is possible to partially mitigate version 1 of the StrandHogg attack through
> individual application configuration, version 2 of the attack can only be prevented by this
> SDK version patch.

- **`minSdk` 30 or higher** — the OS already blocks both variants of the attack. The attribute
  buys you nothing; delete it.
- **`minSdk` 24–29** (Flutter's default is 24) — users on Android 7–10 lose partial protection
  against one variant of the attack. Android's recommended fix is raising `minSdk` to 30, which
  also resolves the Recent Apps problem as a side effect.

Apps handling logins, payments, or personal data on Android 7–10 may prefer to keep the
attribute and accept the lost impressions. That's a decision for your app, not the plugin.

**What doesn't work.** Adding `android:excludeFromRecents="true"` to Unity's ad activity (via
`tools:replace`) does not help — the ad still gets its own card while it is on screen. Neither
does setting a matching `android:taskAffinity=""` on Unity's activity: a blank affinity never
matches an existing task, so Android still creates a new one.

See [issue #70](https://github.com/pavelzaichyk/flutter_unity_ads/issues/70).

---

## Donate

If you find this package helpful and would like to support its continued development, please consider making a donation. Your contributions are greatly appreciated and motivate the further enhancement of this and other plugins.

[![Donate](https://www.paypalobjects.com/en_US/PL/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/donate/?hosted_button_id=QE4E8RX8FW6P4)
[![Buy Me A Coffee](https://img.buymeacoffee.com/button-api/?text=Buy%20me%20a%20coffee&emoji=&slug=rebeloid&button_colour=FFDD00&font_colour=000000&font_family=Cookie&outline_colour=000000&coffee_colour=ffffff)](https://www.buymeacoffee.com/rebeloid)
[![PayPal](https://img.shields.io/badge/Donate-PayPal-066BB7?logo=paypal)](https://paypal.me/pavelzaichyk)

Your support helps maintain and improve this package, ensuring it remains up-to-date and useful for the community.

Thank you for your generosity!