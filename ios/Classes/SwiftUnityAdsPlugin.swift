import Flutter
import UnityAds

public class SwiftUnityAdsPlugin: NSObject, FlutterPlugin {
    
    static var viewController : UIViewController =  UIViewController();
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        viewController =
            (UIApplication.shared.delegate?.window??.rootViewController)!;
        let messenger = registrar.messenger()
        
        let channel = FlutterMethodChannel(name: UnityAdsConstants.MAIN_CHANNEL, binaryMessenger: messenger)
        channel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            let args = call.arguments as! NSDictionary
            switch call.method {
                case UnityAdsConstants.INIT_METHOD:
                    result(initialize(args))
                case UnityAdsConstants.IS_READY_METHOD:
                    result(isReady(args))
                case UnityAdsConstants.SHOW_VIDEO_METHOD:
                    result(showVideo(args))
                default:
                    result(FlutterMethodNotImplemented)
            }
        })
        
        UnityAds.add(UnityAdsListener(messenger: messenger, defaultChannel: channel))
        
        registrar.register(
            BannerAdFactory(messenger: messenger),
            withId: UnityAdsConstants.BANNER_AD_CHANNEL
        )
        
    }
    
    static func initialize(_ args: NSDictionary) -> Bool {
        let gameId = args[UnityAdsConstants.GAME_ID_PARAMETER] as! String
        let testMode = args[UnityAdsConstants.TEST_MODE_PARAMETER] as! Bool
        UnityAds.initialize(gameId, testMode: testMode)
        return true
    }
    
    static func isReady(_ args: NSDictionary) -> Bool {
        let placementId = args[UnityAdsConstants.PLACEMENT_ID_PARAMETER] as! String
        return UnityAds.isReady(placementId)
    }
    
    static func showVideo(_ args: NSDictionary) -> Bool {
        let placementId = args[UnityAdsConstants.PLACEMENT_ID_PARAMETER] as! String
        if (UnityAds.isReady(placementId)) {
            UnityAds.show(viewController, placementId: placementId)
            return true
        }
        return false
    }
}
