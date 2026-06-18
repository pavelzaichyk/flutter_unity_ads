#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint unity_ads_plugin.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'unity_ads_plugin'
  s.version          = '0.0.1'
  s.summary          = 'Unity Ads plugin for Flutter Applications.'
  s.description      = <<-DESC
Flutter unity ads plugin.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'unity_ads_plugin/Sources/unity_ads_plugin/**/*.swift'
  s.dependency 'Flutter'
  s.platform = :ios, '13.0'
  s.dependency 'UnityAds', '4.18.1'

  # Flutter.framework does not contain a i386 slice.
  # s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64'}
  s.swift_version = '5.0'
  s.static_framework = true
  s.ios.deployment_target = '13.0'
end
