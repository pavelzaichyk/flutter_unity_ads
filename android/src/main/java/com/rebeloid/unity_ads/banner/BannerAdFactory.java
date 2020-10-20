package com.rebeloid.unity_ads.banner;

import android.app.Activity;
import android.content.Context;

import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

public class BannerAdFactory extends PlatformViewFactory {
    private final BinaryMessenger messenger;
    private Activity activity;

    public BannerAdFactory(BinaryMessenger messenger) {
        super(StandardMessageCodec.INSTANCE);
        this.messenger = messenger;
    }

    public void setActivity(Activity activity) {
        this.activity = activity;
    }

    @Override
    public PlatformView create(Context context, int viewId, Object args) {
        return new BannerAdView(activity, viewId, (Map<?, ?>) args, this.messenger);
    }

}
