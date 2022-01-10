package com.rebeloid.unity_ads;

import com.unity3d.ads.IUnityAdsShowListener;
import com.unity3d.ads.UnityAds;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodChannel;

public class UnityAdsShowListener implements IUnityAdsShowListener {
    private final Map<String, MethodChannel> placementChannels;
    private final BinaryMessenger messenger;

    public UnityAdsShowListener(Map<String, MethodChannel> placementChannels, BinaryMessenger messenger) {
        this.placementChannels = placementChannels;
        this.messenger = messenger;
    }

    @Override
    public void onUnityAdsShowFailure(String placementId, UnityAds.UnityAdsShowError error, String message) {
        Map<String, String> arguments = new HashMap<>();
        arguments.put(UnityAdsConstants.ERROR_CODE_PARAMETER, convertError(error));
        arguments.put(UnityAdsConstants.ERROR_MESSAGE_PARAMETER, message);
        invokeMethod(UnityAdsConstants.SHOW_FAILED_METHOD, placementId, arguments);
    }

    @Override
    public void onUnityAdsShowStart(String placementId) {
        invokeMethod(UnityAdsConstants.SHOW_START_METHOD, placementId, new HashMap<>());
    }

    @Override
    public void onUnityAdsShowClick(String placementId) {
        invokeMethod(UnityAdsConstants.SHOW_CLICK_METHOD, placementId, new HashMap<>());
    }

    @Override
    public void onUnityAdsShowComplete(String placementId, UnityAds.UnityAdsShowCompletionState state) {
        if (state == UnityAds.UnityAdsShowCompletionState.SKIPPED) {
            invokeMethod(UnityAdsConstants.SHOW_SKIPPED_METHOD, placementId, new HashMap<>());
        } else if (state == UnityAds.UnityAdsShowCompletionState.COMPLETED) {
            invokeMethod(UnityAdsConstants.SHOW_COMPLETE_METHOD, placementId, new HashMap<>());
        }
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

    private String convertError(UnityAds.UnityAdsShowError error) {
        switch (error) {
            case NOT_INITIALIZED:
                return "notInitialized";
            case NOT_READY:
                return "notReady";
            case VIDEO_PLAYER_ERROR:
                return "videoPlayerError";
            case INVALID_ARGUMENT:
                return "invalidArgument";
            case NO_CONNECTION:
                return "noConnection";
            case ALREADY_SHOWING:
                return "alreadyShowing";
            case INTERNAL_ERROR:
                return "internalError";
            default:
                return "";
        }
    }
}
