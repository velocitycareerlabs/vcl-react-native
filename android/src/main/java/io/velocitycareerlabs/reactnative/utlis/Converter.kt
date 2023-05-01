/**
 * Created by Michael Avoyan.
 *
 * Copyright 2022 Velocity Career Labs inc.
 * SPDX-License-Identifier: Apache-2.0
 */

 package io.velocitycareerlabs.reactnative.utlis

import com.facebook.react.bridge.*
import io.velocitycareerlabs.api.*
import io.velocitycareerlabs.api.entities.*
import io.velocitycareerlabs.reactnative.extensions.*
import org.json.JSONObject
import java.lang.Exception

/**
 * Created by Michael Avoyan on 04/07/2021.
 */
object Converter {

  fun mapToInitializationDescriptor(
    reactContext: ReactApplicationContext,
    initializationDescriptorMap: ReadableMap
  ) =
    VCLInitializationDescriptor(
      context = reactContext,
      environment = mapToEnvironment(
        initializationDescriptorMap.getMapOpt("environment")
          ?: mapOf(Pair("value", VCLEnvironment.PROD.value)).toReadableMap()
      ),
      cacheSequence = initializationDescriptorMap.getIntOpt("cacheSequence") ?: 0
    )

  fun mapToEnvironment(environmentMap: ReadableMap) =
    when (environmentMap.getStringOpt("value")) {
      VCLEnvironment.DEV.value -> VCLEnvironment.DEV
      VCLEnvironment.QA.value -> VCLEnvironment.QA
      VCLEnvironment.STAGING.value -> VCLEnvironment.STAGING
      VCLEnvironment.PROD.value -> VCLEnvironment.PROD
      else -> VCLEnvironment.PROD
    }

  fun regionToMap(
    region: VCLRegion
  ): ReadableMap {
    val regionMap = Arguments.createMap()
    regionMap.putMap("payload", region.payload.toReadableMap())
    regionMap.putString("code", region.code)
    regionMap.putString("name", region.name)
    return regionMap
  }

  fun regionsToMap(
    regions: VCLRegions
  ): ReadableMap {
    val regionsMap = Arguments.createMap()
    val regionsArr = Arguments.createArray()
    for (i in regions.all.indices) {
      regionsArr.pushMap(regionToMap(regions.all[i]))
    }
    regionsMap.putArray("all", regionsArr)
    return regionsMap
  }

  fun countryToMap(
    country: VCLCountry
  ): ReadableMap {
    val countryMap = Arguments.createMap()
    countryMap.putMap("payload", country.payload.toReadableMap())
    countryMap.putString("code", country.code)
    countryMap.putString("name", country.name)
    country.regions?.let { countryMap.putMap("regions", regionsToMap(it)) }
    return countryMap
  }

  fun countriesToMap(
    countries: VCLCountries
  ): ReadableMap {
    val countriesMap = Arguments.createMap()
    val countriesArr = Arguments.createArray()
    countries.all?.let { all ->
      for (i in all.indices) {
        countriesArr.pushMap(countryToMap(all[i]))
      }
    }
    countriesMap.putArray("all", countriesArr)
    return countriesMap
  }

  fun credentialTypeSchemasToMap(
    credentialTypeSchemas: VCLCredentialTypeSchemas
  ): ReadableMap {
    val credentialTypeSchemasMap = Arguments.createMap()
    for ((key, credentialTypeSchema) in credentialTypeSchemas.all) {
      val credentialTypeSchemaMap = Arguments.createMap()
      credentialTypeSchemaMap.putMap("payload", credentialTypeSchema.payload.toReadableMap());
      credentialTypeSchemasMap.putMap(key, credentialTypeSchemaMap)
    }
    val retVal = Arguments.createMap()
    retVal.putMap("all", credentialTypeSchemasMap)
    return retVal
  }

  fun credentialTypesToMap(credentialTypes: VCLCredentialTypes): ReadableMap {
    var credentialTypesArray = Arguments.createArray()
    credentialTypes.all?.let {
      credentialTypesArray = parseCredentialTypesArray(it)
    }
    var recommendedCredentialTypesArray = Arguments.createArray()
    credentialTypes.recommendedTypes?.let {
      recommendedCredentialTypesArray = parseCredentialTypesArray(it)
    }
    val retVal = Arguments.createMap()
    retVal.putArray("all", credentialTypesArray)
    retVal.putArray("recommendedTypes", recommendedCredentialTypesArray)
    return retVal
  }

