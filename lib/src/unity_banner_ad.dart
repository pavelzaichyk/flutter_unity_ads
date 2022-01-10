import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'constants.dart';

class UnityBannerAd extends StatefulWidget {
  /// Unity Ad Placement ID
  final String placementId;

  /// Size of the banner ad.
  final BannerSize size;

  /// Called when the banner is loaded and ready to be placed in the view hierarchy.
  final void Function(String placementId)? onLoad;

  /// Called when the user clicks the banner.
  final void Function(String placementId)? onClick;

  /// Called when unity ads banner encounters an error.
  final void Function(
          String placementId, UnityAdsBannerError error, String errorMessage)?
      onFailed;

  /// This widget is used to contain Banner Ads.
  const UnityBannerAd({
    Key? key,
    required this.placementId,
    this.size = BannerSize.standard,
    this.onLoad,
    this.onClick,
    this.onFailed,
  }) : super(key: key);

  @override
  _UnityBannerAdState createState() => _UnityBannerAdState();
}

class _UnityBannerAdState extends State<UnityBannerAd> {
  bool _isLoaded = false;

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return SizedBox(
        height: widget.size.height + 0.0,
        width: widget.size.width + 0.0,
        child: OverflowBox(
          maxHeight: _isLoaded ? widget.size.height + 0.0 : 1,
          minHeight: 0.1,
          alignment: Alignment.bottomCenter,
          child: AndroidView(
            viewType: bannerAdChannel,
            creationParams: <String, dynamic>{
              placementIdParameter: widget.placementId,
              widthParameter: widget.size.width,
              heightParameter: widget.size.height,
            },
            creationParamsCodec: const StandardMessageCodec(),
            onPlatformViewCreated: _onBannerAdViewCreated,
          ),
        ),
      );
    }
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return SizedBox(
        height: widget.size.height + 0.0,
        width: widget.size.width + 0.0,
        child: OverflowBox(
          maxHeight: _isLoaded ? widget.size.height + 0.0 : 1,
          minHeight: 0.1,
          alignment: Alignment.bottomCenter,
          child: UiKitView(
            viewType: bannerAdChannel,
            creationParams: <String, dynamic>{
              placementIdParameter: widget.placementId,
              widthParameter: widget.size.width,
              heightParameter: widget.size.height,
            },
            creationParamsCodec: const StandardMessageCodec(),
            onPlatformViewCreated: _onBannerAdViewCreated,
          ),
        ),
      );
    }

    return Container();
  }

  void _onBannerAdViewCreated(int id) {
    final channel = MethodChannel('${bannerAdChannel}_$id');

    channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case bannerErrorMethod:
          widget.onFailed?.call(
            call.arguments[placementIdParameter],
            _bannerErrorFromString(call.arguments[errorCodeParameter]),
            call.arguments[errorMessageParameter],
          );
          break;
        case bannerLoadedMethod:
          setState(() {
            _isLoaded = true;
          });
          widget.onLoad?.call(call.arguments[placementIdParameter]);
          break;
        case bannerClickedMethod:
          widget.onClick?.call(call.arguments[placementIdParameter]);
          break;
      }
    });
  }

  static UnityAdsBannerError _bannerErrorFromString(String error) {
    return UnityAdsBannerError.values.firstWhere(
        (e) => error == e.toString().split('.').last,
        orElse: () => UnityAdsBannerError.unknown);
  }
}

/// Defines the size of Banner Ad.
class BannerSize {
  final int width;
  final int height;

  static const BannerSize standard = BannerSize(width: 320, height: 50);
  static const BannerSize leaderboard = BannerSize(width: 728, height: 90);
  static const BannerSize iabStandard = BannerSize(width: 468, height: 60);

  const BannerSize({this.width = 320, this.height = 50});
}

enum BannerAdState {
  /// Banner is loaded.
  loaded,

  /// Banner is clicked.
  clicked,

  /// Error during loading banner
  error,
}

enum UnityAdsBannerError {
  native,

  webView,

  noFill,

  /// Unknown error
  unknown
}
