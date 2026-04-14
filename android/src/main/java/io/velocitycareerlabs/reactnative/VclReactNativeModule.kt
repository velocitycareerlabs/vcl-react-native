/**
 * Created by Michael Avoyan.
 *
 * Copyright 2022 Velocity Career Labs inc.
 * SPDX-License-Identifier: Apache-2.0
 */

package io.velocitycareerlabs.reactnative

import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.module.annotations.ReactModule
import com.facebook.react.bridge.*
import io.velocitycareerlabs.reactnative.utlis.Converter
import io.velocitycareerlabs.reactnative.utlis.Converter.countriesToMap
import io.velocitycareerlabs.reactnative.utlis.Converter.credentialManifestToMap
import io.velocitycareerlabs.reactnative.utlis.Converter.credentialTypeSchemasToMap
import io.velocitycareerlabs.reactnative.utlis.Converter.credentialTypesFormSchemaToMap
import io.velocitycareerlabs.reactnative.utlis.Converter.credentialTypesToMap
import io.velocitycareerlabs.reactnative.utlis.Converter.exchangeToMap
import io.velocitycareerlabs.reactnative.utlis.Converter.jwtVerifiableCredentialsToMap
import io.velocitycareerlabs.reactnative.utlis.Converter.offersToMap
import io.velocitycareerlabs.reactnative.utlis.Converter.mapToCredentialManifestDescriptor
import io.velocitycareerlabs.reactnative.utlis.Converter.organizationsToMap
import io.velocitycareerlabs.reactnative.utlis.Converter.mapToPresentationSubmission
import io.velocitycareerlabs.reactnative.utlis.Converter.presentationRequestToMap
import io.velocitycareerlabs.reactnative.utlis.Converter.presentationSubmissionResultToMap
import io.velocitycareerlabs.reactnative.utlis.Converter.mapToCredentialTypesUIFormSchemaDescriptor
import io.velocitycareerlabs.reactnative.utlis.Converter.mapTopPresentationRequestDescriptor
import io.velocitycareerlabs.reactnative.utlis.Converter.mapToExchangeDescriptor
import io.velocitycareerlabs.reactnative.utlis.Converter.mapToFinalizedOffersDescriptor
import io.velocitycareerlabs.reactnative.utlis.Converter.mapToGenerateOffersDescriptor
import io.velocitycareerlabs.reactnative.utlis.Converter.mapToJwt
import io.velocitycareerlabs.reactnative.utlis.Converter.mapToOrganizationsSearchDescriptor
import io.velocitycareerlabs.reactnative.utlis.Converter.mapToPublicJwk
import io.velocitycareerlabs.reactnative.utlis.Converter.mapToToken
import io.velocitycareerlabs.reactnative.utlis.Converter.mapToVerifiedProfileDescriptor
import io.velocitycareerlabs.reactnative.utlis.Converter.verifiedProfileToMap
import io.velocitycareerlabs.api.VCLProvider
import io.velocitycareerlabs.api.entities.error.VCLError
import io.velocitycareerlabs.api.entities.initialization.VCLInitializationDescriptor
import io.velocitycareerlabs.reactnative.extensions.VCLErrorBridgeConfig
import io.velocitycareerlabs.reactnative.extensions.getIntOpt
import io.velocitycareerlabs.reactnative.extensions.rejectBridgedVCLError
import io.velocitycareerlabs.reactnative.utlis.Converter.authTokenToMap
import io.velocitycareerlabs.reactnative.utlis.Converter.didJwkToMap
import io.velocitycareerlabs.reactnative.utlis.Converter.mapToAuthToken
import io.velocitycareerlabs.reactnative.utlis.Converter.mapToAuthTokenDescriptor
import io.velocitycareerlabs.reactnative.utlis.Converter.mapToDidJwk
import io.velocitycareerlabs.reactnative.utlis.Converter.mapToDidJwkDescriptor
import io.velocitycareerlabs.reactnative.utlis.Converter.mapToInitializationDescriptor
import io.velocitycareerlabs.reactnative.utlis.Converter.mapToJwtDescriptor
import io.velocitycareerlabs.reactnative.utlis.VCLLog
import kotlin.Exception

