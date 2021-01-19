package com.rebeloid.unity_ads;

import com.unity3d.ads.IUnityAdsListener;
import com.unity3d.ads.UnityAds;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodChannel;

public class UnityAdsListener implements IUnityAdsListener {
    private final Map<String, MethodChannel> placementChannels = new HashMap<>();
    private final BinaryMessenger messenger;
    private final MethodChannel defaultChannel;

    public UnityAdsListener(MethodChannel defaultChannel, BinaryMessenger messenger) {
        this.defaultChannel = defaultChannel;
        this.messenger = messenger;
    }

    @Override
    public void onUnityAdsReady(String placementId) {
        onReady(placementId);
    }

    @Override
    public void onUnityAdsStart(String placementId) {
        onStarted(placementId);
    }

    @Override
    public void onUnityAdsFinish(String placementId, UnityAds.FinishState result) {
        switch (result) {
            case SKIPPED:
                onSkipped(placementId);
                break;
            case COMPLETED:
                onCompleted(placementId);
                break;
            case ERROR:
                onError(placementId, null, null);
                break;
        }
    }

    @Override
    public void onUnityAdsError(UnityAds.UnityAdsError error, String message) {
        onError(null, error, message);
    }

    private MethodChannel findChannel(String placementId) {
        if (placementChannels.containsKey(placementId)) {
            return placementChannels.get(placementId);
        }
        MethodChannel methodChannel = new MethodChannel(messenger,
                UnityAdsConstants.VIDEO_AD_CHANNEL + "_" + placementId);
        placementChannels.put(placementId, methodChannel);
        return methodChannel;
    }

    private void onReady(String placementId) {
        HashMap<String, Object> arguments = new HashMap<>();
        arguments.put(UnityAdsConstants.PLACEMENT_ID_PARAMETER, placementId);

        invokeMethod(UnityAdsConstants.READY_METHOD, arguments, placementId);
    }

    private void onStarted(String placementId) {
        HashMap<String, Object> arguments = new HashMap<>();
        arguments.put(UnityAdsConstants.PLACEMENT_ID_PARAMETER, placementId);

        invokeMethod(UnityAdsConstants.START_METHOD, arguments, placementId);
    }

    private void onCompleted(String placementId) {
        HashMap<String, Object> arguments = new HashMap<>();
        arguments.put(UnityAdsConstants.PLACEMENT_ID_PARAMETER, placementId);

        invokeMethod(UnityAdsConstants.COMPLETE_METHOD, arguments, placementId);
    }

    private void onSkipped(String placementId) {
        HashMap<String, Object> arguments = new HashMap<>();
        arguments.put(UnityAdsConstants.PLACEMENT_ID_PARAMETER, placementId);

        invokeMethod(UnityAdsConstants.SKIPPED_METHOD, arguments, placementId);
    }

    private void onError(String placementId, UnityAds.UnityAdsError error, String errorMessage) {
        Map<String, Object> arguments = new HashMap<>();

        if (placementId != null) {
            arguments.put(UnityAdsConstants.PLACEMENT_ID_PARAMETER, placementId);
        }

        if (error != null) {
            arguments.put("errorCode", error.toString());
        }

        if (errorMessage != null) {
            arguments.put("errorMessage", errorMessage);
        }

        invokeMethod(UnityAdsConstants.ERROR_METHOD, arguments, placementId);
    }

    private void invokeMethod(String methodName, Map<String, Object> arguments, String placementId) {
        defaultChannel.invokeMethod(methodName, arguments);
        if (placementId != null) {
            findChannel(placementId).invokeMethod(methodName, arguments);
        }
    }
}
