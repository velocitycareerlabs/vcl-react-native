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
import io.velocitycareerlabs.reactnative.utlis.Converter.mapToJwkPublic
import io.velocitycareerlabs.reactnative.utlis.Converter.mapToToken
import io.velocitycareerlabs.reactnative.utlis.Converter.mapToVerifiedProfileDescriptor
import io.velocitycareerlabs.reactnative.utlis.Converter.verifiedProfileToMap
import io.velocitycareerlabs.api.VCLProvider
import io.velocitycareerlabs.api.entities.VCLError
import io.velocitycareerlabs.api.entities.VCLInitializationDescriptor
import io.velocitycareerlabs.reactnative.extensions.toThrowable
import io.velocitycareerlabs.reactnative.utlis.Converter.didJwkToMap
import io.velocitycareerlabs.reactnative.utlis.Converter.mapToDidJwk
import io.velocitycareerlabs.reactnative.utlis.Converter.mapToInitializationDescriptor
import io.velocitycareerlabs.reactnative.utlis.Converter.mapToJwtDescriptor
import io.velocitycareerlabs.reactnative.utlis.VCLLog
import java.lang.Exception

/**
 * Created by Michael Avoyan on 01/07/2021.
 */
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
        mapTopPresentationRequestDescriptor(presentationRequestDescriptorMap),
        {
          promise.resolve(presentationRequestToMap(it))
        },
        {
          promise.reject(it.toThrowable())
        })
    } catch (ex: Exception) {
      promise.reject(VCLError(ex).toThrowable())
    }
  }

  @ReactMethod
  fun submitPresentation(
    presentationSubmissionMap: ReadableMap,
    didJwkMap: ReadableMap? = null,
    promise: Promise
  ) {
    try {
      vcl.submitPresentation(
        mapToPresentationSubmission(presentationSubmissionMap),
        mapToDidJwk(didJwkMap),
        {
          promise.resolve(presentationSubmissionResultToMap(it))
        },
        {
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
        VCLLog.d(TAG, "credentialManifestDescriptor VCL entity: ${credentialManifestDescriptor.toPropsString()}")
        vcl.getCredentialManifest(credentialManifestDescriptor,
          {
            promise.resolve(credentialManifestToMap(it))
          },
          {
            promise.reject(it.toThrowable())
          })
      }
        ?: promise.reject(VCLError("Unexpected Credential Credential Manifest Descriptor: $credentialManifestDescriptorMap").toThrowable())
    } catch (ex: Exception) {
      promise.reject(VCLError(ex).toThrowable())
    }
  }

  @ReactMethod
  fun generateOffers(
    generateOffersDescriptorMap: ReadableMap,
    didJwkMap: ReadableMap? = null,
    promise: Promise
  ) {
    try {
      vcl.generateOffers(
        mapToGenerateOffersDescriptor(generateOffersDescriptorMap),
        mapToDidJwk(didJwkMap),
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
  fun checkForOffers(
    generateOffersDescriptorMap: ReadableMap,
    tokenMap: ReadableMap,
    promise: Promise
  ) {
    try {
      vcl.checkForOffers(
        mapToGenerateOffersDescriptor(generateOffersDescriptorMap),
        mapToToken(tokenMap),
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
    didJwkMap: ReadableMap? = null,
    tokenMap: ReadableMap,
    promise: Promise
  ) {
    try {
      vcl.finalizeOffers(
        mapToFinalizedOffersDescriptor(finalizeOffersDescriptorMap),
        mapToDidJwk(didJwkMap),
        mapToToken(tokenMap),
        {
          promise.resolve(jwtVerifiableCredentialsToMap(it))
        },
        {
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
    jwkPublicMap: ReadableMap,
    promise: Promise
  ) {
    try {
      vcl.verifyJwt(mapToJwt(jwtMap), mapToJwkPublic(jwkPublicMap),
        {
          promise.resolve(it)
        },
        {
          promise.reject(it.toThrowable())
        })
    } catch (ex: Exception) {
      promise.reject(VCLError(ex).toThrowable())
    }
  }

  @ReactMethod
  fun generateSignedJwt(
    jwtDescriptorMap: ReadableMap,
    promise: Promise
  ) {
    try {
      vcl.generateSignedJwt(mapToJwtDescriptor(jwtDescriptorMap),
        {
          promise.resolve(Converter.jwtToMap(it))
        },
        {
          promise.reject(it.toThrowable())
        })
    } catch (ex: Exception) {
      promise.reject(VCLError(ex).toThrowable())
    }
  }

  @ReactMethod
  fun generateDidJwk(
    promise: Promise
  ) {
    try {
      vcl.generateDidJwk(
        {
          promise.resolve(didJwkToMap(it))
        },
        {
          promise.reject(it.toThrowable())
        })
    } catch (ex: Exception) {
      promise.reject(VCLError(ex).toThrowable())
    }
  }
}

