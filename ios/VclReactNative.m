//  Created by Michael Avoyan on 05/07/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0
//

#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(VclReactNative, NSObject)

RCT_EXTERN_METHOD(initialize:(NSDictionary*)environmentDictionary
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(getCountries:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(getCredentialTypeSchemas:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(getCredentialTypes:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(getPresentationRequest:(NSDictionary*)presentationRequestDescriptorDictionary
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(submitPresentation:(NSDictionary*)presentationSubmissionDictionary
                  withDidJwkDictionary:(NSDictionary*)didJwkDictionary
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(getExchangeProgress:(NSDictionary*)exchangeDescriptorDictionary
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(searchForOrganizations:(NSDictionary*)organizationsSearchDescriptorDictionary
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(getCredentialManifest:(NSDictionary*)credentialManifestDescriptorDictionary
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(generateOffers:(NSDictionary*)generateOffersDescriptorDictionary
                  withDidJwkDictionary:(NSDictionary*)didJwkDictionary
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(checkForOffers:(NSDictionary*)generateOffersDescriptorDictionary
                  withTokenDictionary:(NSDictionary*)tokenDictionary
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(finalizeOffers:(NSDictionary*)finalizeOffersDescriptorDictionary
                  withDidJwkDictionary:(NSDictionary*)didJwkDictionary
                  withTokenDictionary:(NSDictionary*)tokenDictionary
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(getCredentialTypesUIFormSchema:(NSDictionary*)credentialTypesUIFormSchemaDescriptorDictionary
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(getVerifiedProfile:(NSDictionary*)verifiedProfileDescriptorDictionary
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(verifyJwt:(NSDictionary*)jwtDictionary
                  withJwkPublicDictionary:(NSDictionary*)jwkPublicDictionary
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(generateSignedJwt:(NSDictionary*)jwtDescriptorDictionary
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(generateDidJwk:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)

@end
