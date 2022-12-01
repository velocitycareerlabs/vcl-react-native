//  Created by Michael Avoyan on 05/07/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0
//

import VCL

@objc(VclReactNative)
class VclReactNative: NSObject {
    
    private let vcl = VCLProvider.vclInstance()
    
    @objc(initialize:withResolver:withRejecter:)
    func initialize(
        initializationDescriptorDictionary: [String: Any],
        resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock
    ) {
        vcl.initialize(
            initializationDescriptor: dictionaryToInitializationDescriptor(initializationDescriptorDictionary),
            successHandler: {
                resolve("VCL initialization succeed!")
            },
            errorHandler: {
                reject(nil, $0.description, $0)
            })
    }
    
    @objc(getCountries:withRejecter:)
    func getCountries(
        resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock
    ) {
        if let countries = vcl.countries {
            resolve(countriesToDictionary(countries))
        } else {
            let description = "Countries not found"
            reject(nil, description, VCLError(description: description))
        }
    }
    
    @objc(getCredentialTypeSchemas:withRejecter:)
    func getCredentialTypeSchemas(
        resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock
    ) {
        if let credentialTypeSchemas = vcl.credentialTypeSchemas {
            resolve(credentialTypeSchemasToDictionary(credentialTypeSchemas))
        } else {
            let description = "Credential Type Schemas not found"
            reject(nil, description, VCLError(description: description))
        }
    }
    
    @objc(getCredentialTypes:withRejecter:)
    func getCredentialTypes(
        resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock
    ) {
        if let credentialTypes = vcl.credentialTypes {
            resolve(credentialTypesToDictionary(credentialTypes))
        } else {
            let description = "Credential Types not found"
            reject(nil, description, VCLError(description: description))
        }
    }
    
    @objc(getPresentationRequest:withResolver:withRejecter:)
    func getPresentationRequest(
        deepLinkDictionary: [String: String],
        resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock
    ) {
        vcl.getPresentationRequest(
            deepLink: dictionaryToDeepLink(deepLinkDictionary),
            successHandler: {
                resolve(presentationRequestToDictionary($0))
            },
            errorHandler: {
                reject(nil, $0.description, $0)
            }
        )
    }
    
    @objc(submitPresentation:withResolver:withRejecter:)
    func submitPresentation(
        presentationSubmissionDictionary: [String: Any],
        resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock
    ) {
        vcl.submitPresentation(
            presentationSubmission: dictionaryToPresentationSubmission(presentationSubmissionDictionary),
            successHandler: {
                resolve(presentationSubmissionResultToDictionary($0))
            },
            errorHandler: {
                reject(nil, $0.description, $0)
            })
    }
    
    @objc(getExchangeProgress:withResolver:withRejecter:)
    func getExchangeProgress(
        exchangeDescriptorDictionary: [String: Any],
        resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock
    ) {
        vcl.getExchangeProgress(
            exchangeDescriptor: dictionaryToExchangeDescriptor(exchangeDescriptorDictionary),
            successHandler: {
                resolve(exchangeToDictionary($0))
            },
            errorHandler: {
                reject(nil, $0.description, $0)
            })
    }
    
    @objc(searchForOrganizations:withResolver:withRejecter:)
    func searchForOrganizations(
        organizationsSearchDescriptorDictionary: [String: Any],
        resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock
    ) {
        vcl.searchForOrganizations(
            organizationsSearchDescriptor: dictionayToOrganizationsSearchDescriptor(organizationsSearchDescriptorDictionary),
            successHandler: {
                resolve(organizationsToDictionary($0))
            },
            errorHandler: {
                reject(nil, $0.description, $0)
            })
    }
    
    @objc(getCredentialManifest:withResolver:withRejecter:)
    func getCredentialManifest(
        credentialManifestDescriptorDictionary: [String: Any],
        resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock
    ) {
        if let credentialManifestDescriptor = dictionaryToCredentialManifestDescriptor(credentialManifestDescriptorDictionary) {
        vcl.getCredentialManifest(
            credentialManifestDescriptor: credentialManifestDescriptor,
            successHandler: {
                resolve(credentialManifestToDictionary($0))
            },
            errorHandler: {
                reject(nil, $0.description, $0)
            })
        } else {
            reject(nil, "Unexpected Credential Credential Manifest Descriptor: \(credentialManifestDescriptorDictionary)", nil)
        }
    }
    
