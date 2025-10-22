#import "VclReactNative.h"
#import <objc/message.h>

// Import the auto-generated Swift interface header
#if __has_include(<VclReactNative/VclReactNative-Swift.h>)
#import <VclReactNative/VclReactNative-Swift.h>
#elif __has_include("VclReactNative-Swift.h")
#import "VclReactNative-Swift.h"
#else
#warning "VclReactNative-Swift.h not found. Ensure the Swift sources are compiled and the header is exposed."
#endif

@implementation VclReactNative

//RCT_EXPORT_MODULE()
RCT_EXPORT_MODULE(VclAuthReactNative)

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
  return std::make_shared<facebook::react::NativeVclReactNativeSpecJSI>(params);
}

// MARK: - Spec methods (must match the generated header signatures)

- (void)initialize:(NSDictionary *)initializationDescriptor
            resolve:(RCTPromiseResolveBlock)resolve
             reject:(RCTPromiseRejectBlock)reject
{
  [VclReactNativeImpl.shared initializeWithInitializationDescriptorDictionary:initializationDescriptor
                                                                      resolve:resolve
                                                                       reject:reject];
}

- (void)getCountries:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject {
  [VclReactNativeImpl.shared getCountriesWithResolve:resolve reject:reject];
}

- (void)getCredentialTypeSchemas:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject {
  [VclReactNativeImpl.shared getCredentialTypeSchemasWithResolve:resolve reject:reject];
}

- (void)getCredentialTypes:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject {
  [VclReactNativeImpl.shared getCredentialTypesWithResolve:resolve reject:reject];
}

- (void)getPresentationRequest:(NSDictionary *)presentationRequestDescriptor resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject {
  [VclReactNativeImpl.shared getPresentationRequestWithPresentationRequestDescriptorDictionary:presentationRequestDescriptor resolve:resolve reject:reject];
}

- (void)submitPresentation:(NSDictionary *)presentationSubmission authToken:(NSDictionary *)authToken resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject {
  [VclReactNativeImpl.shared submitPresentationWithPresentationSubmissionDictionary:presentationSubmission authTokenDictionary:authToken resolve:resolve reject:reject];
}

- (void)getExchangeProgress:(NSDictionary *)exchangeDescriptor resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject {
  [VclReactNativeImpl.shared getExchangeProgressWithExchangeDescriptorDictionary:exchangeDescriptor resolve:resolve reject:reject];
}

- (void)getCredentialManifest:(NSDictionary *)credentialManifestDescriptor resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject {
  [VclReactNativeImpl.shared getCredentialManifestWithCredentialManifestDescriptorDictionary:credentialManifestDescriptor resolve:resolve reject:reject];
}

- (void)generateOffers:(NSDictionary *)generateOffersDescriptor resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject {
  [VclReactNativeImpl.shared generateOffersWithGenerateOffersDescriptorDictionary:generateOffersDescriptor resolve:resolve reject:reject];
}

- (void)checkForOffers:(NSDictionary *)generateOffersDescriptor sessionToken:(NSDictionary *)sessionToken resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject {
  [VclReactNativeImpl.shared checkForOffersWithGenerateOffersDescriptorDictionary:generateOffersDescriptor sessionTokenDictionary:sessionToken resolve:resolve reject:reject];
}

- (void)finalizeOffers:(NSDictionary *)finalizeOffersDescriptor sessionToken:(NSDictionary *)sessionToken resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject {
  [VclReactNativeImpl.shared finalizeOffersWithFinalizeOffersDescriptorDictionary:finalizeOffersDescriptor sessionTokenDictionary:sessionToken resolve:resolve reject:reject];
}

- (void)getAuthToken:(NSDictionary *)authTokenDescriptor resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject {
  [VclReactNativeImpl.shared getAuthTokenWithAuthTokenDescriptorDictionary:authTokenDescriptor resolve:resolve reject:reject];
}

- (void)getCredentialTypesUIFormSchema:(NSDictionary *)credentialTypesUIFormSchemaDescriptor resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject {
  [VclReactNativeImpl.shared getCredentialTypesUIFormSchemaWithCredentialTypesUIFormSchemaDescriptorDictionary:credentialTypesUIFormSchemaDescriptor resolve:resolve reject:reject];
}

- (void)getVerifiedProfile:(NSDictionary *)verifiedProfileDescriptor resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject {
  [VclReactNativeImpl.shared getVerifiedProfileWithVerifiedProfileDescriptorDictionary:verifiedProfileDescriptor resolve:resolve reject:reject];
}

- (void)searchForOrganizations:(NSDictionary *)organizationsSearchDescriptor resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject {
  [VclReactNativeImpl.shared searchForOrganizationsWithOrganizationsSearchDescriptorDictionary:organizationsSearchDescriptor resolve:resolve reject:reject];
}

- (void)verifyJwt:(NSDictionary *)jwt jwkPublic:(NSDictionary *)jwkPublic remoteCryptoServicesToken:(NSDictionary *)remoteCryptoServicesToken resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject {
  [VclReactNativeImpl.shared verifyJwtWithJwtDictionary:jwt publicJwkDictionary:jwkPublic remoteCryptoServicesTokenDictionary:remoteCryptoServicesToken resolve:resolve reject:reject];
}

- (void)generateSignedJwt:(NSDictionary *)jwtDescriptor didJwk:(NSDictionary *)didJwk remoteCryptoServicesToken:(NSDictionary *)remoteCryptoServicesToken resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject {
  [VclReactNativeImpl.shared generateSignedJwtWithJwtDescriptorDictionary:jwtDescriptor didJwkDictionary:didJwk remoteCryptoServicesTokenDictionary:remoteCryptoServicesToken resolve:resolve reject:reject];
}

- (void)generateDidJwk:(NSDictionary *)didJwkDescriptor resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject {
  [VclReactNativeImpl.shared generateDidJwkWithDidJwkDescriptorDictionary:didJwkDescriptor resolve:resolve reject:reject];
}

@end
