/**
 * Created by Michael Avoyan.
 *
 * Copyright 2022 Velocity Career Labs inc.
 * SPDX-License-Identifier: Apache-2.0
 */

package io.velocitycareerlabs.reactnative

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
import io.velocitycareerlabs.api.entities.VCLDidJwk
import io.velocitycareerlabs.api.entities.error.VCLError
import io.velocitycareerlabs.api.entities.initialization.VCLInitializationDescriptor
import io.velocitycareerlabs.reactnative.extensions.toThrowable
import io.velocitycareerlabs.reactnative.utlis.Converter.didJwkToMap
import io.velocitycareerlabs.reactnative.utlis.Converter.mapToDidJwk
import io.velocitycareerlabs.reactnative.utlis.Converter.mapToDidJwkDescriptor
import io.velocitycareerlabs.reactnative.utlis.Converter.mapToInitializationDescriptor
import io.velocitycareerlabs.reactnative.utlis.Converter.mapToJwtDescriptor
import io.velocitycareerlabs.reactnative.utlis.VCLLog
import kotlin.Exception

class VclReactNativeModule(private val reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {

  val TAG = "VclReactNativeModule"

  companion object {
    const val ModuleName = "VclReactNative"
  }

  private val vcl = VCLProvider.vclInstance()

  override fun getName(): String {
    return ModuleName
  }

  private fun initGlobalConfigurations(
    initializationDescriptor: VCLInitializationDescriptor
  ) {
    GlobalConfig.CurrentEnvironment = initializationDescriptor.environment
    GlobalConfig.IsDebugOn = initializationDescriptor.isDebugOn
  }

  @ReactMethod
  fun initialize(
    initializationDescriptorMap: ReadableMap,
    promise: Promise
  ) {
    try {
      val initializationDescriptor = mapToInitializationDescriptor(
        initializationDescriptorMap
      )
      initGlobalConfigurations(initializationDescriptor)
      vcl.initialize(
        context = reactContext.applicationContext,
        initializationDescriptor = initializationDescriptor,
        successHandler = {
          promise.resolve("VCL initialization succeed!")
        },
        errorHandler = {
          promise.reject(it.toThrowable())
        })
    } catch (ex: Exception) {
      promise.reject(VCLError(ex).toThrowable())
    }
  }

  @ReactMethod
  fun getCountries(promise: Promise) {
    try {
      vcl.countries?.let { promise.resolve(countriesToMap(it)) }
        ?: promise.reject(VCLError(message = "Countries not found").toThrowable())
    } catch (ex: Exception) {
      promise.reject(VCLError(ex).toThrowable())
    }
  }

  @ReactMethod
  fun getCredentialTypeSchemas(promise: Promise) {
    try {
      vcl.credentialTypeSchemas?.let { promise.resolve(credentialTypeSchemasToMap(it)) }
        ?: promise.reject(VCLError(message = "Credential Types not found").toThrowable())
    } catch (ex: Exception) {
      promise.reject(VCLError(ex).toThrowable())
    }
  }

  @ReactMethod
  fun getCredentialTypes(promise: Promise) {
    try {
      vcl.credentialTypes?.let { promise.resolve(credentialTypesToMap(it)) }
        ?: promise.reject(VCLError(message = "Credential Types not found").toThrowable())
    } catch (ex: Exception) {
      promise.reject(VCLError(ex).toThrowable())
    }
  }

  @ReactMethod
  fun getPresentationRequest(
    presentationRequestDescriptorMap: ReadableMap,
    promise: Promise
  ) {
    try {
      vcl.getPresentationRequest(
        presentationRequestDescriptor = mapTopPresentationRequestDescriptor(presentationRequestDescriptorMap),
        successHandler = {
          promise.resolve(presentationRequestToMap(it))
        },
        errorHandler = {
          promise.reject(it.toThrowable())
        })
    } catch (ex: Exception) {
      promise.reject(VCLError(ex).toThrowable())
    }
  }

  @ReactMethod
  fun submitPresentation(
    presentationSubmissionMap: ReadableMap,
    promise: Promise
  ) {
    try {
      vcl.submitPresentation(
        presentationSubmission = mapToPresentationSubmission(presentationSubmissionMap),
        successHandler = {
          promise.resolve(presentationSubmissionResultToMap(it))
        },
        errorHandler = {
          promise.reject(it.toThrowable())
        })
    } catch (ex: Exception) {
      promise.reject(VCLError(ex).toThrowable())
    }
  }

  @ReactMethod
  fun getExchangeProgress(
    exchangeDescriptorMap: ReadableMap,
    promise: Promise
  ) {
    try {
      vcl.getExchangeProgress(mapToExchangeDescriptor(exchangeDescriptorMap),
        {
          promise.resolve(exchangeToMap(it))
        },
        {
          promise.reject(it.toThrowable())
        })
    } catch (ex: Exception) {
      promise.reject(VCLError(ex).toThrowable())
    }
  }

  @ReactMethod
  fun searchForOrganizations(
    organizationsSearchDescriptorMap: ReadableMap,
    promise: Promise
  ) {
    try {
      vcl.searchForOrganizations(
        mapToOrganizationsSearchDescriptor(organizationsSearchDescriptorMap),
        {
          promise.resolve(organizationsToMap(it))
        },
        {
          promise.reject(it.toThrowable())
        })
    } catch (ex: Exception) {
      promise.reject(VCLError(ex).toThrowable())
    }
  }

  @ReactMethod
  fun getCredentialManifest(
    credentialManifestDescriptorMap: ReadableMap,
    promise: Promise
  ) {
    try {
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
            promise.reject(it.toThrowable())
          })
      } ?: run {
        promise.reject(VCLError("Unexpected Credential Credential Manifest Descriptor: $credentialManifestDescriptorMap").toThrowable())
      }
    } catch (ex: Exception) {
      promise.reject(VCLError(ex).toThrowable())
    }
  }

  @ReactMethod
  fun generateOffers(
    generateOffersDescriptorMap: ReadableMap,
    promise: Promise
  ) {
    try {
      vcl.generateOffers(
        generateOffersDescriptor = mapToGenerateOffersDescriptor(generateOffersDescriptorMap),
        successHandler = {
          promise.resolve(offersToMap(it))
        },
        errorHandler = {
          promise.reject(it.toThrowable())
        })
    } catch (ex: Exception) {
      promise.reject(VCLError(ex).toThrowable())
    }
  }

  @ReactMethod
  fun checkForOffers(
    generateOffersDescriptorMap: ReadableMap,
    sessionTokenMap: ReadableMap,
    promise: Promise
  ) {
    try {
      vcl.checkForOffers(
        mapToGenerateOffersDescriptor(generateOffersDescriptorMap),
        mapToToken(sessionTokenMap),
        {
          promise.resolve(offersToMap(it))
        },
        {
          promise.reject(it.toThrowable())
        })
    } catch (ex: Exception) {
      promise.reject(VCLError(ex).toThrowable())
    }
  }

  @ReactMethod
  fun finalizeOffers(
    finalizeOffersDescriptorMap: ReadableMap,
    sessionTokenMap: ReadableMap,
    promise: Promise
  ) {
    try {
      vcl.finalizeOffers(
        finalizeOffersDescriptor = mapToFinalizedOffersDescriptor(finalizeOffersDescriptorMap),
        sessionToken = mapToToken(sessionTokenMap),
        successHandler = {
          promise.resolve(jwtVerifiableCredentialsToMap(it))
        },
        errorHandler = {
          promise.reject(it.toThrowable())
        })
    } catch (ex: Exception) {
      promise.reject(VCLError(ex).toThrowable())
    }
  }

  @ReactMethod
  fun getCredentialTypesUIFormSchema(
    credentialTypesUIFormSchemaDescriptorMap: ReadableMap,
    promise: Promise
  ) {
    try {
      vcl.getCredentialTypesUIFormSchema(
        mapToCredentialTypesUIFormSchemaDescriptor(credentialTypesUIFormSchemaDescriptorMap),
        {
          promise.resolve(credentialTypesFormSchemaToMap(it))
        },
        {
          promise.reject(it.toThrowable())
        }
      )
    } catch (ex: Exception) {
      promise.reject(VCLError(ex).toThrowable())
    }
  }

  @ReactMethod
  fun getVerifiedProfile(
    verifiedProfileDescriptorMap: ReadableMap,
    promise: Promise
  ) {
    try {
      vcl.getVerifiedProfile(mapToVerifiedProfileDescriptor(verifiedProfileDescriptorMap),
        {
          promise.resolve(verifiedProfileToMap(it))
        },
        {
          promise.reject(it.toThrowable())
        })
    } catch (ex: Exception) {
      promise.reject(VCLError(ex).toThrowable())
    }
  }

  @ReactMethod
  fun verifyJwt(
    jwtMap: ReadableMap,
    publicJwkMap: ReadableMap,
    remoteCryptoServicesTokenMap: ReadableMap? = null,
    promise: Promise
  ) {
    try {
      vcl.verifyJwt(
        jwt = mapToJwt(jwtMap),
        publicJwk = mapToPublicJwk(publicJwkMap),
        remoteCryptoServicesToken = mapToToken(remoteCryptoServicesTokenMap),
        successHandler = {
          promise.resolve(it)
        },
        errorHandler = {
          promise.reject(it.toThrowable())
        })
    } catch (ex: Exception) {
      promise.reject(VCLError(ex).toThrowable())
    }
  }

  @ReactMethod
  fun generateSignedJwt(
    jwtDescriptorMap: ReadableMap,
    didJwkMap: ReadableMap,
    remoteCryptoServicesTokenMap: ReadableMap? = null,
    promise: Promise
  ) {
    try {
      vcl.generateSignedJwt(
        jwtDescriptor = mapToJwtDescriptor(jwtDescriptorMap),
        didJwk = mapToDidJwk(didJwkMap),
        remoteCryptoServicesToken = mapToToken(remoteCryptoServicesTokenMap),
        successHandler = {
          promise.resolve(Converter.jwtToMap(it))
        },
        errorHandler = {
          promise.reject(it.toThrowable())
        })
    } catch (ex: Exception) {
      promise.reject(VCLError(ex).toThrowable())
    }
  }

  @ReactMethod
  fun generateDidJwk(
    didJwkDescriptorMap: ReadableMap? = null,
    promise: Promise
  ) {
    try {
      vcl.generateDidJwk(
        didJwkDescriptor = mapToDidJwkDescriptor(didJwkDescriptorMap),
        successHandler = {
          promise.resolve(didJwkToMap(it))
        },
        errorHandler = {
          promise.reject(it.toThrowable())
        })
    } catch (ex: Exception) {
      promise.reject(VCLError(ex).toThrowable())
    }
  }
}

