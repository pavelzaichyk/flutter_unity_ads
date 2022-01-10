package com.rebeloid.unity_ads;

import com.unity3d.ads.IUnityAdsInitializationListener;
import com.unity3d.ads.UnityAds;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodChannel;

public class UnityAdsInitializationListener implements IUnityAdsInitializationListener {
    private final MethodChannel channel;

    public UnityAdsInitializationListener(MethodChannel channel) {
        this.channel = channel;
    }

    @Override
    public void onInitializationComplete() {
        channel.invokeMethod(UnityAdsConstants.INIT_COMPLETE_METHOD, new HashMap<>());
    }

    @Override
    public void onInitializationFailed(UnityAds.UnityAdsInitializationError error, String message) {
        Map<String, String> arguments = new HashMap<>();
        arguments.put(UnityAdsConstants.ERROR_CODE_PARAMETER, convertError(error));
        arguments.put(UnityAdsConstants.ERROR_MESSAGE_PARAMETER, message);
        channel.invokeMethod(UnityAdsConstants.INIT_FAILED_METHOD, arguments);
    }

    private String convertError(UnityAds.UnityAdsInitializationError error) {
        switch (error) {
            case INTERNAL_ERROR:
                return "internalError";
            case INVALID_ARGUMENT:
                return "invalidArgument";
            case AD_BLOCKER_DETECTED:
                return "adBlockerDetected";
            default:
                return "";
        }
    }
}
