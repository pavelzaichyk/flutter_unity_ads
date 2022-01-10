package com.rebeloid.unity_ads;

import com.unity3d.ads.IUnityAdsLoadListener;
import com.unity3d.ads.UnityAds;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodChannel;

public class UnityAdsLoadListener implements IUnityAdsLoadListener {
    private final Map<String, MethodChannel> placementChannels;
    private final BinaryMessenger messenger;

    public UnityAdsLoadListener(Map<String, MethodChannel> placementChannels, BinaryMessenger messenger) {
        this.placementChannels = placementChannels;
        this.messenger = messenger;
    }

    @Override
    public void onUnityAdsAdLoaded(String placementId) {
        invokeMethod(UnityAdsConstants.LOAD_COMPLETE_METHOD, placementId, new HashMap<>());
    }

    @Override
    public void onUnityAdsFailedToLoad(String placementId, UnityAds.UnityAdsLoadError error, String message) {
        Map<String, String> arguments = new HashMap<>();
        arguments.put(UnityAdsConstants.ERROR_CODE_PARAMETER, convertError(error));
        arguments.put(UnityAdsConstants.ERROR_MESSAGE_PARAMETER, message);
        invokeMethod(UnityAdsConstants.LOAD_FAILED_METHOD, placementId, arguments);
    }

    private void invokeMethod(String methodName, String placementId, Map<String, String> arguments) {
        arguments.put(UnityAdsConstants.PLACEMENT_ID_PARAMETER, placementId);
        MethodChannel channel = placementChannels.get(placementId);
        if (channel == null) {
            channel = new MethodChannel(messenger, UnityAdsConstants.VIDEO_AD_CHANNEL + "_" + placementId);
            placementChannels.put(placementId, channel);
        }
        channel.invokeMethod(methodName, arguments);
    }

    private String convertError(UnityAds.UnityAdsLoadError error) {
        switch (error) {
            case INITIALIZE_FAILED:
                return "initializeFailed";
            case INTERNAL_ERROR:
                return "internal";
            case INVALID_ARGUMENT:
                return "invalidArgument";
            case NO_FILL:
                return "noFill";
            case TIMEOUT:
                return "timeout";
            default:
                return "";
        }
    }
}
