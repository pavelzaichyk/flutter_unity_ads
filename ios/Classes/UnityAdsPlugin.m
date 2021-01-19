#import "UnityAdsPlugin.h"
#if __has_include(<unity_ads_plugin/unity_ads_plugin-Swift.h>)
#import <unity_ads_plugin/unity_ads_plugin-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "unity_ads_plugin-Swift.h"
#endif

@implementation UnityAdsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftUnityAdsPlugin registerWithRegistrar:registrar];
}
@end