@ReactModule(name = VclReactNativeModule.NAME)
class VclReactNativeModule(val reactContext: ReactApplicationContext) :
  NativeVclReactNativeSpec(reactContext) {

  companion object {
    const val NAME = "VclReactNative"
    const val TAG = NAME
  }

  override fun getName(): String {
    return NAME
  }

  private val vcl = VCLProvider.vclInstance()

  private fun initGlobalConfigurations(
    initializationDescriptor: VCLInitializationDescriptor
  ) {
    GlobalConfig.CurrentEnvironment = initializationDescriptor.environment
    GlobalConfig.IsDebugOn = initializationDescriptor.isDebugOn
  }

  private inline fun withBridgedLocalExceptions(
    promise: Promise,
    block: () -> Unit
  ) {
    try {
      block()
    } catch (ex: Exception) {
      promise.rejectBridgedVCLError(VCLError(ex))
    }
  }

  override fun initialize(
    initializationDescriptorMap: ReadableMap,
    promise: Promise
  ) {
    withBridgedLocalExceptions(promise) {
      VCLErrorBridgeConfig.updateNativeErrorStackFrameLimit(
        initializationDescriptorMap.getIntOpt("nativeErrorStackFrameLimit")
      )
      val initializationDescriptor = mapToInitializationDescriptor(
        initializationDescriptorMap
      )
      initGlobalConfigurations(initializationDescriptor)
      vcl.initialize(
        context = reactContext,
        initializationDescriptor = initializationDescriptor,
        successHandler = {
          promise.resolve("VCL initialization succeed!")
        },
        errorHandler = {
          promise.rejectBridgedVCLError(it)
        })
    }
  }

  override fun getCountries(promise: Promise) {
    withBridgedLocalExceptions(promise) {
      vcl.countries?.let { promise.resolve(countriesToMap(it)) }
        ?: promise.rejectBridgedVCLError(VCLError(message = "Countries not found"))
    }
  }

  override fun getCredentialTypeSchemas(promise: Promise) {
    withBridgedLocalExceptions(promise) {
      vcl.credentialTypeSchemas?.let { promise.resolve(credentialTypeSchemasToMap(it)) }
        ?: promise.rejectBridgedVCLError(VCLError(message = "Credential Type Schemas not found"))
    }
  }

  override fun getCredentialTypes(promise: Promise) {
    withBridgedLocalExceptions(promise) {
      vcl.credentialTypes?.let { promise.resolve(credentialTypesToMap(it)) }
        ?: promise.rejectBridgedVCLError(VCLError(message = "Credential Types not found"))
    }
  }

  override fun getPresentationRequest(
    presentationRequestDescriptorMap: ReadableMap,
    promise: Promise
  ) {
    withBridgedLocalExceptions(promise) {
      vcl.getPresentationRequest(
        presentationRequestDescriptor = mapTopPresentationRequestDescriptor(
          presentationRequestDescriptorMap
        ),
        successHandler = {
          promise.resolve(presentationRequestToMap(it))
        },
        errorHandler = {
          promise.rejectBridgedVCLError(it)
        })
    }
  }

  override fun submitPresentation(
    presentationSubmissionMap: ReadableMap,
    authTokenMap: ReadableMap?,
    promise: Promise
  ) {
    withBridgedLocalExceptions(promise) {
      vcl.submitPresentation(
        presentationSubmission = mapToPresentationSubmission(presentationSubmissionMap),
        authToken = mapToAuthToken(authTokenMap),
        successHandler = {
          promise.resolve(presentationSubmissionResultToMap(it))
        },
        errorHandler = {
          promise.rejectBridgedVCLError(it)
        })
    }
  }

  override fun getExchangeProgress(
    exchangeDescriptorMap: ReadableMap,
    promise: Promise
  ) {
    withBridgedLocalExceptions(promise) {
      vcl.getExchangeProgress(mapToExchangeDescriptor(exchangeDescriptorMap),
        {
          promise.resolve(exchangeToMap(it))
        },
        {
          promise.rejectBridgedVCLError(it)
        })
    }
  }

  override fun searchForOrganizations(
    organizationsSearchDescriptorMap: ReadableMap,
    promise: Promise
  ) {
    withBridgedLocalExceptions(promise) {
      vcl.searchForOrganizations(
        mapToOrganizationsSearchDescriptor(organizationsSearchDescriptorMap),
        {
          promise.resolve(organizationsToMap(it))
        },
        {
          promise.rejectBridgedVCLError(it)
        })
    }
  }

  override fun getCredentialManifest(
    credentialManifestDescriptorMap: ReadableMap,
    promise: Promise
  ) {
    withBridgedLocalExceptions(promise) {
      VCLLog.d(TAG, "credentialManifestDescriptorMap map: $credentialManifestDescriptorMap")
      mapToCredentialManifestDescriptor(credentialManifestDescriptorMap)?.let { credentialManifestDescriptor ->
        VCLLog.d(
          TAG,
          "credentialManifestDescriptor VCL entity: ${credentialManifestDescriptor.toPropsString()}"
        )
        vcl.getCredentialManifest(
          credentialManifestDescriptor,
          successHandler = {
            promise.resolve(credentialManifestToMap(it))
          },
          errorHandler = {
            promise.rejectBridgedVCLError(it)
          })
      } ?: run {
        promise.rejectBridgedVCLError(
          VCLError(
            message = "Unexpected Credential Manifest Descriptor"
          )
        )
      }
    }
  }

  override fun generateOffers(
    generateOffersDescriptorMap: ReadableMap,
    promise: Promise
  ) {
    withBridgedLocalExceptions(promise) {
      vcl.generateOffers(
        generateOffersDescriptor = mapToGenerateOffersDescriptor(generateOffersDescriptorMap),
        successHandler = {
          promise.resolve(offersToMap(it))
        },
        errorHandler = {
          promise.rejectBridgedVCLError(it)
        })
    }
  }

  override fun checkForOffers(
    generateOffersDescriptorMap: ReadableMap,
    sessionTokenMap: ReadableMap,
    promise: Promise
  ) {
    withBridgedLocalExceptions(promise) {
      vcl.checkForOffers(
        mapToGenerateOffersDescriptor(generateOffersDescriptorMap),
        mapToToken(sessionTokenMap),
        {
          promise.resolve(offersToMap(it))
        },
        {
          promise.rejectBridgedVCLError(it)
        })
    }
  }

  override fun finalizeOffers(
    finalizeOffersDescriptorMap: ReadableMap,
    sessionTokenMap: ReadableMap,
    promise: Promise
  ) {
    withBridgedLocalExceptions(promise) {
      vcl.finalizeOffers(
        finalizeOffersDescriptor = mapToFinalizedOffersDescriptor(finalizeOffersDescriptorMap),
        sessionToken = mapToToken(sessionTokenMap),
        successHandler = {
          promise.resolve(jwtVerifiableCredentialsToMap(it))
        },
        errorHandler = {
          promise.rejectBridgedVCLError(it)
        })
    }
  }

  override fun getAuthToken(
    authTokenDescriptorMap: ReadableMap,
    promise: Promise
  ) {
    withBridgedLocalExceptions(promise) {
      vcl.getAuthToken(
        authTokenDescriptor = mapToAuthTokenDescriptor(authTokenDescriptorMap),
        successHandler = {
          promise.resolve(authTokenToMap(it))
        },
        errorHandler = {
          promise.rejectBridgedVCLError(it)
        })
    }
  }

  override fun getCredentialTypesUIFormSchema(
    credentialTypesUIFormSchemaDescriptorMap: ReadableMap,
    promise: Promise
  ) {
    withBridgedLocalExceptions(promise) {
      vcl.getCredentialTypesUIFormSchema(
        mapToCredentialTypesUIFormSchemaDescriptor(credentialTypesUIFormSchemaDescriptorMap),
        {
          promise.resolve(credentialTypesFormSchemaToMap(it))
        },
        {
          promise.rejectBridgedVCLError(it)
        }
      )
    }
  }

  override fun getVerifiedProfile(
    verifiedProfileDescriptorMap: ReadableMap,
    promise: Promise
  ) {
    withBridgedLocalExceptions(promise) {
      vcl.getVerifiedProfile(mapToVerifiedProfileDescriptor(verifiedProfileDescriptorMap),
        {
          promise.resolve(verifiedProfileToMap(it))
        },
        {
          promise.rejectBridgedVCLError(it)
        })
    }
  }

  override fun verifyJwt(
    jwtMap: ReadableMap,
    publicJwkMap: ReadableMap,
    remoteCryptoServicesTokenMap: ReadableMap?,
    promise: Promise
  ) {
    withBridgedLocalExceptions(promise) {
      vcl.verifyJwt(
        jwt = mapToJwt(jwtMap),
        publicJwk = mapToPublicJwk(publicJwkMap),
        remoteCryptoServicesToken = mapToToken(remoteCryptoServicesTokenMap),
        successHandler = {
          promise.resolve(it)
        },
        errorHandler = {
          promise.rejectBridgedVCLError(it)
        })
    }
  }

  override fun generateSignedJwt(
    jwtDescriptorMap: ReadableMap,
    didJwkMap: ReadableMap,
    remoteCryptoServicesTokenMap: ReadableMap?,
    promise: Promise
  ) {
    withBridgedLocalExceptions(promise) {
      vcl.generateSignedJwt(
        jwtDescriptor = mapToJwtDescriptor(jwtDescriptorMap),
        didJwk = mapToDidJwk(didJwkMap),
        remoteCryptoServicesToken = mapToToken(remoteCryptoServicesTokenMap),
        successHandler = {
          promise.resolve(Converter.jwtToMap(it))
        },
        errorHandler = {
          promise.rejectBridgedVCLError(it)
        })
    }
  }

  override fun generateDidJwk(
    didJwkDescriptorMap: ReadableMap?,
    promise: Promise
  ) {
    withBridgedLocalExceptions(promise) {
      vcl.generateDidJwk(
        didJwkDescriptor = mapToDidJwkDescriptor(didJwkDescriptorMap),
        successHandler = {
          promise.resolve(didJwkToMap(it))
        },
        errorHandler = {
          promise.rejectBridgedVCLError(it)
        })
    }
  }
}
