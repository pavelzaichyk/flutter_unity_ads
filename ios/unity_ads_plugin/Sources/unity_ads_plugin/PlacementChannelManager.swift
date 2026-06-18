import Flutter
import UnityAds

public class PlacementChannelManager {

    var placementChannels: [String: FlutterMethodChannel]
    var loadListeners: [String: UnityAdsLoadListener] = [:]
    var showListeners: [String: UnityAdsShowListener] = [:]
    let binaryMessenger: FlutterBinaryMessenger

    init(binaryMessenger: FlutterBinaryMessenger) {
        self.binaryMessenger = binaryMessenger
        self.placementChannels = [String: FlutterMethodChannel]()
    }

    func getOrCreateLoadListener(placementId: String) -> UnityAdsLoadListener {
        if let listener = loadListeners[placementId] {
            return listener
        }
        let listener = UnityAdsLoadListener(placementChannelManager: self)
        loadListeners[placementId] = listener
        return listener
    }

    func getOrCreateShowListener(placementId: String) -> UnityAdsShowListener {
        if let listener = showListeners[placementId] {
            return listener
        }
        let listener = UnityAdsShowListener(placementChannelManager: self)
        showListeners[placementId] = listener
        return listener
    }

    public func invokeMethod(_ methodName: String, _ placementId: String) {
        invokeMethod(methodName, placementId, arguments: [:])
    }

    public func invokeMethod(_ methodName: String, _ placementId: String, withErrorCode code: String, withMessage message: String) {
        var arguments: [String:String] = [:]
        arguments[UnityAdsConstants.ERROR_CODE_PARAMETER] = code
        arguments[UnityAdsConstants.ERROR_MESSAGE_PARAMETER] = message
        invokeMethod(methodName, placementId, arguments: arguments)
    }

    func invokeMethod(_ methodName: String,_ placementId: String, arguments: [String:String]){
        var args = arguments;
        args[UnityAdsConstants.PLACEMENT_ID_PARAMETER]=placementId
        var channel = placementChannels[placementId]
        if (channel == nil) {
            channel = FlutterMethodChannel(name: UnityAdsConstants.VIDEO_AD_CHANNEL + "_" + placementId, binaryMessenger: binaryMessenger)
            placementChannels[placementId] = channel
        }
        channel?.invokeMethod(methodName, arguments: args)
    }
}