  private fun parseCredentialTypesArray(credentialTypesArr: List<VCLCredentialType>): WritableArray {
    val credentialTypesArray = Arguments.createArray()
    credentialTypesArr.forEach {
      val credentialType = Arguments.createMap()
      credentialType.putMap("payload", it.payload.toReadableMap())
      credentialType.putString("id", it.id)
      credentialType.putString("schema", it.schema)
      credentialType.putString("createdAt", it.createdAt)
      credentialType.putString("schemaName", it.schemaName)
      credentialType.putString("credentialType", it.credentialType)
      credentialType.putBoolean("recommended", it.recommended)
      credentialTypesArray.pushMap(credentialType)
    }
    return credentialTypesArray
  }

  fun mapTopPresentationRequestDescriptor(presentationRequestDescriptorLinkMap: ReadableMap) =
    VCLPresentationRequestDescriptor(
      deepLink = mapToDeepLink(presentationRequestDescriptorLinkMap.getMapOpt("deepLink")),
      pushDelegate = mapToPushDelegate(presentationRequestDescriptorLinkMap.getMapOpt("pushDelegate"))
    )

  fun mapToDeepLink(deepLinkMap: ReadableMap?) =
    VCLDeepLink(deepLinkMap?.getStringOpt("value") ?: "")

  fun deepLinkToMap(deepLink: VCLDeepLink): ReadableMap {
    val retVal = Arguments.createMap()
    retVal.putString("value", deepLink.value)
    return retVal
  }

  fun mapToIssuingType(
    issuingTypeMap: ReadableMap,
    defaultIssuingType: VCLIssuingType
  ) =
    issuingTypeMap.getStringOpt("issuingType")?.let { issuingType ->
      VCLIssuingType.fromString(issuingType)
    } ?: defaultIssuingType

  fun mapToToken(tokenMap: ReadableMap?) =
    VCLToken(tokenMap?.getStringOpt("value") ?: "")

  fun tokenToMap(token: VCLToken): ReadableMap {
    val retVal = Arguments.createMap()
    retVal.putString("value", token.value)
    return retVal
  }

  fun mapToPresentationRequest(
    presentationRequestMap: ReadableMap?
  ) = VCLPresentationRequest(
    mapToJwt(presentationRequestMap?.getMapOpt("jwt")),
    mapToJwkPublic(presentationRequestMap?.getMapOpt("jwkPublic")),
    mapToDeepLink(presentationRequestMap?.getMapOpt("deepLink"))
  )

  fun presentationRequestToMap(
    presentationRequest: VCLPresentationRequest
  ): ReadableMap {
    val presentationRequestMap = Arguments.createMap()
    val jwtMap = Arguments.createMap()
    jwtMap.putString("encodedJwt", presentationRequest.jwt.signedJwt.serialize())
    presentationRequestMap.putMap("jwt", jwtMap)
    val jwkMap = Arguments.createMap()
    jwkMap.putString("valueStr", presentationRequest.jwkPublic.valueStr)
    presentationRequestMap.putMap("jwkPublic", jwkMap)
    presentationRequestMap.putString("iss", presentationRequest.iss)
    presentationRequestMap.putString("exchangeId", presentationRequest.exchangeId)
    presentationRequestMap.putString(
      "presentationDefinitionId",
      presentationRequest.presentationDefinitionId
    )
    presentationRequestMap.putMap("deepLink", deepLinkToMap(presentationRequest.deepLink))
    return presentationRequestMap
  }

  fun mapToPresentationSubmission(
    presentationSubmissionMap: ReadableMap?
  ): VCLPresentationSubmission {
    val verifiableCredentialsReadableArr =
      presentationSubmissionMap?.getArrayOpt("verifiableCredentials")
    val verifiableCredentialsList = mutableListOf<VCLVerifiableCredential>()
    verifiableCredentialsReadableArr?.let { verifiableCredentials ->
      for (i in 0 until verifiableCredentials.size()) {
        val verifiableCredential = verifiableCredentials.getMapOpt(i)
        verifiableCredentialsList.add(
          VCLVerifiableCredential(
            inputDescriptor = verifiableCredential?.getStringOpt("inputDescriptor") ?: "",
            jwtVc = verifiableCredential?.getStringOpt("jwtVc") ?: ""
          )
        )
      }
    }
    return VCLPresentationSubmission(
      presentationRequest = mapToPresentationRequest(presentationSubmissionMap?.getMapOpt("presentationRequest")),
      verifiableCredentials = verifiableCredentialsList
    )
  }

