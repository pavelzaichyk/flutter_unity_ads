import 'package:flutter/services.dart';

import 'constants.dart';

/// Unity Ads plugin for Flutter applications.
class UnityAds {
  static const MethodChannel _channel = MethodChannel(mainChannel);

  static final Map<String, MethodChannel> _channels = {};

  /// Initializes UnityAds. UnityAds should be initialized when app starts.
  ///
  /// * [gameId] - unique identifier for a game, given by Unity Ads admin tools.
  /// * [testMode] - if true, then only test ads are shown.
  /// * [firebaseTestLabMode] - mode of showing ads in Firebase Test Lab.
  /// * [onComplete] - called when `UnityAds` is successfully initialized
  /// * [onFailed] - called when `UnityAds` is failed in initialization.
  static Future<void> init({
    required String gameId,
    bool testMode = false,
    FirebaseTestLabMode firebaseTestLabMode = FirebaseTestLabMode.disableAds,
    Function? onComplete,
    Function(UnityAdsInitializationError error, String errorMessage)? onFailed,
  }) async {
    Map<String, dynamic> arguments = {
      gameIdParameter: gameId,
      testModeParameter: testMode,
      firebaseTestLabModeParameter:
          firebaseTestLabMode.toString().split('.').last,
    };
    _channel.setMethodCallHandler(
        (call) => _initMethodCall(call, onComplete, onFailed));
    await _channel.invokeMethod(initMethod, arguments);
  }

  static Future<dynamic> _initMethodCall(
    MethodCall call,
    Function? onComplete,
    Function(UnityAdsInitializationError, String)? onFailed,
  ) {
    switch (call.method) {
      case initCompleteMethod:
        onComplete?.call();
        break;
      case initFailedMethod:
        onFailed?.call(
            _initializationErrorFromString(call.arguments[errorCodeParameter]),
            call.arguments[errorMessageParameter]);
        break;
    }
    return Future.value(true);
  }

  static UnityAdsInitializationError _initializationErrorFromString(
      String error) {
    return UnityAdsInitializationError.values.firstWhere(
        (e) => error == e.toString().split('.').last,
        orElse: () => UnityAdsInitializationError.unknown);
  }

  /// Load a placement to make it available to show. Ads generally take a few seconds to finish loading before they can be shown.
  ///
  /// * [placementId] - the placement ID, as defined in Unity Ads admin tools.
  /// * [onComplete] - callback triggered when a load request has successfully filled the specified placementId with an ad that is ready to show.
  /// * [onFailed] - called when load request has failed to load an ad for a requested placement.
  static Future<void> load({
    required String placementId,
    Function(String placementId)? onComplete,
    Function(String placementId, UnityAdsLoadError error, String errorMessage)?
        onFailed,
  }) async {
    _channels
        .putIfAbsent(
            placementId, () => MethodChannel('${videoAdChannel}_$placementId'))
        .setMethodCallHandler(
            (call) => _loadMethodCall(call, onComplete, onFailed));

    final arguments = <String, dynamic>{
      placementIdParameter: placementId,
    };
    await _channel.invokeMethod(loadMethod, arguments);
  }

  static Future<dynamic> _loadMethodCall(
    MethodCall call,
    Function(String placementId)? onComplete,
    Function(String placementId, UnityAdsLoadError error, String errorMessage)?
        onFailed,
  ) {
    switch (call.method) {
      case loadCompleteMethod:
        onComplete?.call(call.arguments[placementIdParameter]);
        break;
      case loadFailedMethod:
        onFailed?.call(
          call.arguments[placementIdParameter],
          _loadErrorFromString(call.arguments[errorCodeParameter]),
          call.arguments[errorMessageParameter],
        );
        break;
    }
    return Future.value(true);
  }

  static UnityAdsLoadError _loadErrorFromString(String error) {
    return UnityAdsLoadError.values.firstWhere(
        (e) => error == e.toString().split('.').last,
        orElse: () => UnityAdsLoadError.unknown);
  }

