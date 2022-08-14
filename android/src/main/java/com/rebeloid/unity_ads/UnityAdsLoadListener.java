package com.rebeloid.unity_ads;

import com.unity3d.ads.IUnityAdsLoadListener;
import com.unity3d.ads.UnityAds;

public class UnityAdsLoadListener implements IUnityAdsLoadListener {
    private final PlacementChannelManager placementChannelManager;

    public UnityAdsLoadListener(PlacementChannelManager placementChannelManager) {
        this.placementChannelManager = placementChannelManager;
    }

    @Override
    public void onUnityAdsAdLoaded(String placementId) {
        placementChannelManager.invokeMethod(UnityAdsConstants.LOAD_COMPLETE_METHOD, placementId);
    }

    @Override
    public void onUnityAdsFailedToLoad(String placementId, UnityAds.UnityAdsLoadError error, String message) {
        placementChannelManager.invokeMethod(UnityAdsConstants.LOAD_FAILED_METHOD, placementId, convertError(error), message);
    }

    private String convertError(UnityAds.UnityAdsLoadError error) {
        switch (error) {
            case INITIALIZE_FAILED:
                return "initializeFailed";
            case INTERNAL_ERROR:
                return "internalError";
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
