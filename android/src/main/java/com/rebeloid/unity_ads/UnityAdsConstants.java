package com.rebeloid.unity_ads;

public interface UnityAdsConstants {
    String MAIN_CHANNEL = "com.rebeloid.unity_ads";

    String BANNER_AD_CHANNEL = MAIN_CHANNEL + "/bannerAd";
    String VIDEO_AD_CHANNEL = MAIN_CHANNEL + "/videoAd";

    String PLACEMENT_ID_PARAMETER = "placementId";
    String ERROR_CODE_PARAMETER = "errorCode";
    String ERROR_MESSAGE_PARAMETER = "errorMessage";

    //initialize
    String INIT_METHOD = "init";
    String FIREBASE_TEST_LAB_MODE_PARAMETER = "firebaseTestLabMode";
    String GAME_ID_PARAMETER = "gameId";
    String TEST_MODE_PARAMETER = "testMode";
    String INIT_COMPLETE_METHOD = "initComplete";
    String INIT_FAILED_METHOD = "initFailed";

    //load
    String LOAD_METHOD = "load";
    String LOAD_COMPLETE_METHOD = "loadComplete";
    String LOAD_FAILED_METHOD = "loadFailed";

    //show
    String SHOW_VIDEO_METHOD = "showVideo";
    String SERVER_ID_PARAMETER = "serverId";
    String SHOW_COMPLETE_METHOD = "showComplete";
    String SHOW_FAILED_METHOD = "showFailed";
    String SHOW_START_METHOD = "showStart";
    String SHOW_SKIPPED_METHOD = "showSkipped";
    String SHOW_CLICK_METHOD = "showClick";

    //banner
    String HEIGHT_PARAMETER = "height";
    String WIDTH_PARAMETER = "width";
    String BANNER_ERROR_METHOD = "banner_error";
    String BANNER_LOADED_METHOD = "banner_loaded";
    String BANNER_CLICKED_METHOD = "banner_clicked";

    //privacy consent
    String PRIVACY_CONSENT_SET_METHOD = "privacyConsent_set";
    String PRIVACY_CONSENT_TYPE_PARAMETER = "privacyConsent_type";
    String PRIVACY_CONSENT_VALUE_PARAMETER = "privacyConsent_value";
}