  fun presentationSubmissionResultToMap(
    presentationSubmissionResult: VCLSubmissionResult
  ): ReadableMap {
    val presentationSubmissionResultMap = Arguments.createMap()
    presentationSubmissionResultMap.putMap(
      VCLSubmissionResult.KeyToken, tokenToMap(presentationSubmissionResult.token)
    )
    presentationSubmissionResultMap.putMap(
      VCLSubmissionResult.KeyExchange,
      exchangeToMap(presentationSubmissionResult.exchange)
    )
    presentationSubmissionResultMap.putString(
      VCLSubmissionResult.KeyJti, presentationSubmissionResult.jti
    )
    presentationSubmissionResultMap.putString(
      VCLSubmissionResult.KeySubmissionId, presentationSubmissionResult.submissionId
    )
    return presentationSubmissionResultMap
  }

  fun exchangeToMap(
    exchange: VCLExchange
  ): ReadableMap {
    val exchangeMap = Arguments.createMap()
    exchangeMap.putString("id", exchange.id)
    exchangeMap.putString("type", exchange.type)
    exchangeMap.putBoolean("disclosureComplete", exchange.disclosureComplete)
    exchangeMap.putBoolean("exchangeComplete", exchange.exchangeComplete)
    return exchangeMap
  }

  fun mapToSubmissionResult(
    submissionResultMap: ReadableMap?
  ) = VCLSubmissionResult(
    token = mapToToken(submissionResultMap?.getMapOpt(VCLSubmissionResult.KeyToken)),
    exchange = mapToExchange(submissionResultMap?.getMapOpt(VCLSubmissionResult.KeyExchange)),
    jti = submissionResultMap?.getStringOpt(VCLSubmissionResult.KeyJti) ?: "",
    submissionId = submissionResultMap?.getStringOpt(VCLSubmissionResult.KeySubmissionId) ?: "",
  )

  fun mapToExchange(
    exchangeMap: ReadableMap?
  ) = VCLExchange(
    id = exchangeMap?.getStringOpt("id") ?: "",
    type = exchangeMap?.getStringOpt("type") ?: "",
    disclosureComplete = exchangeMap?.getBooleanOpt("disclosureComplete") ?: false,
    exchangeComplete = exchangeMap?.getBooleanOpt("exchangeComplete") ?: false
  )

  fun mapToExchangeDescriptor(exchangeDescriptorMap: ReadableMap) =
    VCLExchangeDescriptor(
      mapToPresentationSubmission(exchangeDescriptorMap.getMapOpt("presentationSubmission")),
      mapToSubmissionResult(exchangeDescriptorMap.getMapOpt("submissionResult"))
    )

  fun mapToOrganizationsSearchDescriptor(
    organizationsDescriptorMap: ReadableMap
  ) = VCLOrganizationsSearchDescriptor(
    filter = mapToFilter(organizationsDescriptorMap.getMapOpt("filter")),
    page = mapToPage(organizationsDescriptorMap.getMapOpt("page")),
    sort = readableArrayToList(organizationsDescriptorMap.getArrayOpt("sort")),
    query = organizationsDescriptorMap.getStringOpt("query") ?: ""
  )

  fun mapToFilter(
    filterMap: ReadableMap?
  ): VCLFilter {
    val did = filterMap?.getStringOpt("did")
    val serviceTypesArr = filterMap?.getArrayOpt("serviceTypes")
    var serviceTypesList: MutableList<VCLServiceType>? = null
    serviceTypesArr?.let {
      serviceTypesList = mutableListOf()
      for (i in 0 until it.size()) {
        serviceTypesList?.add(VCLServiceType.fromString(it.getStringOpt(i) ?: ""))
      }
    }
    val credentialTypesArr = filterMap?.getArrayOpt("credentialTypes")
    var credentialTypesList: MutableList<String>? = null
    credentialTypesArr?.let {
      credentialTypesList = mutableListOf()
      for (i in 0 until it.size()) {
        val credentialType = it.getStringOpt(i)
        credentialType?.let { ct -> credentialTypesList?.add(ct) }
      }
    }
    val serviceTypes = serviceTypesList?.let { VCLServiceTypes(it) }
    return VCLFilter(
      did = did,
      serviceTypes = serviceTypes,
      credentialTypes = credentialTypesList
    )
  }

