//  Created by Michael Avoyan on 05/07/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0
//

#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(VclReactNative, NSObject)

RCT_EXTERN_METHOD(initialize:(NSDictionary*)initializationDescriptorDictionary
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(getCountries:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(getCredentialTypeSchemas:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(getCredentialTypes:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(getPresentationRequest:(NSDictionary*)presentationRequestDescriptorDictionary
                  withRemoteCryptoServicesTokenDictionary:(NSDictionary*)remoteCryptoServicesTokenDictionary
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(submitPresentation:(NSDictionary*)presentationSubmissionDictionary
                  withDidJwkDictionary:(NSDictionary*)didJwkDictionary
                  withRemoteCryptoServicesTokenDictionary:(NSDictionary*)remoteCryptoServicesTokenDictionary
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(getExchangeProgress:(NSDictionary*)exchangeDescriptorDictionary
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(searchForOrganizations:(NSDictionary*)organizationsSearchDescriptorDictionary
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(getCredentialManifest:(NSDictionary*)credentialManifestDescriptorDictionary
                  withRemoteCryptoServicesTokenDictionary:(NSDictionary*)remoteCryptoServicesTokenDictionary
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(generateOffers:(NSDictionary*)generateOffersDescriptorDictionary
                  withDidJwkDictionary:(NSDictionary*)didJwkDictionary
                  withRemoteCryptoServicesTokenDictionary:(NSDictionary*)remoteCryptoServicesTokenDictionary
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(checkForOffers:(NSDictionary*)generateOffersDescriptorDictionary
                  withtSessionTokenDictionary:(NSDictionary*)sessionTokenDictionary
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(finalizeOffers:(NSDictionary*)finalizeOffersDescriptorDictionary
                  withDidJwkDictionary:(NSDictionary*)didJwkDictionary
                  withSessionTokenDictionary:(NSDictionary*)sessionTokenDictionary
                  withRemoteCryptoServicesTokenDictionary:(NSDictionary*)remoteCryptoServicesTokenDictionary
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(getCredentialTypesUIFormSchema:(NSDictionary*)credentialTypesUIFormSchemaDescriptorDictionary
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(getVerifiedProfile:(NSDictionary*)verifiedProfileDescriptorDictionary
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(verifyJwt:(NSDictionary*)jwtDictionary
                  withPublicJwkDictionary:(NSDictionary*)publicJwkDictionary
                  withRemoteCryptoServicesTokenDictionary:(NSDictionary*)remoteCryptoServicesTokenDictionary
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(generateSignedJwt:(NSDictionary*)didJwkDictionary
                  withJwtDescriptorDictionary:(NSDictionary*)jwtDescriptorDictionary
                  withRemoteCryptoServicesTokenDictionary:(NSDictionary*)remoteCryptoServicesTokenDictionary
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(generateDidJwk:(NSDictionary*)remoteCryptoServicesTokenDictionary
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)


+ (BOOL)requiresMainQueueSetup
{
  return NO;
}

@end
