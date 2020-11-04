import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'src/constants.dart';

/// Unity Ads plugin for Flutter applications.
class UnityAds {
  static final MethodChannel _channel = const MethodChannel(mainChannel);

  /// Initialize Unity Ads.
  ///
  /// * [gameId] - identifier from Project Settings in Unity Dashboard.
  /// * [testMode] - if true, then test ads are shown.
  /// * [firebaseTestLabMode] - mode of showing ads in Firebase Test Lab.
  static Future<bool> init({
    @required String gameId,
    bool testMode = false,
    FirebaseTestLabMode firebaseTestLabMode = FirebaseTestLabMode.disableAds,
    Function(UnityAdState, dynamic) listener,
  }) async {
    Map<String, dynamic> arguments = {
      gameIdParameter: gameId,
      testModeParameter: testMode,
      firebaseTestLabModeParameter:
          firebaseTestLabMode.toString().split('.').last,
    };
    try {
      if (listener != null) {
        _channel.setMethodCallHandler((call) => _methodCall(call, listener));
      }
      final result = await _channel.invokeMethod(initMethod, arguments);
      return result;
    } on PlatformException {
      return false;
    }
  }

  /// Check if placement is ready to show ads
  ///
  /// [placementId] placement identifier, as defined in Unity Ads admin tools
  ///  If true, placement is ready to show ads
  static Future<bool> isReady({@required String placementId}) async {
    try {
      final arguments = <String, dynamic>{
        placementIdParameter: placementId,
      };
      final result = await _channel.invokeMethod(isReadyMethod, arguments);

      return result;
    } on PlatformException {
      return false;
    }
  }

  static Map<String, MethodChannel> _channels = Map();

  /// Show video ad, if ready.
  ///
  /// [placementId] placement identifier, as defined in Unity Ads admin tools
  /// If true, placement are shown
  static Future<bool> showVideoAd(
      {@required String placementId,
      Function(UnityAdState, dynamic) listener}) async {
    try {
      if (listener != null) {
        _channels
            .putIfAbsent(placementId,
                () => MethodChannel('${videoAdChannel}_$placementId'))
            .setMethodCallHandler((call) => _methodCall(call, listener));
      }

      final args = <String, dynamic>{
        placementIdParameter: placementId,
      };
      final result = await _channel.invokeMethod(showVideoMethod, args);
      print(result);
      return result;
    } on PlatformException {
      return false;
    }
  }

  static Future<dynamic> _methodCall(
      MethodCall call, Function(UnityAdState, dynamic) listener) {
    switch (call.method) {
      case readyMethod:
        listener(UnityAdState.ready, call.arguments);
        break;
      case startMethod:
        listener(UnityAdState.started, call.arguments);
        break;
      case completeMethod:
        listener(UnityAdState.complete, call.arguments);
        break;
      case skippedMethod:
        listener(UnityAdState.skipped, call.arguments);
        break;
      case errorMethod:
        listener(UnityAdState.error, call.arguments);
        break;
    }
    return Future.value(true);
  }
}

enum UnityAdState {
  /// Ad loaded successfully.
  ready,

  /// Some error occurred
  error,

  /// Video ad started.
  started,

  /// Video played till the end. Use it to reward the user.
  complete,

  /// Video ad closed.
  skipped,
}

enum FirebaseTestLabMode {
  /// Ads are not displayed in the Firebase Test Lab
  disableAds,

  /// Ads are displayed in test mode.
  showAdsInTestMode,

  /// Real ads are displayed, if [testMode] is false.
  showAds,
}