    @objc(generateOffers:withResolver:withRejecter:)
    func generateOffers(
        generateOffersDescriptorDictionary: [String: Any],
        resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock
    ) {
        vcl.generateOffers(
            generateOffersDescriptor: dictionaryToGenerateOffersDescriptor(generateOffersDescriptorDictionary),
            successHandler: {
                resolve(generatedOffersToDictionary($0))
            },
            errorHandler: {
                reject(nil, $0.description, $0)
            })
    }
    
    @objc(checkForOffers:withTokenDictionary:withResolver:withRejecter:)
    func checkForOffers(
        generateOffersDescriptorDictionary: [String: Any],
        tokenDictionary: [String: Any],
        resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock
    ) {
        vcl.checkForOffers(
            generateOffersDescriptor: dictionaryToGenerateOffersDescriptor(generateOffersDescriptorDictionary),
            token: dictionaryToToken(tokenDictionary),
            successHandler: {
                resolve(generatedOffersToDictionary($0))
            },
            errorHandler: {
                reject(nil, $0.description, $0)
            })
    }
    
    @objc(finalizeOffers:withTokenDictionary:withResolver:withRejecter:)
    func finalizeOffers(
        finalizeOffersDescriptorDictionary: [String: Any],
        tokenDictionary: [String: Any],
        resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock
    ) {
        vcl.finalizeOffers(
            finalizeOffersDescriptor: dictionaryToFinalizedOffersDescriptor(finalizeOffersDescriptorDictionary),
            token: dictionaryToToken(tokenDictionary),
            successHandler: {
                resolve(jwtVerifiableCredentialsToDictionary($0))
            },
            errorHandler: {
                reject(nil, $0.description, $0)
            })
    }
    
    @objc(getCredentialTypesUIFormSchema:withResolver:withRejecter:)
    func getCredentialTypesUIFormSchema(
        credentialTypesUIFormSchemaDescriptorDictionary: [String: Any],
        resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock
    ) {
      vcl.getCredentialTypesUIFormSchema(
        credentialTypesUIFormSchemaDescriptor: readableMapToCredentialTypesUIFormSchemaDescriptor(credentialTypesUIFormSchemaDescriptorDictionary),
        successHandler: {
          resolve(credentialTypesFormSchemaToDictionary($0))
        },
        errorHandler: {
            reject(nil, $0.description, $0)
        }
      )
    }
    
    @objc(getVerifiedProfile:withResolver:withRejecter:)
    func getVerifiedProfile(
        verifiedProfileDescriptorDictionary: [String: Any],
        resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock
    ) {
        vcl.getVerifiedProfile(
            verifiedProfileDescriptor: dictionaryToVerifiedProfileDescriptor(verifiedProfileDescriptorDictionary),
            successHandler: {
                resolve(verifiedProfileToDictionary($0))
            },
            errorHandler: {
                reject(nil, $0.description, $0)
            })
    }
    
    @objc(verifyJwt:withPublicKeyDictionary:withResolver:withRejecter:)
    func verifyJwt(
        jwtDictionary: [String: Any],
        publicKeyDictionary: [String: Any],
        resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock
    ) {
        vcl.verifyJwt(
            jwt: dictionaryToJwt(jwtDictionary),
            publicKey: dictionaryToPublicKey(publicKeyDictionary),
            successHandler: {
                resolve($0)
            },
            errorHandler: {
                reject(nil, $0.description, $0)
            })
    }
    
    @objc(generateSignedJwt:withIss:withJti:withResolver:withRejecter:)
    func generateSignedJwt(
        jwtDictionary: [String: Any],
        iss: String,
        jti: String,
        resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock
    ) {
        vcl.generateSignedJwt(
            payload: jwtDictionary,
            iss: iss,
            jti: jti,
            successHandler: {
                resolve(jwtToReadableMap($0))
            },
            errorHandler: {
                reject(nil, $0.description, $0)
            })
    }
}