  /// Show an ad using the provided placement ID.
  ///
  /// * [placementId] - the placement ID, as defined in Unity Ads admin tools.
  /// * [serverId]
  /// * [onStart] - Called when UnityAds has started to show ad with a specific placement.
  /// * [onSkipped] - Called when UnityAds skippes show operation for a placement.
  /// * [onClick] -  Called when UnityAds has received a click while showing ad with a specific placement.
  /// * [onComplete] - Called when UnityAds completes show operation successfully for a placement.
  /// * [onFailed] - Called when UnityAds has failed to show a specific placement with an error message and error category.
  static Future<void> showVideoAd({
    required String placementId,
    String? serverId,
    Function(String placementId)? onStart,
    Function(String placementId)? onSkipped,
    Function(String placementId)? onClick,
    Function(String placementId)? onComplete,
    Function(String placementId, UnityAdsShowError error, String errorMessage)?
        onFailed,
  }) async {
    _channels
        .putIfAbsent(
            placementId, () => MethodChannel('${videoAdChannel}_$placementId'))
        .setMethodCallHandler((call) => _showMethodCall(
            call, onStart, onSkipped, onClick, onComplete, onFailed));

    final args = <String, dynamic>{
      placementIdParameter: placementId,
      serverIdParameter: serverId,
    };
    await _channel.invokeMethod(showVideoMethod, args);
  }

  static Future<dynamic> _showMethodCall(
    MethodCall call,
    Function(String placementId)? onStart,
    Function(String placementId)? onSkipped,
    Function(String placementId)? onClick,
    Function(String placementId)? onComplete,
    Function(String placementId, UnityAdsShowError error, String errorMessage)?
        onFailed,
  ) {
    switch (call.method) {
      case showStartMethod:
        onStart?.call(call.arguments[placementIdParameter]);
        break;
      case showSkippedMethod:
        onSkipped?.call(call.arguments[placementIdParameter]);
        break;
      case showClickMethod:
        onClick?.call(call.arguments[placementIdParameter]);
        break;
      case showCompleteMethod:
        onComplete?.call(call.arguments[placementIdParameter]);
        break;
      case showFailedMethod:
        onFailed?.call(
          call.arguments[placementIdParameter],
          _showErrorFromString(call.arguments[errorCodeParameter]),
          call.arguments[errorMessageParameter],
        );
        break;
    }
    return Future.value(true);
  }

  static UnityAdsShowError _showErrorFromString(String error) {
    return UnityAdsShowError.values.firstWhere(
        (e) => error == e.toString().split('.').last,
        orElse: () => UnityAdsShowError.unknown);
  }
}

enum FirebaseTestLabMode {
  /// Ads are not displayed in the Firebase Test Lab
  disableAds,

  /// Ads are displayed in test mode.
  showAdsInTestMode,

  /// Real ads are displayed, if [testMode] is false.
  showAds,
}

/// Error category of initialization errors
enum UnityAdsInitializationError {
  ///  Error related to environment or internal services.
  internalError,

  /// Error related to invalid arguments
  invalidArgument,

  /// Error related to url being blocked
  adBlockerDetected,

  /// Unknown error
  unknown
}

/// Error category of load errors
enum UnityAdsLoadError {
  /// Error related to SDK not initialized
  initializeFailed,

  /// Error related to environment or internal services
  internal,

  /// Error related to invalid arguments
  invalidArgument,

  /// Error related to there being no ads available
  noFill,

  /// Error related to there being no ads available
  timeout,

  /// Unknown error
  unknown
}

/// The error category of show errors
enum UnityAdsShowError {
  /// Error related to SDK not initialized
  notInitialized,

  /// Error related to placement not being ready
  notReady,

  /// Error related to video player
  videoPlayerError,

  /// Error related to invalid arguments
  invalidArgument,

  /// Error related to internet connection
  noConnection,

  /// Error related to ad is already being shown
  alreadyShowing,

  /// Error related to environment or internal services
  internalError,

  /// Unknown error
  unknown
}
