import Flutter
import UnityAds

class BannerAdView: NSObject, FlutterPlatformView, UADSBannerViewDelegate {
    private let bannerView : UADSBannerView
    private let uiView : UIView
    private let listener : BannerAdListener
    
    init(frame: CGRect, id: Int64, arguments: Any?, messenger: FlutterBinaryMessenger) {
        let args = arguments as! [String: Any]? ?? [:]
        let placementId =  args[UnityAdsConstants.PLACEMENT_ID_PARAMETER] as? String ?? ""
        
        let width =  args[UnityAdsConstants.WIDTH_PARAMETER] as? CGFloat
        let height = args[UnityAdsConstants.HEIGHT_PARAMETER] as? CGFloat
        let size = CGSize(width: width ?? 320.0, height: height ?? 50.0)
        bannerView = UADSBannerView.init(placementId: placementId, size: size)
        
        let channel =  FlutterMethodChannel(
            name: UnityAdsConstants.BANNER_AD_CHANNEL + "_" + id.description,  binaryMessenger:  messenger)
        listener = BannerAdListener(channel: channel)
        
        uiView = UIView(frame: frame)
        super.init()
        
        bannerView.delegate = listener
        
        bannerView.load()
        uiView.addSubview(bannerView)
        uiView.layoutIfNeeded()
    }
    
    func view() -> UIView {
        uiView
    }
}

