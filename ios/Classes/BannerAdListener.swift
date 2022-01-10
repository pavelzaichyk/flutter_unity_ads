import Flutter
import UnityAds

class BannerAdListener: NSObject, UADSBannerViewDelegate {
    let channel: FlutterMethodChannel
    
    init(channel: FlutterMethodChannel) {
        self.channel = channel
    }
    
    func bannerViewDidLoad(_ bannerView: UADSBannerView) {
        channel.invokeMethod(UnityAdsConstants.BANNER_LOADED_METHOD,
                             arguments: [UnityAdsConstants.PLACEMENT_ID_PARAMETER: bannerView.placementId])
    }
    
    func bannerViewDidClick(_ bannerView: UADSBannerView) {
        channel.invokeMethod(UnityAdsConstants.BANNER_CLICKED_METHOD,
                             arguments: [UnityAdsConstants.PLACEMENT_ID_PARAMETER: bannerView.placementId])
    }
    
    func bannerViewDidError(_ bannerView: UADSBannerView, error: UADSBannerError) {
        let arguments = [
            UnityAdsConstants.PLACEMENT_ID_PARAMETER: bannerView.placementId,
            UnityAdsConstants.ERROR_CODE_PARAMETER: convertError(error),
            UnityAdsConstants.ERROR_MESSAGE_PARAMETER: error.localizedDescription ];
        
        channel.invokeMethod(UnityAdsConstants.BANNER_ERROR_METHOD, arguments: arguments);
    }
    
    func bannerViewDidLeaveApplication(_ bannerView: UADSBannerView) {
    }
    
    private func convertError(_ error: UADSBannerError) -> String {
        switch (error.code) {
        case 0:
            return "unknown"
        case 1:
            return "native"
        case 2:
            return "webView"
        case 3:
            return "noFill"
        default:
            return ""
        }
    }
}
