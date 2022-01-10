import UnityAds

public class UnityAdsLoadListener : NSObject, UnityAdsLoadDelegate {
    var placementChannels: [String: FlutterMethodChannel];
    let messenger: FlutterBinaryMessenger
    
    init(messenger: FlutterBinaryMessenger, placementChannels: [String: FlutterMethodChannel]) {
        self.messenger = messenger
        self.placementChannels = placementChannels
    }
    
    public func unityAdsAdLoaded(_ placementId: String) {
        invokeMethod(UnityAdsConstants.LOAD_COMPLETE_METHOD, placementId, arguments: [:])
    }
    
    public func unityAdsAdFailed(toLoad placementId: String, withError error: UnityAdsLoadError, withMessage message: String) {
        var arguments: [String:String] = [:]
        arguments[UnityAdsConstants.ERROR_CODE_PARAMETER]=convertError(error)
        arguments[UnityAdsConstants.ERROR_MESSAGE_PARAMETER]=message
        invokeMethod(UnityAdsConstants.LOAD_FAILED_METHOD, placementId, arguments: arguments)
    }
    
    func invokeMethod(_ methodName: String,_ placementId: String, arguments: [String:String]){
        var args = arguments;
        args[UnityAdsConstants.PLACEMENT_ID_PARAMETER]=placementId
        var channel = placementChannels[placementId]
        if (channel == nil) {
            channel = FlutterMethodChannel(name: UnityAdsConstants.VIDEO_AD_CHANNEL + "_" + placementId, binaryMessenger: messenger)
            placementChannels[placementId] = channel
        }
        channel?.invokeMethod(methodName, arguments: args)
    }
    
    private func convertError(_ error: UnityAdsLoadError) -> String {
        switch (error) {
        case .initializeFailed:
            return "initializeFailed"
        case .internal:
            return "internal"
        case .invalidArgument:
            return "invalidArgument"
        case .noFill:
            return "noFill"
        case .timeout:
            return "timeout"
        @unknown default:
            return ""
        }
    }
}