  fun mapToPage(pageMap: ReadableMap?) = VCLPage(
    size = pageMap?.getStringOpt("size"),
    skip = pageMap?.getStringOpt("skip")
  )

  fun readableArrayToList(
    sortReadableArr: ReadableArray?
  ): List<List<String>>? {
    var sortList: MutableList<List<String>>? = null
    sortReadableArr?.let {
      sortList = mutableListOf()
      for (i in 0 until it.size()) {
        val arr = it.getArrayOpt(i)
        val subList = mutableListOf<String>()
        for (j in 0 until (arr?.size() ?: 0)) {
          arr?.getStringOpt(j)?.let { str -> subList.add(str) }
        }
        if (subList.isNotEmpty()) sortList?.add(subList)
      }
    }
    return sortList
  }

  fun organizationsToMap(
    organizations: VCLOrganizations
  ): ReadableMap {
    val organizationsMap = Arguments.createMap()
    val organizationsWritableArray = Arguments.createArray()
    organizations.all.forEach { organization ->
      val organizationMap = Arguments.createMap()
      organizationMap.putMap("payload", organization.payload.toReadableMap())
      val serviceCredentialAgentIssuersArr = Arguments.createArray()
      organization.serviceCredentialAgentIssuers.forEach { service ->
        val serviceCredentialAgentIssuerMap = Arguments.createMap()
        service.credentialTypes?.let {
          serviceCredentialAgentIssuerMap.putArray("credentialTypes", it.toReadableArray())
        }
        serviceCredentialAgentIssuerMap.putString("id", service.id)
        serviceCredentialAgentIssuerMap.putString("type", service.type)
        serviceCredentialAgentIssuerMap.putString("serviceEndpoint", service.serviceEndpoint)
        serviceCredentialAgentIssuerMap.putMap("payload", service.payload.toReadableMap())
        serviceCredentialAgentIssuersArr.pushMap(serviceCredentialAgentIssuerMap)
      }
      organizationMap.putArray("serviceCredentialAgentIssuers", serviceCredentialAgentIssuersArr)
      organizationMap.putMap("payload", organization.payload.toReadableMap())
      organizationsWritableArray.pushMap(organizationMap)
    }
    organizationsMap.putArray("all", organizationsWritableArray)
    return organizationsMap
  }

  fun mapToPushDelegate(pushDelegateMap: ReadableMap?): VCLPushDelegate? {
    val pushUrl = pushDelegateMap?.getStringOpt(VCLPushDelegate.KeyPushUrl)
    val pushToken = pushDelegateMap?.getStringOpt(VCLPushDelegate.KeyPushToken)
    return if (pushUrl != null && pushToken != null)
      VCLPushDelegate(
        pushUrl = pushUrl,
        pushToken = pushToken
      ) else null
  }

  fun mapToCredentialManifestDescriptor(
    credentialManifestDescriptorMap: ReadableMap
  ): VCLCredentialManifestDescriptor? {
    credentialManifestDescriptorMap.getMapOpt("deepLink")?.let {
      return mapToCredentialManifestDescriptorByDeepLink(credentialManifestDescriptorMap)
    } ?: credentialManifestDescriptorMap.getMapOpt("service")?.let {
      credentialManifestDescriptorMap.getArrayOpt("credentialIds")?.let {
        return mapToCredentialManifestDescriptorRefresh(credentialManifestDescriptorMap)
      } ?: return mapToCredentialManifestDescriptorByService(credentialManifestDescriptorMap)
    }
    return null
  }

  fun mapToCredentialManifestDescriptorByDeepLink(
    credentialManifestDescriptorByDeepLinkMap: ReadableMap
  ): VCLCredentialManifestDescriptorByDeepLink {
    return VCLCredentialManifestDescriptorByDeepLink(
      mapToDeepLink(credentialManifestDescriptorByDeepLinkMap.getMapOpt("deepLink")),
      mapToIssuingType(
        credentialManifestDescriptorByDeepLinkMap,
        VCLIssuingType.Career
      )
    )
  }

