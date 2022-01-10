import UnityAds

public class UnityAdsInitializationListener : NSObject, UnityAdsInitializationDelegate {
    
    let channel : FlutterMethodChannel
    
    init(channel: FlutterMethodChannel) {
        self.channel = channel
    }
    
    public func initializationComplete() {
        channel.invokeMethod(UnityAdsConstants.INIT_COMPLETE_METHOD, arguments: [])
    }
    
    public func initializationFailed(_ error: UnityAdsInitializationError, withMessage message: String) {
        var arguments: [String:String] = [:]
        arguments[UnityAdsConstants.ERROR_CODE_PARAMETER]=convertError(error)
        arguments[UnityAdsConstants.ERROR_MESSAGE_PARAMETER]=message
        channel.invokeMethod(UnityAdsConstants.INIT_FAILED_METHOD, arguments: arguments)
    }
    
    private func convertError(_ error: UnityAdsInitializationError) -> String {
        switch (error) {
        case .initializationErrorInternalError:
            return "internalError";
        case .initializationErrorInvalidArgument:
            return "invalidArgument";
        case .initializationErrorAdBlockerDetected:
            return "adBlockerDetected";
        @unknown default:
            return "";
        }
    }
    
}
