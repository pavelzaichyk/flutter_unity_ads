package com.rebeloid.unity_ads;

public interface UnityAdsConstants {

    String MAIN_CHANNEL = "unity.ads";

    String BANNER_AD_CHANNEL = MAIN_CHANNEL + "/bannerAd";
    String VIDEO_AD_CHANNEL = MAIN_CHANNEL + "/videoAd";

    String GAME_ID_PARAMETER = "gameId";
    String TEST_MODE_PARAMETER = "testMode";
    String FIREBASE_TEST_LAB_MODE_PARAMETER = "firebaseTestLabMode";

    String PLACEMENT_ID_PARAMETER = "placementId";
    String HEIGHT_PARAMETER = "height";
    String WIDTH_PARAMETER = "width";

    String INIT_METHOD = "init";
    String IS_READY_METHOD = "isReady";
    String SHOW_VIDEO_METHOD = "showVideo";

    String READY_METHOD = "ready";
    String START_METHOD = "start";
    String COMPLETE_METHOD = "complete";
    String SKIPPED_METHOD = "skipped";
    String ERROR_METHOD = "error";

    String BANNER_ERROR_METHOD = "banner_error";
    String BANNER_LOADED_METHOD = "banner_loaded";
    String BANNER_CLICKED_METHOD = "banner_clicked";
}
