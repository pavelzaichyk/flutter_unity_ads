# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter plugin (`unity_ads_plugin`) that wraps the native Unity Ads SDK for iOS and Android. Published on pub.dev, it supports Banner, Rewarded, and Interstitial Video Ads with privacy consent management (GDPR, CCPA, PIPL, Age Gate).

Current versions: Plugin `0.4.0`, Unity Ads SDK `4.18.1` (both platforms).

## Common Commands

```bash
# Install dependencies
flutter pub get

# Run tests
flutter test

# Analyze/lint
flutter analyze

# Run the example app
cd example && flutter run

# Android: rebuild native
cd android && ./gradlew build

# iOS: update pods
cd ios && pod install
```

To run a single test file:
```bash
flutter test test/unity_ads_test.dart
```

## Architecture

The plugin uses `MethodChannel` for Dart ↔ native communication:

- **Main channel:** `com.rebeloid.unity_ads` — handles `init`, `load`, `showVideo`, `privacyConsent_set`, `isInitialized`
- **Per-placement video channels:** `com.rebeloid.unity_ads/videoAd_{placementId}` — streams ad lifecycle events back to Dart
- **Per-view banner channels:** `com.rebeloid.unity_ads/bannerAd_{viewId}` — streams banner events back to Dart

### Dart Layer (`lib/src/`)

- `unity_ads.dart` — Core API: `UnityAds.init()`, `UnityAds.load()`, `UnityAds.showVideoAd()`, `UnityAds.setPrivacyConsent()`
- `unity_banner_ad.dart` — `UnityBannerAd` widget using `AndroidView`/`UiKitView` platform views
- `constants.dart` — Channel names and method string constants
- `privacy_consent.dart` — Privacy consent type enums

### Android (`android/src/main/java/com/rebeloid/unity_ads/`)

Java implementation. Key classes:
- `UnityAdsPlugin.java` — Main entry point, implements `FlutterPlugin` and `ActivityAware`
- `PlacementChannelManager.java` — Manages per-placement method channels
- `banner/BannerAdFactory.java` + `BannerAdView.java` — Platform view factory for banners

Min SDK: 19, Target SDK: 34. Unity Ads pulled from Maven Central.

### iOS (`ios/unity_ads_plugin/Sources/unity_ads_plugin/`)

Swift implementation. Key classes mirror the Android structure:
- `UnityAdsPlugin.swift` — Main entry point (`@objc(UnityAdsPlugin)`, registers via `register(with:)`)
- `PlacementChannelManager.swift` — Per-placement channel management
- `BannerAdFactory.swift` + `BannerAdView.swift` — Platform view factory

Platform minimum: iOS 13.0. The plugin supports **both** dependency managers:
- **Swift Package Manager** — `ios/unity_ads_plugin/Package.swift`, depends on the `UnityAds` product from `Unity-Ads-Swift-Package`.
- **CocoaPods** — `ios/unity_ads_plugin.podspec`, depends on `pod 'UnityAds', '4.18.1'`.

Both reference the same sources under `ios/unity_ads_plugin/Sources/unity_ads_plugin/`.

## SDK Version Updates

When updating the Unity Ads SDK version, change it in **all of these places**:
1. `android/build.gradle` — `implementation group: 'com.unity3d.ads', name: 'unity-ads', version: 'X.Y.Z'`
2. `ios/unity_ads_plugin.podspec` — `s.dependency 'UnityAds', 'X.Y.Z'` (CocoaPods)
3. `ios/unity_ads_plugin/Package.swift` — `.package(url: "...Unity-Ads-Swift-Package", from: "X.Y.Z")` (SPM)
4. `pubspec.yaml` — plugin version and description
5. `CHANGELOG.md` — add entry

## Key Notes

- Banner ads use Flutter's platform view mechanism (`PlatformViewFactory`) — each banner instance gets a unique view ID and its own method channel.
- Video ad listeners are retained per-placement in `PlacementChannelManager` to prevent premature deallocation (a previously fixed bug).
- iOS uses a custom `topMostViewController()` utility to safely walk the view controller stack for iOS 13+ compatibility.
- Android includes Firebase Test Lab detection to conditionally display ads in test environments.
- Dart SDK requirement: `>=2.12.0 <4.0.0` (null safety required).
