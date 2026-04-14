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

  private static let bridgedVCLErrorCode = "VCL_BRIDGED_ERROR_V1"
  private static let defaultNativeErrorStackFrameLimit = 5
  private static let maxNativeErrorStackFrameLimit = 20
  private static let nativeStackFramesDictionaryKey = "callStackSymbols"
  
  @objc public static let shared = VclReactNativeImpl()

  private let vcl = VCLProvider.vclInstance()
  private var nativeErrorStackFrameLimit = VclReactNativeImpl.defaultNativeErrorStackFrameLimit

  private func rejectBridgedVCLError(
    _ reject: @escaping RCTPromiseRejectBlock,
    error: VCLError
  ) {
    let serializedError =
      bridgedVCLErrorPayload(error).toJsonString()
      ?? error.message
      ?? "Unexpected VCLError"
    reject(Self.bridgedVCLErrorCode, serializedError, error)
  }

  private func bridgedVCLErrorPayload(_ error: VCLError) -> [String: Any] {
    var payload = [String: Any]()

    if let errorPayload = error.payload {
      payload["payload"] = errorPayload
    }

    if let errorValue = error.error {
      payload["error"] = errorValue
    }

    payload["errorCode"] = error.errorCode

    if let requestId = error.requestId {
      payload["requestId"] = requestId
    }

    if let message = error.message {
      payload["message"] = message
    }

    if let statusCode = error.statusCode {
      payload["statusCode"] = statusCode
    }

    payload["diagnostics"] = bridgedDiagnostics(error)
    return payload
  }

  private func bridgedDiagnostics(_ error: VCLError) -> [String: Any] {
    var diagnostics: [String: Any] = [
      "nativePlatform": "ios",
      "nativeType": String(describing: type(of: error)),
    ]

    if let nativeStackFrames = bridgedStackFrames(from: error) {
      diagnostics["nativeStackFrames"] = nativeStackFrames
    }

    if let cause = error.cause {
      diagnostics["nativeCause"] = bridgedNativeCause(cause)
    }

    return diagnostics
  }

  private func bridgedNativeCause(_ cause: Error) -> [String: Any] {
    var nativeCause: [String: Any] = [
      "type": String(describing: type(of: cause)),
      "message": String(describing: cause),
    ]

    if let stackFrames = bridgedStackFrames(from: cause) {
      nativeCause["stackFrames"] = stackFrames
    }

    return nativeCause
  }

  private func bridgedStackFrames(from error: VCLError) -> [String]? {
    return limitedStackFrames(
      error.toDictionary()[Self.nativeStackFramesDictionaryKey] as? [String]
    )
  }

  private func bridgedStackFrames(from cause: Error) -> [String]? {
    guard let errorCause = cause as? VCLError else {
      return nil
    }

    return bridgedStackFrames(from: errorCause)
  }

  private func limitedStackFrames(_ stackFrames: [String]?) -> [String]? {
    guard nativeErrorStackFrameLimit > 0, let stackFrames else {
      return nil
    }

    let trimmedStackFrames = Array(stackFrames.prefix(nativeErrorStackFrameLimit))
    return trimmedStackFrames.isEmpty ? nil : trimmedStackFrames
  }

  private func updateBridgeConfigurations(
    _ initializationDescriptorDictionary: [String: Any]
  ) {
    let stackFrameLimit = initializationDescriptorDictionary["nativeErrorStackFrameLimit"] as? Int
    nativeErrorStackFrameLimit = Self.clampNativeErrorStackFrameLimit(stackFrameLimit)
  }

  private static func clampNativeErrorStackFrameLimit(_ stackFrameLimit: Int?) -> Int {
    guard let stackFrameLimit else {
      return defaultNativeErrorStackFrameLimit
    }

    return min(max(stackFrameLimit, 0), maxNativeErrorStackFrameLimit)
  }

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
    updateBridgeConfigurations(initializationDescriptorDictionary)
    let initializationDescriptor = dictionaryToInitializationDescriptor(initializationDescriptorDictionary)
    initGlobalConfigurations(initializationDescriptor)
    vcl.initialize(
      initializationDescriptor: initializationDescriptor,
      successHandler: {
        resolve("VCL initialization succeed!")
      },
      errorHandler: {
        self.rejectBridgedVCLError(reject, error: $0)
      })
  }

//  @objc(getCountries:withRejecter:)
  @objc public func getCountries(
    resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock
  ) {
    if let countries = vcl.countries {
      resolve(countriesToDictionary(countries))
    } else {
      rejectBridgedVCLError(reject, error: VCLError(message: "Countries not found"))
    }
  }

//  @objc(getCredentialTypeSchemas:withRejecter:)
  @objc public func getCredentialTypeSchemas(
    resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock
  ) {
    if let credentialTypeSchemas = vcl.credentialTypeSchemas {
      resolve(credentialTypeSchemasToDictionary(credentialTypeSchemas))
    } else {
      rejectBridgedVCLError(
        reject,
        error: VCLError(message: "Credential Type Schemas not found")
      )
    }
  }

//  @objc(getCredentialTypes:withRejecter:)
  @objc public func getCredentialTypes(
    resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock
  ) {
    if let credentialTypes = vcl.credentialTypes {
      resolve(credentialTypesToDictionary(credentialTypes))
    } else {
      rejectBridgedVCLError(reject, error: VCLError(message: "Credential Types not found"))
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
        self.rejectBridgedVCLError(reject, error: $0)
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
        self.rejectBridgedVCLError(reject, error: $0)
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
        self.rejectBridgedVCLError(reject, error: $0)
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
        self.rejectBridgedVCLError(reject, error: $0)
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
          self.rejectBridgedVCLError(reject, error: $0)
        })
    } else {
      rejectBridgedVCLError(
        reject,
        error: VCLError(
          message: "Unexpected Credential Credential Manifest Descriptor: \(credentialManifestDescriptorDictionary)"
        )
      )
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
        self.rejectBridgedVCLError(reject, error: $0)
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
        self.rejectBridgedVCLError(reject, error: $0)
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
        self.rejectBridgedVCLError(reject, error: $0)
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
        self.rejectBridgedVCLError(reject, error: $0)
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
        self.rejectBridgedVCLError(reject, error: $0)
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
        self.rejectBridgedVCLError(reject, error: $0)
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
        self.rejectBridgedVCLError(reject, error: $0)
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
        self.rejectBridgedVCLError(reject, error: $0)
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
        self.rejectBridgedVCLError(reject, error: $0)
      })
  }
}
