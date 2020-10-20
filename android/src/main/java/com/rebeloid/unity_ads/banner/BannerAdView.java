package com.rebeloid.unity_ads.banner;

import android.app.Activity;
import android.view.View;

import com.unity3d.services.banners.BannerView;
import com.unity3d.services.banners.UnityBannerSize;

import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;

import com.rebeloid.unity_ads.UnityAdsConstants;

public class BannerAdView implements PlatformView {
    private static final UnityBannerSize STANDARD_SIZE = new UnityBannerSize(320, 50);
    private final BannerView bannerView;

    public BannerAdView(Activity activity, int id, Map<?, ?> args, BinaryMessenger messenger) {
        MethodChannel channel = new MethodChannel(messenger,
                UnityAdsConstants.BANNER_AD_CHANNEL + "_" + id);

        Integer width = (Integer) args.get(UnityAdsConstants.WIDTH_PARAMETER);
        Integer height = (Integer) args.get(UnityAdsConstants.HEIGHT_PARAMETER);
        UnityBannerSize size = width == null || height == null ? STANDARD_SIZE : new UnityBannerSize(width, height);

        bannerView = new BannerView(activity, (String) args.get(UnityAdsConstants.PLACEMENT_ID_PARAMETER), size);

        bannerView.setListener(new BannerAdListener(channel));
        bannerView.load();
    }

    @Override
    public View getView() {
        return bannerView;
    }

    @Override
    public void dispose() {

    }
}