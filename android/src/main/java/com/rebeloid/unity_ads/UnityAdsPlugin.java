package com.rebeloid.unity_ads;

import static com.rebeloid.unity_ads.UnityAdsConstants.PLACEMENT_ID_PARAMETER;
import static com.rebeloid.unity_ads.UnityAdsConstants.SERVER_ID_PARAMETER;

import android.app.Activity;
import android.content.Context;
import android.provider.Settings;
import android.util.Log;

import androidx.annotation.NonNull;

import com.rebeloid.unity_ads.banner.BannerAdFactory;
import com.rebeloid.unity_ads.privacy.PrivacyConsent;
import com.unity3d.ads.UnityAds;
import com.unity3d.ads.metadata.PlayerMetaData;

import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/**
 * Unity Ads Plugin
 */
public class UnityAdsPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
    private static final String TAG = UnityAdsPlugin.class.getName();
    private MethodChannel channel;
    private Context context;
    private Activity activity;
    private PlacementChannelManager placementChannelManager;
    private BannerAdFactory bannerAdFactory;
    private PrivacyConsent privacyConsent;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), UnityAdsConstants.MAIN_CHANNEL);
        channel.setMethodCallHandler(this);
        context = flutterPluginBinding.getApplicationContext();
        BinaryMessenger binaryMessenger = flutterPluginBinding.getBinaryMessenger();
        placementChannelManager = new PlacementChannelManager(binaryMessenger);
        privacyConsent = new PrivacyConsent();

        bannerAdFactory = new BannerAdFactory(binaryMessenger);
        flutterPluginBinding.getPlatformViewRegistry()
                .registerViewFactory(UnityAdsConstants.BANNER_AD_CHANNEL, bannerAdFactory);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        Map<?, ?> arguments = (Map<?, ?>) call.arguments;

        switch (call.method) {
            case UnityAdsConstants.INIT_METHOD:
                result.success(initialize(arguments));
                break;
            case UnityAdsConstants.LOAD_METHOD:
                result.success(load(arguments));
                break;
            case UnityAdsConstants.SHOW_VIDEO_METHOD:
                result.success(showVideo(arguments));
                break;
            case UnityAdsConstants.PRIVACY_CONSENT_SET_METHOD:
                result.success(privacyConsent.set(arguments));
                break;
            case UnityAdsConstants.IS_INITIALIZED_METHOD:
                result.success(UnityAds.isInitialized());
                break;
            default:
                result.notImplemented();
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        activity = binding.getActivity();
        bannerAdFactory.setActivity(activity);
        privacyConsent.setActivity(activity);
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

        UnityAds.initialize(context, gameId, testMode || firebaseTestMode, new UnityAdsInitializationListener(channel));
        return true;
    }

    private boolean isInFirebaseTestLab() {
        String testLabSetting = Settings.System.getString(context.getContentResolver(), "firebase.test.lab");
        return "true".equalsIgnoreCase(testLabSetting);
    }

    private boolean load(Map<?, ?> args) {
        final String placementId = (String) args.get(PLACEMENT_ID_PARAMETER);
        try {
            UnityAds.load(placementId, new UnityAdsLoadListener(placementChannelManager));
            return true;
        } catch (Exception ex) {
            Log.e(TAG, "Exception occurs during loading ad: " + placementId, ex);
            placementChannelManager.invokeMethod(UnityAdsConstants.LOAD_FAILED_METHOD, placementId, "unknown", ex.getMessage());
        }
        return false;
    }

    private boolean showVideo(Map<?, ?> args) {
        final String placementId = (String) args.get(PLACEMENT_ID_PARAMETER);

        final String serverId = (String) args.get(SERVER_ID_PARAMETER);
        if (serverId != null) {
            PlayerMetaData playerMetaData = new PlayerMetaData(context);
            playerMetaData.setServerId(serverId);
            playerMetaData.commit();
        }
        try {
            UnityAds.show(activity, placementId, new UnityAdsShowListener(placementChannelManager));
            return true;
        } catch (Exception ex) {
            Log.e(TAG, "Exception occurs during loading ad: " + placementId, ex);
            placementChannelManager.invokeMethod(UnityAdsConstants.SHOW_FAILED_METHOD, placementId, "unknown", ex.getMessage());
        }
        return false;
    }

}
