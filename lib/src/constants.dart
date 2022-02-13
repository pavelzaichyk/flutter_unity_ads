const mainChannel = 'com.rebeloid.unity_ads';

const bannerAdChannel = mainChannel + "/bannerAd";
const videoAdChannel = mainChannel + "/videoAd";

const gameIdParameter = "gameId";
const testModeParameter = "testMode";
const firebaseTestLabModeParameter = "firebaseTestLabMode";

const placementIdParameter = "placementId";
const errorCodeParameter = "errorCode";
const errorMessageParameter = "errorMessage";

//init
const initMethod = "init";
const initCompleteMethod = "initComplete";
const initFailedMethod = "initFailed";

//load
const loadMethod = 'load';
const loadCompleteMethod = "loadComplete";
const loadFailedMethod = "loadFailed";

//show
const showVideoMethod = "showVideo";
const serverIdParameter = "serverId";
const showCompleteMethod = "showComplete";
const showFailedMethod = "showFailed";
const showStartMethod = "showStart";
const showSkippedMethod = "showSkipped";
const showClickMethod = "showClick";

//banner
const heightParameter = "height";
const widthParameter = "width";
const bannerErrorMethod = "banner_error";
const bannerLoadedMethod = "banner_loaded";
const bannerClickedMethod = "banner_clicked";

//privacy consent
const privacyConsentSetMethod = "privacyConsent_set";
const privacyConsentTypeParameter = "privacyConsent_type";
const privacyConsentValueParameter = "privacyConsent_value";
