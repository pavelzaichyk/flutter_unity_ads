import Flutter
import UnityAds

public class UnityAdsShowListener : NSObject, UnityAdsShowDelegate {
    
    var placementChannels: [String: FlutterMethodChannel];
    let messenger: FlutterBinaryMessenger
    
    init(messenger: FlutterBinaryMessenger, placementChannels: [String: FlutterMethodChannel]) {
        self.messenger = messenger
        self.placementChannels = placementChannels
    }
    
    public func unityAdsShowComplete(_ placementId: String, withFinish state: UnityAdsShowCompletionState) {
        if (state == UnityAdsShowCompletionState.showCompletionStateSkipped) {
            invokeMethod(UnityAdsConstants.SHOW_SKIPPED_METHOD, placementId, arguments: [:])
        } else if (state == UnityAdsShowCompletionState.showCompletionStateCompleted) {
            invokeMethod(UnityAdsConstants.SHOW_COMPLETE_METHOD, placementId, arguments: [:])
        }
    }
    
    public func unityAdsShowFailed(_ placementId: String, withError error: UnityAdsShowError, withMessage message: String) {
        var arguments: [String:String] = [:]
        arguments[UnityAdsConstants.ERROR_CODE_PARAMETER]=convertError(error)
        arguments[UnityAdsConstants.ERROR_MESSAGE_PARAMETER]=message
        invokeMethod(UnityAdsConstants.SHOW_FAILED_METHOD, placementId, arguments: arguments)
    }
    
    private func convertError(_ error: UnityAdsShowError) -> String {
        switch (error) {
        case .showErrorNotInitialized:
            return "notInitialized"
        case .showErrorNotReady:
            return "notReady"
        case .showErrorVideoPlayerError:
            return "videoPlayerError"
        case .showErrorInvalidArgument:
            return "invalidArgument"
        case .showErrorNoConnection:
            return "noConnection"
        case .showErrorAlreadyShowing:
            return "alreadyShowing"
        case .showErrorInternalError:
            return "internalError"
        @unknown default:
            return ""
        }
    }
    
    public func unityAdsShowStart(_ placementId: String) {
        invokeMethod(UnityAdsConstants.SHOW_START_METHOD, placementId, arguments: [:])
    }
    
    public func unityAdsShowClick(_ placementId: String) {
        invokeMethod(UnityAdsConstants.SHOW_CLICK_METHOD, placementId, arguments: [:])
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
}
