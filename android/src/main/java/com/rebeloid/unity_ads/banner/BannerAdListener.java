package com.rebeloid.unity_ads.banner;

import com.unity3d.services.banners.BannerErrorInfo;
import com.unity3d.services.banners.BannerView;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodChannel;

import com.rebeloid.unity_ads.UnityAdsConstants;

class BannerAdListener implements BannerView.IListener {
    private final MethodChannel channel;

    public BannerAdListener(MethodChannel channel) {
        this.channel = channel;
    }

    /**
     * Called when the banner is loaded.
     */
    @Override
    public void onBannerLoaded(BannerView bannerView) {
        Map<String, String> arguments = new HashMap<>();
        arguments.put(UnityAdsConstants.PLACEMENT_ID_PARAMETER, bannerView.getPlacementId());

        channel.invokeMethod(UnityAdsConstants.BANNER_LOADED_METHOD, arguments);
    }

    /**
     * Called when a banner is clicked.
     */
    @Override
    public void onBannerClick(BannerView bannerView) {
        Map<String, String> arguments = new HashMap<>();
        arguments.put(UnityAdsConstants.PLACEMENT_ID_PARAMETER, bannerView.getPlacementId());

        channel.invokeMethod(UnityAdsConstants.BANNER_CLICKED_METHOD, arguments);
    }

    /**
     * Called when an error occurs.
     */
    @Override
    public void onBannerFailedToLoad(BannerView bannerView, BannerErrorInfo errorInfo) {
        Map<String, String> arguments = new HashMap<>();
        arguments.put(UnityAdsConstants.PLACEMENT_ID_PARAMETER, bannerView.getPlacementId());

        if (errorInfo.errorCode != null) {
            arguments.put("errorCode", errorInfo.errorCode.toString());
        }

        if (errorInfo.errorMessage != null) {
            arguments.put("errorMessage", errorInfo.errorMessage);
        }

        channel.invokeMethod(UnityAdsConstants.BANNER_ERROR_METHOD, arguments);
    }

    /**
     * Called when the banner links out of the application.
     */
    @Override
    public void onBannerLeftApplication(BannerView bannerView) {
    }
}