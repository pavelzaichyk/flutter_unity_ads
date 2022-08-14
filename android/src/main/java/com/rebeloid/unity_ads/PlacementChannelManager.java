package com.rebeloid.unity_ads;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodChannel;

public class PlacementChannelManager {
    private final Map<String, MethodChannel> placementChannels;
    private final BinaryMessenger binaryMessenger;

    public PlacementChannelManager(BinaryMessenger binaryMessenger) {
        this.placementChannels = new HashMap<>();
        this.binaryMessenger = binaryMessenger;
    }

    public void invokeMethod(String methodName, String adUnitId) {
        invokeMethod(methodName, adUnitId, new HashMap<>());
    }

    public void invokeMethod(String methodName, String adUnitId, String errorCode, String errorMessage) {
        Map<String, String> arguments = new HashMap<>();
        arguments.put(UnityAdsConstants.ERROR_CODE_PARAMETER, errorCode);
        arguments.put(UnityAdsConstants.ERROR_MESSAGE_PARAMETER, errorMessage);
        invokeMethod(methodName, adUnitId, arguments);
    }

    public void invokeMethod(String methodName, String placementId, Map<String, String> arguments) {
        arguments.put(UnityAdsConstants.PLACEMENT_ID_PARAMETER, placementId);
        MethodChannel channel = placementChannels.get(placementId);
        if (channel == null) {
            channel = new MethodChannel(binaryMessenger, UnityAdsConstants.VIDEO_AD_CHANNEL + "_" + placementId);
            placementChannels.put(placementId, channel);
        }
        channel.invokeMethod(methodName, arguments);
    }
}
