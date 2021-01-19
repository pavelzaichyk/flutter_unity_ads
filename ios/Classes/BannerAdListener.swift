import Flutter
import UnityAds

class BannerAdListener: NSObject, UADSBannerViewDelegate {
    let channel: FlutterMethodChannel
    
    init(channel: FlutterMethodChannel) {
        self.channel = channel
        super.init()
    }
    
    func bannerViewDidLoad(_ bannerView: UADSBannerView!) {
        channel.invokeMethod(UnityAdsConstants.BANNER_LOADED_METHOD,
                             arguments: [UnityAdsConstants.PLACEMENT_ID_PARAMETER: bannerView.placementId])
    }
    
    func bannerViewDidClick(_ bannerView: UADSBannerView!) {
        channel.invokeMethod(UnityAdsConstants.BANNER_CLICKED_METHOD,
                             arguments: [UnityAdsConstants.PLACEMENT_ID_PARAMETER: bannerView.placementId])
    }
    
    func bannerViewDidError(_ bannerView: UADSBannerView!, error: UADSBannerError!) {
        let arguments = [
            UnityAdsConstants.PLACEMENT_ID_PARAMETER: bannerView.placementId,
            "errorCode": String(error.code),
            "errorMessage": error.localizedFailureReason ];
        
        channel.invokeMethod(UnityAdsConstants.BANNER_ERROR_METHOD, arguments: arguments);
    }
    
    func bannerViewDidLeaveApplication(_ bannerView: UADSBannerView!) {
    }
}
