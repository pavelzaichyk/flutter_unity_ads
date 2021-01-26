package com.rebeloid.unity_ads;

import android.app.Activity;
import android.content.Context;
import android.provider.Settings;

import androidx.annotation.NonNull;

import com.unity3d.ads.UnityAds;

import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

import static com.rebeloid.unity_ads.UnityAdsConstants.PLACEMENT_ID_PARAMETER;
import static com.rebeloid.unity_ads.UnityAdsConstants.SERVER_ID_PARAMETER;

import com.rebeloid.unity_ads.banner.BannerAdFactory;
import com.unity3d.ads.metadata.PlayerMetaData;

/**
 * Unity Ads Plugin
 */
public class UnityAdsPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
    private MethodChannel channel;
    private Context context;
    private Activity activity;

    private BannerAdFactory bannerAdFactory;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), UnityAdsConstants.MAIN_CHANNEL);
        channel.setMethodCallHandler(this);
        context = flutterPluginBinding.getApplicationContext();
        BinaryMessenger binaryMessenger = flutterPluginBinding.getBinaryMessenger();
        UnityAds.addListener(new UnityAdsListener(channel, binaryMessenger));

        bannerAdFactory = new BannerAdFactory(binaryMessenger);
        flutterPluginBinding.getPlatformViewRegistry()
                .registerViewFactory(UnityAdsConstants.BANNER_AD_CHANNEL, bannerAdFactory);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {

        if (call.method.equals(UnityAdsConstants.INIT_METHOD)) {
            result.success(initialize((Map<?, ?>) call.arguments));
            return;
        }

        if (call.method.equals(UnityAdsConstants.IS_READY_METHOD)) {
            result.success(isReady((Map<?, ?>) call.arguments));
            return;
        }

        if (call.method.equals(UnityAdsConstants.SHOW_VIDEO_METHOD)) {
            result.success(showVideo((Map<?, ?>) call.arguments));
            return;
        }

        result.notImplemented();
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        activity = binding.getActivity();
        bannerAdFactory.setActivity(activity);
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {

    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {

    }

    @Override
    public void onDetachedFromActivity() {

    }

    private boolean initialize(Map<?, ?> args) {
        String gameId = (String) args.get(UnityAdsConstants.GAME_ID_PARAMETER);

        boolean firebaseTestMode = false;
        if (isInFirebaseTestLab()) {
            String firebaseTestLabMode = (String) args.get(UnityAdsConstants.FIREBASE_TEST_LAB_MODE_PARAMETER);
            if ("disableAds".equalsIgnoreCase(firebaseTestLabMode)) {
                return false;
            }

            firebaseTestMode = "showAdsInTestMode".equalsIgnoreCase(firebaseTestLabMode);
        }

        Boolean testMode = (Boolean) args.get(UnityAdsConstants.TEST_MODE_PARAMETER);
        if (testMode == null) {
            testMode = false;
        }

        UnityAds.initialize(context, gameId, testMode || firebaseTestMode);
        return true;
    }

    private boolean isInFirebaseTestLab() {
        String testLabSetting = Settings.System.getString(context.getContentResolver(), "firebase.test.lab");
        return "true".equalsIgnoreCase(testLabSetting);
    }


    private boolean isReady(Map<?, ?> args) {
        final String placementId = (String) args.get(PLACEMENT_ID_PARAMETER);
        return UnityAds.isReady(placementId);
    }

    private boolean showVideo(Map<?, ?> args) {
        final String placementId = (String) args.get(PLACEMENT_ID_PARAMETER);
        if (!UnityAds.isReady(placementId)) {
            return false;
        }

        final String serverId = (String) args.get(SERVER_ID_PARAMETER);
        if (serverId != null) {
            PlayerMetaData playerMetaData = new PlayerMetaData(context);
            playerMetaData.setServerId(serverId);
            playerMetaData.commit();
        }
        UnityAds.show(activity, placementId);
        return true;
    }

}
