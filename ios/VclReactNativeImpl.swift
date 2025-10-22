//
//  VclReactNativeImpl.swift
//  vcl-react-native
//
//  Created by Michael Avoyan on 05/07/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation
import React
import VCL

@objc public class VclReactNativeImpl: NSObject {
  
  @objc public static let shared = VclReactNativeImpl()

  private let vcl = VCLProvider.vclInstance()

  private func initGlobalConfigurations(
    _ initializationDescriptor: VCLInitializationDescriptor
  ) {
    GlobalConfig.CurrentEnvironment = initializationDescriptor.environment
    GlobalConfig.IsDebugOn = initializationDescriptor.isDebugOn
  }

//  @objc(initialize:withResolver:withRejecter:)
  @objc public func initialize(
    initializationDescriptorDictionary: [String: Any],
    resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock
  ) {
    let initializationDescriptor = dictionaryToInitializationDescriptor(initializationDescriptorDictionary)
    initGlobalConfigurations(initializationDescriptor)
    vcl.initialize(
      initializationDescriptor: initializationDescriptor,
      successHandler: {
        resolve("VCL initialization succeed!")
      },
      errorHandler: {
        reject(nil, $0.toDictionary().toJsonString(), $0)
      })
  }

//  @objc(getCountries:withRejecter:)
  @objc public func getCountries(
    resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock
  ) {
    if let countries = vcl.countries {
      resolve(countriesToDictionary(countries))
    } else {
      let message = "Countries not found"
      reject(nil, message, VCLError(message: message))
    }
  }

//  @objc(getCredentialTypeSchemas:withRejecter:)
  @objc public func getCredentialTypeSchemas(
    resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock
  ) {
    if let credentialTypeSchemas = vcl.credentialTypeSchemas {
      resolve(credentialTypeSchemasToDictionary(credentialTypeSchemas))
    } else {
      let message = "Credential Type Schemas not found"
      reject(nil, message, VCLError(message: message))
    }
  }

//  @objc(getCredentialTypes:withRejecter:)
  @objc public func getCredentialTypes(
    resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock
  ) {
    if let credentialTypes = vcl.credentialTypes {
      resolve(credentialTypesToDictionary(credentialTypes))
    } else {
      let message = "Credential Types not found"
      reject(nil, message, VCLError(message: message))
    }
  }

//  @objc(getPresentationRequest:withResolver:withRejecter:)
  @objc public func getPresentationRequest(
    presentationRequestDescriptorDictionary: [String: Any],
    resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock
  ) {
    vcl.getPresentationRequest(
      presentationRequestDescriptor: dictionaryTopPresentationRequestDescriptor(presentationRequestDescriptorDictionary),
      successHandler: {
        resolve(presentationRequestToDictionary($0))
      },
      errorHandler: {
        reject(nil, $0.toDictionary().toJsonString(), $0)
      }
    )
  }

//  @objc(submitPresentation:withAuthTokenDictionary:withResolver:withRejecter:)
  @objc public func submitPresentation(
    presentationSubmissionDictionary: [String: Any],
    authTokenDictionary: [String: Any],
    resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock
  ) {
    vcl.submitPresentation(
      presentationSubmission: dictionaryToPresentationSubmission(
        presentationSubmissionDictionary
      ),
      authToken: dictionaryToAuthToken(authTokenDictionary),
      successHandler: {
        resolve(presentationSubmissionResultToDictionary($0))
      },
      errorHandler: {
        reject(nil, $0.toDictionary().toJsonString(), $0)
      })
  }

//  @objc(getExchangeProgress:withResolver:withRejecter:)
  @objc public func getExchangeProgress(
    exchangeDescriptorDictionary: [String: Any],
    resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock
  ) {
    vcl.getExchangeProgress(
      exchangeDescriptor: dictionaryToExchangeDescriptor(exchangeDescriptorDictionary),
      successHandler: {
        resolve(exchangeToDictionary($0))
      },
      errorHandler: {
        reject(nil, $0.toDictionary().toJsonString(), $0)
      })
  }

//  @objc(searchForOrganizations:withResolver:withRejecter:)
  @objc public func searchForOrganizations(
    organizationsSearchDescriptorDictionary: [String: Any],
    resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock
  ) {
    vcl.searchForOrganizations(
      organizationsSearchDescriptor: dictionayToOrganizationsSearchDescriptor(organizationsSearchDescriptorDictionary),
      successHandler: {
        resolve(organizationsToDictionary($0))
      },
      errorHandler: {
        reject(nil, $0.toDictionary().toJsonString(), $0)
      })
  }

//  @objc(getCredentialManifest:withResolver:withRejecter:)
  @objc public func getCredentialManifest(
    credentialManifestDescriptorDictionary: [String: Any],
    resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock
  ) {
    VCLLog.d("credentialManifestDescriptorDictionary dictionary: \(credentialManifestDescriptorDictionary)")
    if let credentialManifestDescriptor = dictionaryToCredentialManifestDescriptor(credentialManifestDescriptorDictionary) {
      VCLLog.d("credentialManifestDescriptor VCL entity: \(credentialManifestDescriptor.toPropsString())")
      vcl.getCredentialManifest(
        credentialManifestDescriptor: credentialManifestDescriptor,
        successHandler: {
          resolve(credentialManifestToDictionary($0))
        },
        errorHandler: {
          reject(nil, $0.toDictionary().toJsonString(), $0)
        })
    } else {
      reject(nil, "Unexpected Credential Credential Manifest Descriptor: \(credentialManifestDescriptorDictionary)", nil)
    }
  }

//  @objc(generateOffers:withResolver:withRejecter:)
  @objc public func generateOffers(
    generateOffersDescriptorDictionary: [String: Any],
    resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock
  ) {
    vcl.generateOffers(
      generateOffersDescriptor: dictionaryToGenerateOffersDescriptor(generateOffersDescriptorDictionary),
      successHandler: {
        resolve(offersToDictionary($0))
      },
      errorHandler: {
        reject(nil, $0.toDictionary().toJsonString(), $0)
      })
  }

//  @objc(checkForOffers:withtSessionTokenDictionary:withResolver:withRejecter:)
  @objc public func checkForOffers(
    generateOffersDescriptorDictionary: [String: Any],
    sessionTokenDictionary: [String: Any],
    resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock
  ) {
    vcl.checkForOffers(
      generateOffersDescriptor: dictionaryToGenerateOffersDescriptor(generateOffersDescriptorDictionary),
      sessionToken: dictionaryToToken(sessionTokenDictionary),
      successHandler: {
        resolve(offersToDictionary($0))
      },
      errorHandler: {
        reject(nil, $0.toDictionary().toJsonString(), $0)
      })
  }

//  @objc(finalizeOffers:withSessionTokenDictionary:withResolver:withRejecter:)
  @objc public func finalizeOffers(
    finalizeOffersDescriptorDictionary: [String: Any],
    sessionTokenDictionary: [String: Any],
    resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock
  ) {
    vcl.finalizeOffers(
      finalizeOffersDescriptor: dictionaryToFinalizedOffersDescriptor(finalizeOffersDescriptorDictionary),
      sessionToken: dictionaryToToken(sessionTokenDictionary),
      successHandler: {
        resolve(jwtVerifiableCredentialsToDictionary($0))
      },
      errorHandler: {
        reject(nil, $0.toDictionary().toJsonString(), $0)
      })
  }
  
//  @objc(getAuthToken:withResolver:withRejecter:)
  @objc public func getAuthToken(
    authTokenDescriptorDictionary: [String: Any],
    resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock
  ) {
    vcl.getAuthToken(authTokenDescriptor: dictionaryToAuthTokenDescriptor(authTokenDescriptorDictionary),
      successHandler: {
        resolve(authTokenToDictionary($0))
      },
      errorHandler: {
        reject(nil, $0.toDictionary().toJsonString(), $0)
      })
  }

//  @objc(getCredentialTypesUIFormSchema:withResolver:withRejecter:)
  @objc public func getCredentialTypesUIFormSchema(
    credentialTypesUIFormSchemaDescriptorDictionary: [String: Any],
    resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock
  ) {
    vcl.getCredentialTypesUIFormSchema(
      credentialTypesUIFormSchemaDescriptor: readableMapToCredentialTypesUIFormSchemaDescriptor(credentialTypesUIFormSchemaDescriptorDictionary),
      successHandler: {
        resolve(credentialTypesFormSchemaToDictionary($0))
      },
      errorHandler: {
        reject(nil, $0.toDictionary().toJsonString(), $0)
      }
    )
  }

//  @objc(getVerifiedProfile:withResolver:withRejecter:)
  @objc public func getVerifiedProfile(
    verifiedProfileDescriptorDictionary: [String: Any],
    resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock
  ) {
    vcl.getVerifiedProfile(
      verifiedProfileDescriptor: dictionaryToVerifiedProfileDescriptor(verifiedProfileDescriptorDictionary),
      successHandler: {
        resolve(verifiedProfileToDictionary($0))
      },
      errorHandler: {
        reject(nil, $0.toDictionary().toJsonString(), $0)
      })
  }

//  @objc(verifyJwt:withPublicJwkDictionary:withRemoteCryptoServicesTokenDictionary:withResolver:withRejecter:)
  @objc public func verifyJwt(
    jwtDictionary: [String: Any],
    publicJwkDictionary: [String: Any],
    remoteCryptoServicesTokenDictionary: [String: Any]? = nil,
    resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock
  ) {
    vcl.verifyJwt(
      jwt: dictionaryToJwt(jwtDictionary),
      publicJwk: dictionaryToPublicJwk(publicJwkDictionary),
      remoteCryptoServicesToken: dictionaryToToken(remoteCryptoServicesTokenDictionary),
      successHandler: {
        resolve($0)
      },
      errorHandler: {
        reject(nil, $0.toDictionary().toJsonString(), $0)
      })
  }

//  @objc(generateSignedJwt:withDidJwkDictionary:withRemoteCryptoServicesTokenDictionary:withResolver:withRejecter:)
  @objc public func generateSignedJwt(
    jwtDescriptorDictionary: [String: Any],
    didJwkDictionary: [String: Any],
    remoteCryptoServicesTokenDictionary: [String: Any]? = nil,
    resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock
  ) {
    vcl.generateSignedJwt(
      jwtDescriptor: dictionaryToJwtDescriptor(jwtDescriptorDictionary),
      didJwk: dictionaryToDidJwk(didJwkDictionary),
      remoteCryptoServicesToken: dictionaryToToken(remoteCryptoServicesTokenDictionary),
      successHandler: {
        resolve(jwtToDictionary($0))
      },
      errorHandler: {
        reject(nil, $0.toDictionary().toJsonString(), $0)
      })
  }

//  @objc(generateDidJwk:withResolver:withRejecter:)
  @objc public func generateDidJwk(
    didJwkDescriptorDictionary: [String: Any]? = nil,
    resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock
  ) {
    vcl.generateDidJwk(
      didJwkDescriptor: dictionaryToDidJwkDescriptor(didJwkDescriptorDictionary),
      successHandler: {
        resolve(didJwkToDictionary($0))
      },
      errorHandler: {
        reject(nil, $0.toDictionary().toJsonString(), $0)
      })
  }
}

