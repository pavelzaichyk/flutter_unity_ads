import UnityAds

class PrivacyConsent {
    
    func set(_ args: NSDictionary) -> Bool {
        let type = args[UnityAdsConstants.PRIVACY_CONSENT_TYPE_PARAMETER] as! String
        let value = args[UnityAdsConstants.PRIVACY_CONSENT_VALUE_PARAMETER] as! Bool
        let metaData = UADSMetaData.init();
        let success = metaData.set(defineType(type), value: value)
        metaData.commit();
        return success;
    }
    
    private func defineType(_ type: String) -> String {
        switch (type) {
        case "pipl":
            return "pipl.consent";
        case "gdpr":
            return "gdpr.consent";
        case "ccpa":
            return "privacy.consent";
        case "ageGate":
            return "privacy.useroveragelimit";
        default: return type;
        }
    }
}
