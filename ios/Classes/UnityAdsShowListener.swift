import Flutter
import UnityAds

public class UnityAdsShowListener : NSObject, UnityAdsShowDelegate {
    let placementChannelManager: PlacementChannelManager
    
    init(placementChannelManager: PlacementChannelManager) {
        self.placementChannelManager = placementChannelManager
    }
    
    public func unityAdsShowComplete(_ placementId: String, withFinish state: UnityAdsShowCompletionState) {
        if (state == UnityAdsShowCompletionState.showCompletionStateSkipped) {
            placementChannelManager.invokeMethod(UnityAdsConstants.SHOW_SKIPPED_METHOD, placementId)
        } else if (state == UnityAdsShowCompletionState.showCompletionStateCompleted) {
            placementChannelManager.invokeMethod(UnityAdsConstants.SHOW_COMPLETE_METHOD, placementId)
        }
    }

    public func unityAdsShowFailed(_ placementId: String, withError error: UnityAdsShowError, withMessage message: String) {
        placementChannelManager.invokeMethod(UnityAdsConstants.SHOW_FAILED_METHOD, placementId, withErrorCode: convertError(error), withMessage: message)
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
        case .showErrorTimeout:
            return "timeout"
        @unknown default:
            return ""
        }
    }
    
    public func unityAdsShowStart(_ placementId: String) {
        placementChannelManager.invokeMethod(UnityAdsConstants.SHOW_START_METHOD, placementId)
    }
    
    public func unityAdsShowClick(_ placementId: String) {
        placementChannelManager.invokeMethod(UnityAdsConstants.SHOW_CLICK_METHOD, placementId)
    }

}
