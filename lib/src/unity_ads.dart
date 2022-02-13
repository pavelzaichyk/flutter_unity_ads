import 'package:flutter/services.dart';
import 'package:unity_ads_plugin/src/privacy_consent.dart';

import 'constants.dart';

/// Unity Ads plugin for Flutter applications.
class UnityAds {
  static const MethodChannel _channel = MethodChannel(mainChannel);

  static final Map<String, _AdMethodChannel> _adChannels = {};

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
    _adChannels
        .putIfAbsent(placementId, () => _AdMethodChannel(placementId))
        .update(
          onLoadComplete: onComplete,
          onLoadFailed: onFailed,
        );

    final arguments = <String, dynamic>{
      placementIdParameter: placementId,
    };
    await _channel.invokeMethod(loadMethod, arguments);
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
    _adChannels
        .putIfAbsent(placementId, () => _AdMethodChannel(placementId))
        .update(
          onAdStart: onStart,
          onAdClick: onClick,
          onAdSkipped: onSkipped,
          onShowFailed: onFailed,
          onAdComplete: onComplete,
        );

    final args = <String, dynamic>{
      placementIdParameter: placementId,
      serverIdParameter: serverId,
    };
    await _channel.invokeMethod(showVideoMethod, args);
  }

  /// Pass privacy consent flag to unity sdk.
  /// * [privacyConsentType] - provacy consent type
  /// * [value] - flag
  ///
  /// Returns true if the flag is set, otherwise false.
  ///
  /// Read more about Privacy Consent: https://docs.unity.com/ads/ImplementingDataPrivacy.html
  static Future<bool> setPrivacyConsent(
    PrivacyConsentType privacyConsentType,
    bool value,
  ) async {
    final args = <String, dynamic>{
      privacyConsentValueParameter: value,
      privacyConsentTypeParameter: privacyConsentType.toString().split('.').last
    };
    return await _channel.invokeMethod(privacyConsentSetMethod, args);
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

class _AdMethodChannel {
  final MethodChannel channel;
  Function(String placementId)? onLoadComplete;
  Function(String placementId, UnityAdsLoadError error, String errorMessage)?
      onLoadFailed;
  Function(String placementId)? onAdStart;
  Function(String placementId)? onAdClick;
  Function(String placementId)? onAdComplete;
  Function(String placementId)? onAdSkipped;
  Function(String placementId, UnityAdsShowError error, String errorMessage)?
      onShowFailed;

  _AdMethodChannel(String placementId)
      : channel = MethodChannel('${videoAdChannel}_$placementId') {
    channel.setMethodCallHandler(_methodCallHandler);
  }

  void update({
    Function(String adUnitId)? onLoadComplete,
    Function(String adUnitId, UnityAdsLoadError error, String errorMessage)?
        onLoadFailed,
    Function(String adUnitId)? onAdStart,
    Function(String adUnitId)? onAdClick,
    Function(String placementId)? onAdComplete,
    Function(String placementId)? onAdSkipped,
    Function(String adUnitId, UnityAdsShowError error, String errorMessage)?
        onShowFailed,
  }) {
    this.onLoadComplete = onLoadComplete ?? this.onLoadComplete;
    this.onLoadFailed = onLoadFailed ?? this.onLoadFailed;
    this.onAdStart = onAdStart ?? this.onAdStart;
    this.onAdClick = onAdClick ?? this.onAdClick;
    this.onAdComplete = onAdComplete ?? this.onAdComplete;
    this.onAdSkipped = onAdSkipped ?? this.onAdSkipped;
    this.onShowFailed = onShowFailed ?? this.onShowFailed;
  }

  Future _methodCallHandler(MethodCall call) async {
    switch (call.method) {
      case loadCompleteMethod:
        onLoadComplete?.call(call.arguments[placementIdParameter]);
        break;
      case loadFailedMethod:
        onLoadFailed?.call(
          call.arguments[placementIdParameter],
          _loadErrorFromString(call.arguments[errorCodeParameter]),
          call.arguments[errorMessageParameter],
        );
        break;
      case showStartMethod:
        onAdStart?.call(call.arguments[placementIdParameter]);
        break;
      case showSkippedMethod:
        onAdSkipped?.call(call.arguments[placementIdParameter]);
        break;
      case showClickMethod:
        onAdClick?.call(call.arguments[placementIdParameter]);
        break;
      case showCompleteMethod:
        onAdComplete?.call(call.arguments[placementIdParameter]);
        break;
      case showFailedMethod:
        onShowFailed?.call(
          call.arguments[placementIdParameter],
          _showErrorFromString(call.arguments[errorCodeParameter]),
          call.arguments[errorMessageParameter],
        );
        break;
    }
  }

  UnityAdsLoadError _loadErrorFromString(String error) {
    return UnityAdsLoadError.values.firstWhere(
        (e) => error == e.toString().split('.').last,
        orElse: () => UnityAdsLoadError.unknown);
  }

  UnityAdsShowError _showErrorFromString(String error) {
    return UnityAdsShowError.values.firstWhere(
        (e) => error == e.toString().split('.').last,
        orElse: () => UnityAdsShowError.unknown);
  }
}
