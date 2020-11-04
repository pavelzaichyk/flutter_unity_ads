import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unity_ads_plugin/src/constants.dart';
import 'package:unity_ads_plugin/unity_ads.dart';

void main() {
  const MethodChannel channel = MethodChannel(mainChannel);

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return true;
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('init', () async {
    expect(await UnityAds.init(gameId: 'test_game_id'), true);
  });
}
