import UnityAds

public class UnityAdsLoadListener : NSObject, UnityAdsLoadDelegate {
    let placementChannelManager: PlacementChannelManager
    
    init(placementChannelManager: PlacementChannelManager) {
        self.placementChannelManager = placementChannelManager
    }
    
    public func unityAdsAdLoaded(_ placementId: String) {
        placementChannelManager.invokeMethod(UnityAdsConstants.LOAD_COMPLETE_METHOD, placementId)
    }
    
    public func unityAdsAdFailed(toLoad placementId: String, withError error: UnityAdsLoadError, withMessage message: String) {
        placementChannelManager.invokeMethod(UnityAdsConstants.LOAD_FAILED_METHOD, placementId, withErrorCode: convertError(error), withMessage: message)
    }
    
    private func convertError(_ error: UnityAdsLoadError) -> String {
        switch (error) {
        case .initializeFailed:
            return "initializeFailed"
        case .internal:
            return "internalError"
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
