package com.rebeloid.unity_ads;

import com.unity3d.ads.IUnityAdsShowListener;
import com.unity3d.ads.UnityAds;

public class UnityAdsShowListener implements IUnityAdsShowListener {
    private final PlacementChannelManager placementChannelManager;

    public UnityAdsShowListener(PlacementChannelManager placementChannelManager) {
        this.placementChannelManager = placementChannelManager;
    }

    @Override
    public void onUnityAdsShowFailure(String placementId, UnityAds.UnityAdsShowError error, String message) {
        placementChannelManager.invokeMethod(UnityAdsConstants.SHOW_FAILED_METHOD, placementId, convertError(error), message);
    }

    @Override
    public void onUnityAdsShowStart(String placementId) {
        placementChannelManager.invokeMethod(UnityAdsConstants.SHOW_START_METHOD, placementId);
    }

    @Override
    public void onUnityAdsShowClick(String placementId) {
        placementChannelManager.invokeMethod(UnityAdsConstants.SHOW_CLICK_METHOD, placementId);
    }

    @Override
    public void onUnityAdsShowComplete(String placementId, UnityAds.UnityAdsShowCompletionState state) {
        if (state == UnityAds.UnityAdsShowCompletionState.SKIPPED) {
            placementChannelManager.invokeMethod(UnityAdsConstants.SHOW_SKIPPED_METHOD, placementId);
        } else if (state == UnityAds.UnityAdsShowCompletionState.COMPLETED) {
            placementChannelManager.invokeMethod(UnityAdsConstants.SHOW_COMPLETE_METHOD, placementId);
        }
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
            case TIMEOUT:
                return "timeout";
            default:
                return "";
        }
    }
}
