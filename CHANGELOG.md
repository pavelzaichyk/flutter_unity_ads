## 0.4.0

* Added support for Swift Package Manager (SPM) on iOS, alongside CocoaPods
* Updated to latest Unity Ads SDK (v4.18.1)
* **Breaking:** minimum iOS deployment target raised to 13.0 (required by the Unity Ads Swift Package)
* Fixed Android build failures on current toolchains: aligned the plugin's JVM targets (Java 11 / Kotlin `jvmTarget` 11) and removed an orphaned Kotlin `UnityAdsPlugin` stub that conflicted with the Java implementation

## 0.3.30

* Updated to latest Unity Ads SDK (v4.17.0)

## 0.3.29

* Updated to latest Unity Ads SDK (v4.16.6)

## 0.3.28

* Updated to latest Unity Ads SDK (v4.16.3)
* Fixed an issue where video ad listeners sometimes did not work on iOS and Android due to premature listener deallocation

## 0.3.27

* Updated to latest Unity Ads SDK (v4.16.1)
* Fixed an occasional crash on iOS 13+ when resolving the root view controller

## 0.3.26

* Updated to latest Unity Ads SDK (v4.15.1)

## 0.3.25

* Switched unity ads version to 4.15.0

## 0.3.24

* Switched unity ads version to 4.14.1

## 0.3.23

* Switched unity ads version to 4.13.0

## 0.3.22

* Switched unity ads version to 4.12.5

## 0.3.21

* Switched unity ads version to 4.12.3

## 0.3.20

* Switched unity ads version to 4.12.2

## 0.3.19

* Update examples

## 0.3.18

* Switched unity ads version to 4.12.1

## 0.3.17

* Switched unity ads version to 4.12.0

## 0.3.16

* Switched unity ads version to 4.11.3

## 0.3.15

* Switched unity ads version to 4.11.2

## 0.3.14

* Switched unity ads version to 4.11.0

## 0.3.13

* Switched unity ads version to 4.10.0

## 0.3.12

* Switched unity ads version to 4.9.3

## 0.3.11

* Switched unity ads version to 4.9.2

## 0.3.10

* The problem with building a release version of the Android app has been fixed
 
## 0.3.9

* Switched unity ads version to 4.9.1

## 0.3.8

* Switched unity ads version to 4.6.1

## 0.3.7

* Switched unity ads version to 4.4.1

## 0.3.6

* Minor fixes.
* Added `UnityAds.isInitialized()` method to check if the SDK is initialized successfully.
* Updated example.

## 0.3.5

* Switched unity ads version to 4.3.0

## 0.3.4

* Switched unity ads version to 4.2.1.

## 0.3.3

* Switched unity ads version to 4.0.1.

## 0.3.2

* Added API to pass consent flags to the Unity Ads SDK.

## 0.3.1

* Minor fixes

## 0.3.0

* Switched unity ads version to 4.0.0.
* Changed API. Added error handling. Added preload ads functionality.

## 0.2.4

* Minor fixes.

## 0.2.3

* Switched unity ads version to 3.7.5.

## 0.2.2

* Minor fixes.
* Switched unity ads version to 3.7.2.

## 0.2.1

* Minor fixes

## 0.2.0

* Migrated to null safety

## 0.1.2

* Added serverId parameter for server-to-server redeem callbacks.

## 0.1.1

* Updated readme.

## 0.1.0

* Added support Unity Banner Ads and Video Ads for iOS.
* Made changes to support android sdk version 19.
* Switched unity ads version to 3.6.0.

## 0.0.3

* Updated readme. Switched unity ads version to 3.5.1. Fixed build issue for ios.

## 0.0.2

* Updated readme and documentation.

## 0.0.1

* Added support Unity Banner Ads and Video Ads for Android