  fun mapToCredentialManifestDescriptorByService(
    credentialManifestDescriptorByServiceMap: ReadableMap
  ): VCLCredentialManifestDescriptorByService {
    val pushDelegate =
      mapToPushDelegate(credentialManifestDescriptorByServiceMap.getMapOpt("pushDelegate"))
    return VCLCredentialManifestDescriptorByService(
      service = mapToServiceCredentialAgentIssuer(
        credentialManifestDescriptorByServiceMap.getMapOpt("service")
      ),
      issuingType = mapToIssuingType(
        credentialManifestDescriptorByServiceMap,
        VCLIssuingType.Career
      ),
      credentialTypes =
      (credentialManifestDescriptorByServiceMap.getArrayOpt("credentialTypes")?.toArrayList()
        ?.toList() as? List<String>),
      pushDelegate = pushDelegate
    )
  }

  fun mapToCredentialManifestDescriptorRefresh(
    credentialManifestDescriptorRefreshMap: ReadableMap
  ): VCLCredentialManifestDescriptor {
    return VCLCredentialManifestDescriptorRefresh(
      service = mapToServiceCredentialAgentIssuer(
        credentialManifestDescriptorRefreshMap.getMapOpt("service")
      ),
      credentialIds = credentialManifestDescriptorRefreshMap.getArrayOpt("credentialIds")
        ?.toArrayList()?.toList() as? List<String> ?: listOf()
    )
  }

  fun mapToServiceCredentialAgentIssuer(
    serviceMap: ReadableMap?
  ): VCLServiceCredentialAgentIssuer {
    var payload = JSONObject("{}")
    try {
      payload = JSONObject(serviceMap?.getMapOpt("payload").toString()).getJSONObject("NativeMap")
    } catch (ex: Exception) {
      ex.printStackTrace()
    }
    return VCLServiceCredentialAgentIssuer(payload = payload)
  }

  fun credentialManifestToMap(
    credentialManifest: VCLCredentialManifest
  ): ReadableMap {
    val credentialManifestMap = Arguments.createMap()
    val jwtMap = Arguments.createMap()
    jwtMap.putString("encodedJwt", credentialManifest.jwt.signedJwt.serialize())
    credentialManifestMap.putMap("jwt", jwtMap)
    credentialManifestMap.putString("did", credentialManifest.did)
    credentialManifestMap.putString("iss", credentialManifest.iss)
    credentialManifestMap.putString("exchangeId", credentialManifest.exchangeId)
    credentialManifestMap.putString("vendorOriginContext", credentialManifest.vendorOriginContext)
    return credentialManifestMap
  }

  fun mapToCredentialManifest(
    credentialManifestMap: ReadableMap?
  ): VCLCredentialManifest {
    val jwt =
      VCLJwt(encodedJwt = credentialManifestMap?.getMapOpt("jwt")?.getStringOpt("encodedJwt") ?: "")
    val vendorOriginContext: String? = credentialManifestMap?.getStringOpt("vendorOriginContext")
    return VCLCredentialManifest(jwt = jwt, vendorOriginContext = vendorOriginContext)
  }

  fun mapToGenerateOffersDescriptor(
    generateOffersDescriptorMap: ReadableMap
  ): VCLGenerateOffersDescriptor {
    val verifiableCredentialsReadableArr =
      generateOffersDescriptorMap.getArrayOpt("identificationVerifiableCredentials")
    var verifiableCredentialsList: MutableList<VCLVerifiableCredential>? = null
    verifiableCredentialsReadableArr?.let {
      verifiableCredentialsList = mutableListOf()
      for (i in 0 until it.size()) {
        val verifiableCredentialMap = it.getMapOpt(i)
        verifiableCredentialsList?.add(
          VCLVerifiableCredential(
            inputDescriptor = verifiableCredentialMap?.getStringOpt("inputDescriptor") ?: "",
            jwtVc = verifiableCredentialMap?.getStringOpt("jwtVc") ?: "",
          )
        )
      }
    }
    return VCLGenerateOffersDescriptor(
      mapToCredentialManifest(generateOffersDescriptorMap.getMapOpt("credentialManifest")),
      types = (generateOffersDescriptorMap.getArrayOpt("types")?.toArrayList()
        ?.toList() as? List<String>),
      offerHashes = (generateOffersDescriptorMap.getArrayOpt("offerHashes")?.toArrayList()
        ?.toList() as? List<String>),
      identificationVerifiableCredentials = verifiableCredentialsList
    )
  }

