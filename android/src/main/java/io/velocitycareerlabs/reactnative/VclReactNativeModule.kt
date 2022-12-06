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
import io.velocitycareerlabs.reactnative.utlis.Converter.generatedOffersToMap
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
import io.velocitycareerlabs.reactnative.utlis.Converter.mapToPublicKey
import io.velocitycareerlabs.reactnative.utlis.Converter.mapToToken
import io.velocitycareerlabs.reactnative.utlis.Converter.mapToVerifiedProfileDescriptor
import io.velocitycareerlabs.reactnative.utlis.Converter.verifiedProfileToMap
import io.velocitycareerlabs.api.VCLProvider
import io.velocitycareerlabs.api.entities.VCLError
import io.velocitycareerlabs.reactnative.utlis.Converter.mapToInitializationDescriptor
import org.json.JSONObject
import java.lang.Exception

/**
 * Created by Michael Avoyan on 01/07/2021.
 */
class VclReactNativeModule(private val reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {

  companion object {
    const val ModuleName = "VclReactNative"
  }

  private val vcl = VCLProvider.vclInstance()

  override fun getName(): String {
    return ModuleName
  }

  @ReactMethod
  fun initialize(
    initializationDescriptor: ReadableMap,
    promise: Promise
  ) {
    try {
      vcl.initialize(
        initializationDescriptor = mapToInitializationDescriptor(
          reactContext,
          initializationDescriptor
        ),
        successHandler = {
          promise.resolve("VCL initialization succeed!")
        },
        errorHandler = {
          promise.reject(it)
        })
    } catch (ex: Exception) {
      promise.reject(VCLError(ex.message))
    }
  }

  @ReactMethod
  fun getCountries(promise: Promise) {
    try {
      vcl.countries?.let { promise.resolve(countriesToMap(it)) }
        ?: promise.reject(VCLError("Countries not found"))
    } catch (ex: Exception) {
      promise.reject(VCLError(ex.message))
    }
  }

  @ReactMethod
  fun getCredentialTypeSchemas(promise: Promise) {
    try {
      vcl.credentialTypeSchemas?.let { promise.resolve(credentialTypeSchemasToMap(it)) }
        ?: promise.reject(VCLError("Credential Types not found"))
    } catch (ex: Exception) {
      promise.reject(VCLError(ex.message))
    }
  }

  @ReactMethod
  fun getCredentialTypes(promise: Promise) {
    try {
      vcl.credentialTypes?.let { promise.resolve(credentialTypesToMap(it)) }
        ?: promise.reject(VCLError("Credential Types not found"))
    } catch (ex: Exception) {
      promise.reject(VCLError(ex.message))
    }
  }

  @ReactMethod
  fun getPresentationRequest(
    presentationRequestDescriptorReadableMap: ReadableMap,
    promise: Promise
  ) {
    try {
      vcl.getPresentationRequest(
        mapTopPresentationRequestDescriptor(presentationRequestDescriptorReadableMap),
        {
          promise.resolve(presentationRequestToMap(it))
        },
        {
          promise.reject(it)
        })
    } catch (ex: Exception) {
      promise.reject(VCLError(ex.message))
    }
  }

  @ReactMethod
  fun submitPresentation(
    presentationSubmissionReadableMap: ReadableMap,
    promise: Promise
  ) {
    try {
      vcl.submitPresentation(
        mapToPresentationSubmission(presentationSubmissionReadableMap),
        {
          promise.resolve(presentationSubmissionResultToMap(it))
        },
        {
          promise.reject(it)
        })
    } catch (ex: Exception) {
      promise.reject(VCLError(ex.message))
    }
  }

  @ReactMethod
  fun getExchangeProgress(
    exchangeDescriptorReadableMap: ReadableMap,
    promise: Promise
  ) {
    try {
      vcl.getExchangeProgress(mapToExchangeDescriptor(exchangeDescriptorReadableMap),
        {
          promise.resolve(exchangeToMap(it))
        },
        {
          promise.reject(it)
        })
    } catch (ex: Exception) {
      promise.reject(VCLError(ex.message))
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
          promise.reject(it)
        })
    } catch (ex: Exception) {
      promise.reject(VCLError(ex.message))
    }
  }

  @ReactMethod
  fun getCredentialManifest(
    credentialManifestDescriptorMap: ReadableMap,
    promise: Promise
  ) {
    try {
      mapToCredentialManifestDescriptor(credentialManifestDescriptorMap)?.let{ credentialManifestDescriptor ->
        vcl.getCredentialManifest(credentialManifestDescriptor,
          {
            promise.resolve(credentialManifestToMap(it))
          },
          {
            promise.reject(it)
          })
      } ?: promise.reject(VCLError("Unexpected Credential Credential Manifest Descriptor: $credentialManifestDescriptorMap"))
    } catch (ex: Exception) {
      promise.reject(VCLError(ex.message))
    }
  }

  @ReactMethod
  fun generateOffers(
    generateOffersDescriptorMap: ReadableMap,
    promise: Promise
  ) {
    try {
      vcl.generateOffers(
        mapToGenerateOffersDescriptor(generateOffersDescriptorMap),
        {
          promise.resolve(generatedOffersToMap(it))
        },
        {
          promise.reject(it)
        })
    } catch (ex: Exception) {
      promise.reject(VCLError(ex.message))
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
          promise.resolve(generatedOffersToMap(it))
        },
        {
          promise.reject(it)
        })
    } catch (ex: Exception) {
      promise.reject(VCLError(ex.message))
    }
  }

  @ReactMethod
  fun finalizeOffers(
    finalizeOffersDescriptorMap: ReadableMap,
    tokenMap: ReadableMap,
    promise: Promise
  ) {
    try {
      vcl.finalizeOffers(
        mapToFinalizedOffersDescriptor(finalizeOffersDescriptorMap),
        mapToToken(tokenMap),
        {
          promise.resolve(jwtVerifiableCredentialsToMap(it))
        },
        {
          promise.reject(it)
        })
    } catch (ex: Exception) {
      promise.reject(VCLError(ex.message))
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
          promise.reject(it)
        }
      )
    } catch (ex: Exception) {
      promise.reject(VCLError(ex.message))
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
          promise.reject(it)
        })
    } catch (ex: Exception) {
      promise.reject(VCLError(ex.message))
    }
  }

  @ReactMethod
  fun verifyJwt(
    jwtMap: ReadableMap,
    publicKeyMap: ReadableMap,
    promise: Promise
  ) {
    try {
      vcl.verifyJwt(mapToJwt(jwtMap), mapToPublicKey(publicKeyMap),
        {
          promise.resolve(it)
        },
        {
          promise.reject(it)
        })
    } catch (ex: Exception) {
      promise.reject(VCLError(ex.message))
    }
  }

  @ReactMethod
  fun generateSignedJwt(
    jwtJsonMap: ReadableMap,
    iss: String,
    jti: String,
    promise: Promise
  ) {
    var json: JSONObject? = null
    try {
      json = JSONObject(jwtJsonMap.toHashMap())
      vcl.generateSignedJwt(json, iss, jti,
        {
          promise.resolve(Converter.jwtToMap(it))
        },
        {
          promise.reject(it)
        })
    } catch (e: Exception) {
      promise.reject(VCLError(e.message))
    }
  }
}

