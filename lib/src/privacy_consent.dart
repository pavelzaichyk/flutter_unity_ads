/// Privacy consent types
enum PrivacyConsentType {
  /// China’s Personal Information Protection Law (PIPL) https://docs.unity.com/ads/PIPLCompliance.html
  pipl,

  /// General Data Protection Regulation (GDPR) https://docs.unity.com/ads/GDPRCompliance.html
  gdpr,

  /// California Consumer Privacy Act (CCPA) https://docs.unity.com/ads/CCPACompliance.html
  ccpa,

  /// Age gate https://docs.unity.com/ads/ImplementingCustomAgeGates.html
  ageGate,
}
