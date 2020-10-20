import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'constants.dart';

class UnityBannerAd extends StatefulWidget {
  /// Unity Ad Placement ID
  final String placementId;

  /// Size of the banner ad.
  final BannerSize size;

  /// The banner ad listener.
  ///
  /// The information can contain:
  /// * placementId
  /// * errorMessage
  /// * errorCode
  final void Function(BannerAdState, dynamic) listener;

  /// This widget is used to contain Banner Ads.
  const UnityBannerAd({
    Key key,
    @required this.placementId,
    this.size = BannerSize.standard,
    this.listener,
  }) : super(key: key);

  @override
  _UnityBannerAdState createState() => _UnityBannerAdState();
}

class _UnityBannerAdState extends State<UnityBannerAd> {
  bool _isLoaded = false;

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return Container(
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
            creationParamsCodec: StandardMessageCodec(),
            onPlatformViewCreated: _onBannerAdViewCreated,
          ),
        ),
      );
    }

    return Container();
  }

  void _onBannerAdViewCreated(int id) async {
    final channel = MethodChannel('${bannerAdChannel}_$id');

    channel.setMethodCallHandler((call) {
      switch (call.method) {
        case bannerErrorMethod:
          _callListener(BannerAdState.error, call.arguments);
          break;
        case bannerLoadedMethod:
          setState(() {
            _isLoaded = true;
          });
          _callListener(BannerAdState.loaded, call.arguments);
          break;
        case bannerClickedMethod:
          _callListener(BannerAdState.clicked, call.arguments);
          break;
      }
      return;
    });
  }

  void _callListener(BannerAdState result, dynamic arguments) {
    if (widget.listener != null) {
      widget.listener(result, arguments);
    }
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
