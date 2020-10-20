# unity_ads_plugin


[Unity Ads](https://unity.com/solutions/unity-ads) plugin for Flutter Applications (Android).

## Getting Started

### 1. Initialization:

```dart
UnityAds.init(gameId: "game_id", testMode: true);
```
Set your Game id.
For testing purposes set `testMode` to `true`.


### 2. Show Banner Ad:

![Banner Ad](/example/images/banner.gif "Banner Ad")


Place `UnityBannerAd` widget in your app.


```dart
UnityBannerAd(
  placementId: "banner_placement_id",
)
```

### 3. Show Rewarded Video Ad:

![Rewarded Video Ad](/example/images/rewarded.gif "Rewarded Video Ad")


```dart
UnityAds.showVideoAd(
  placementId: 'rewarded_video_placement_id',
  listener: (state, args) {
    if (state == UnityAdState.complete) {
      print('User watched a video. User should get a reward!');
    }
    if (state == UnityAdState.skipped) {
      print('User cancel video.');
    }
  },
);
```

### 4. Show Interstitial Video Ad:

![Interstitial Video Ad](/example/images/interstitial.gif "Interstitial Video Ad")


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
