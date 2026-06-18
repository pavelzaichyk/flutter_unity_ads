// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "unity_ads_plugin",
    platforms: [
        .iOS("13.0")
    ],
    products: [
        .library(name: "unity-ads-plugin", targets: ["unity_ads_plugin"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework"),
        .package(
            url: "https://github.com/Unity-Technologies/Unity-Ads-Swift-Package",
            from: "4.18.1"
        )
    ],
    targets: [
        .target(
            name: "unity_ads_plugin",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework"),
                .product(name: "UnityAds", package: "Unity-Ads-Swift-Package")
            ]
        )
    ]
)
