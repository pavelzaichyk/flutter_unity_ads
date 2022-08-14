struct UnityAdsConstants {
    static let MAIN_CHANNEL = "com.rebeloid.unity_ads";
    
    static let BANNER_AD_CHANNEL = MAIN_CHANNEL + "/bannerAd";
    static let VIDEO_AD_CHANNEL = MAIN_CHANNEL + "/videoAd";
    
    static let PLACEMENT_ID_PARAMETER = "placementId";
    static let ERROR_CODE_PARAMETER = "errorCode";
    static let ERROR_MESSAGE_PARAMETER = "errorMessage";
    
    //initialize
    static let INIT_METHOD = "init";
    static let GAME_ID_PARAMETER = "gameId";
    static let TEST_MODE_PARAMETER = "testMode";
    static let INIT_COMPLETE_METHOD = "initComplete";
    static let INIT_FAILED_METHOD = "initFailed";
    static let IS_INITIALIZED_METHOD = "isInitialized";
    
    //load
    static let LOAD_METHOD = "load";
    static let LOAD_COMPLETE_METHOD = "loadComplete";
    static let LOAD_FAILED_METHOD = "loadFailed";
    
    //show
    static let SHOW_VIDEO_METHOD = "showVideo";
    static let SERVER_ID_PARAMETER = "serverId";
    static let SHOW_COMPLETE_METHOD = "showComplete";
    static let SHOW_FAILED_METHOD = "showFailed";
    static let SHOW_START_METHOD = "showStart";
    static let SHOW_SKIPPED_METHOD = "showSkipped";
    static let SHOW_CLICK_METHOD = "showClick";
    
    //banner
    static let HEIGHT_PARAMETER = "height";
    static let WIDTH_PARAMETER = "width";
    static let BANNER_ERROR_METHOD = "banner_error";
    static let BANNER_LOADED_METHOD = "banner_loaded";
    static let BANNER_CLICKED_METHOD = "banner_clicked";
    
    //privacy consent
    static let PRIVACY_CONSENT_SET_METHOD = "privacyConsent_set";
    static let PRIVACY_CONSENT_TYPE_PARAMETER = "privacyConsent_type";
    static let PRIVACY_CONSENT_VALUE_PARAMETER = "privacyConsent_value";
}
