package com.rebeloid.unity_ads.privacy;

import android.content.Context;

import com.rebeloid.unity_ads.UnityAdsConstants;
import com.unity3d.ads.metadata.MetaData;

import java.util.Map;

public class PrivacyConsent {
    private Context activity;

    public boolean set(Map<?, ?> args) {
        String type = (String) args.get(UnityAdsConstants.PRIVACY_CONSENT_TYPE_PARAMETER);
        Boolean value = (Boolean) args.get(UnityAdsConstants.PRIVACY_CONSENT_VALUE_PARAMETER);

        MetaData metaData = new MetaData(activity);
        boolean success = metaData.set(defineType(type), value);
        metaData.commit();
        return success;
    }

    private String defineType(String type) {
        if (type == null) {
            return null;
        }
        switch (type) {
            case "pipl":
                return "pipl.consent";
            case "gdpr":
                return "gdpr.consent";
            case "ccpa":
                return "privacy.consent";
            case "ageGate":
                return "privacy.useroveragelimit";
            default:
                return type;
        }
    }

    public void setActivity(Context activity) {
        this.activity = activity;
    }
}
