package com.rebeloid.unity_ads.banner;

import com.rebeloid.unity_ads.UnityAdsConstants;
import com.unity3d.services.banners.BannerErrorInfo;
import com.unity3d.services.banners.BannerView;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodChannel;

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
     * Called when the banner is shown.
     */
    @Override
    public void onBannerShown(BannerView bannerView) {
        Map<String, String> arguments = new HashMap<>();
        arguments.put(UnityAdsConstants.PLACEMENT_ID_PARAMETER, bannerView.getPlacementId());

        channel.invokeMethod(UnityAdsConstants.BANNER_SHOWN_METHOD, arguments);
    }

    /**
     * Called when the banner is clicked.
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
        arguments.put(UnityAdsConstants.ERROR_CODE_PARAMETER, convertError(errorInfo));
        arguments.put(UnityAdsConstants.ERROR_MESSAGE_PARAMETER, errorInfo.errorMessage);

        channel.invokeMethod(UnityAdsConstants.BANNER_ERROR_METHOD, arguments);
    }

    /**
     * Called when the banner links out of the application.
     */
    @Override
    public void onBannerLeftApplication(BannerView bannerView) {
    }

    private String convertError(BannerErrorInfo errorInfo) {
        switch (errorInfo.errorCode) {
            case UNKNOWN:
                return "unknown";
            case NATIVE_ERROR:
                return "native";
            case WEBVIEW_ERROR:
                return "webView";
            case NO_FILL:
                return "noFill";
            default:
                return "";
        }
    }

}