  fun generatedOffersToMap(
    offers: VCLOffers
  ): ReadableMap {
    val generatedOffersMap = Arguments.createMap()
    generatedOffersMap.putArray("all", offers.all.toReadableArray())
    generatedOffersMap.putInt("responseCode", offers.responseCode)
    generatedOffersMap.putMap("token", tokenToMap(offers.token))
    return generatedOffersMap
  }

  fun credentialTypesFormSchemaToMap(
    credentialTypesFormSchema: VCLCredentialTypesUIFormSchema
  ): ReadableMap {
    val credentialTypesFormSchemaMap = Arguments.createMap()
    credentialTypesFormSchemaMap.putMap(
      "payload",
      credentialTypesFormSchema.payload.toReadableMap()
    )
    return credentialTypesFormSchemaMap
  }

  fun mapToJwt(jwtMap: ReadableMap?) =
    VCLJwt(encodedJwt = jwtMap?.getStringOpt("encodedJwt") ?: "")

  fun mapToJwkPublic(jwkPublicMap: ReadableMap?) =
    VCLJwkPublic(valueStr = jwkPublicMap?.getStringOpt("valueStr") ?: "")

  fun mapToFinalizedOffersDescriptor(
    finalizedOffersDescriptorMap: ReadableMap
  ) = VCLFinalizeOffersDescriptor(
    credentialManifest = mapToCredentialManifest(finalizedOffersDescriptorMap.getMapOpt("credentialManifest")),
    approvedOfferIds = (finalizedOffersDescriptorMap.getArrayOpt("approvedOfferIds")?.toArrayList()
      ?.toList() as? List<String>) ?: listOf(),
    rejectedOfferIds = (finalizedOffersDescriptorMap.getArrayOpt("rejectedOfferIds")?.toArrayList()
      ?.toList() as? List<String>) ?: listOf()
  )

  fun jwtVerifiableCredentialsToMap(
    jwtVerifiableCredentials: VCLJwtVerifiableCredentials
  ): ReadableMap {
    val jwtVerifiableCredentialsMap = Arguments.createMap()
    val jwtArr = Arguments.createArray()
    jwtVerifiableCredentials.all.forEach {
      jwtArr.pushString(it.signedJwt.serialize())
    }
    jwtVerifiableCredentialsMap.putArray("all", jwtArr)
    return jwtVerifiableCredentialsMap
  }

  fun jwtToMap(jwt: VCLJwt): ReadableMap {
    val jwtReadableMap = Arguments.createMap()
    jwtReadableMap.putString("encodedJwt", jwt.signedJwt.serialize())
    return jwtReadableMap
  }

  fun mapToCredentialTypesUIFormSchemaDescriptor(
    credentialTypesUIFormSchemaDescriptorMap: ReadableMap
  ) = VCLCredentialTypesUIFormSchemaDescriptor(
    credentialTypesUIFormSchemaDescriptorMap.getStringOpt("credentialType") ?: "",
    credentialTypesUIFormSchemaDescriptorMap.getStringOpt("countryCode") ?: "",
  )

  fun mapToVerifiedProfileDescriptor(verifiedProfileDescriptor: ReadableMap) =
    VCLVerifiedProfileDescriptor(
      did = verifiedProfileDescriptor.getStringOpt("did") ?: ""
    )

  fun verifiedProfileToMap(
    verifiedProfile: VCLVerifiedProfile
  ): ReadableMap {
    val verifiedProfileMap = Arguments.createMap()
    verifiedProfileMap.putMap("payload", verifiedProfile.payload.toReadableMap())
    verifiedProfileMap.putString("id", verifiedProfile.id)
    verifiedProfileMap.putString("logo", verifiedProfile.logo)
    verifiedProfileMap.putString("name", verifiedProfile.name)
    return verifiedProfileMap
  }

  fun mapToJwtDescriptor(
    jwtDescriptorDictionary: ReadableMap
  ) = VCLJwtDescriptor(
    payload = jwtDescriptorDictionary.getMapOpt("payload")?.toJsonObject() ?: JSONObject("{}"),
    iss = jwtDescriptorDictionary.getStringOpt("iss") ?: "",
    jti = jwtDescriptorDictionary.getStringOpt("jti") ?: ""
  )

  fun didJwkToMap(
    didJwk: VCLDidJwk
  ): ReadableMap {
    val didJwkMap = Arguments.createMap()
    didJwkMap.putString("value", didJwk.value)
    return didJwkMap
  }
}

