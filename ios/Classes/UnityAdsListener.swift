import Flutter
import UnityAds

public class UnityAdsListener : NSObject, UnityAdsDelegate {
    
    var placementChannels: [String: FlutterMethodChannel] = [:]
    
    let messenger: FlutterBinaryMessenger
    let defaultChannel: FlutterMethodChannel
    
    init(messenger: FlutterBinaryMessenger, defaultChannel: FlutterMethodChannel) {
        self.messenger = messenger
        self.defaultChannel = defaultChannel
        super.init()
    }
    
    public func unityAdsReady(_ placementId: String) {
        invokeMethod(UnityAdsConstants.READY_METHOD,
                     args: [UnityAdsConstants.PLACEMENT_ID_PARAMETER: placementId],
                     placementId: placementId)
    }
    
    public func unityAdsDidError(_ error: UnityAdsError, withMessage message: String) {
        onError(error: error, errorMessage: message)
    }
    
    public func unityAdsDidStart(_ placementId: String) {
        invokeMethod(UnityAdsConstants.START_METHOD,
                     args: [UnityAdsConstants.PLACEMENT_ID_PARAMETER: placementId],
                     placementId: placementId)
    }
    
    public func unityAdsDidFinish(_ placementId: String, with state: UnityAdsFinishState) {
        switch (state) {
            case UnityAdsFinishState.skipped:
                onSkipped(placementId);
                break;
            case UnityAdsFinishState.completed:
                onCompleted(placementId);
                break;
            case UnityAdsFinishState.error:
                onError(placementId: placementId);
                break;
            default:
                return
        }
    }
    
    func onCompleted(_ placementId:String) {
        invokeMethod(UnityAdsConstants.COMPLETE_METHOD,
                     args: [UnityAdsConstants.PLACEMENT_ID_PARAMETER: placementId],
                     placementId: placementId)
    }
    
    func onSkipped(_ placementId:String) {
        invokeMethod(UnityAdsConstants.SKIPPED_METHOD,
                     args: [UnityAdsConstants.PLACEMENT_ID_PARAMETER: placementId],
                     placementId: placementId)
    }
    
    func onError(placementId:String! = nil, error:UnityAdsError! = nil,  errorMessage:String! = nil) {
        var arguments: [String:String] = [:]
        
        if (placementId != nil) {
            arguments[UnityAdsConstants.PLACEMENT_ID_PARAMETER]=placementId
        }
        
        if (error != nil) {
            arguments["errorCode"]=String(describing:  error)
        }
        
        if (errorMessage != nil) {
            arguments["errorMessage"]=errorMessage
        }
        
        invokeMethod(UnityAdsConstants.ERROR_METHOD, args: arguments, placementId: placementId)
    }
    
    func invokeMethod(_ methodName: String, args: [String:String],placementId: String?){
        defaultChannel.invokeMethod(methodName, arguments: args)
        if (placementId != nil) {
            var channel = placementChannels[placementId!]
            if (channel == nil) {
                channel = FlutterMethodChannel(name: UnityAdsConstants.VIDEO_AD_CHANNEL + "_" + placementId!, binaryMessenger: messenger)
                placementChannels[placementId!] = channel
            }
            channel?.invokeMethod(methodName, arguments: args)
        }
    }
}
