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
import io.velocitycareerlabs.api.entities.initialization.VCLCryptoServicesDescriptor
import io.velocitycareerlabs.api.entities.initialization.VCLInitializationDescriptor
import io.velocitycareerlabs.api.entities.initialization.VCLJwtServiceUrls
import io.velocitycareerlabs.api.entities.initialization.VCLKeyServiceUrls
import io.velocitycareerlabs.api.entities.initialization.VCLRemoteCryptoServicesUrlsDescriptor
import io.velocitycareerlabs.reactnative.extensions.*
import org.json.JSONObject

object Converter {

  fun mapToInitializationDescriptor(
    initializationDescriptorMap: ReadableMap
  ) = VCLInitializationDescriptor(
    environment = mapToEnvironment(
      initializationDescriptorMap.getStringOpt("environment")
    ),
    xVnfProtocolVersion = mapToXVnfProtocolVersion(
      (initializationDescriptorMap.getStringOpt("xVnfProtocolVersion"))
    ),
    cacheSequence = initializationDescriptorMap.getIntOpt("cacheSequence") ?: 0,
    isDebugOn = initializationDescriptorMap.getBooleanOpt("isDebugOn") ?: false,
    cryptoServicesDescriptor = mapToCryptoServicesDescriptor(
      initializationDescriptorMap.getMapOpt("cryptoServicesDescriptor")
    ),
    isDirectIssuerCheckOn = initializationDescriptorMap.getBooleanOpt("isDirectIssuerCheckOn") ?: true
  )

  private fun mapToEnvironment(environment: String?) =
    VCLEnvironment.fromString(environment ?: "")

  private fun mapToCryptoServicesDescriptor(
    cryptoServicesDescriptorMap: ReadableMap?
  ): VCLCryptoServicesDescriptor {
    val cryptoServiceType =
      VCLCryptoServiceType.fromString(
        cryptoServicesDescriptorMap?.getStringOpt("cryptoServiceType") ?: ""
      )
    val remoteCryptoServicesUrlsDescriptorMap =
      cryptoServicesDescriptorMap?.getMap("remoteCryptoServicesUrlsDescriptor")
    val keyServiceUrls = remoteCryptoServicesUrlsDescriptorMap?.getMapOpt("keyServiceUrls")
    val jwtServiceUrls = remoteCryptoServicesUrlsDescriptorMap?.getMapOpt("jwtServiceUrls")
    val remoteCryptoServicesUrlsDescriptor = VCLRemoteCryptoServicesUrlsDescriptor(
      keyServiceUrls = VCLKeyServiceUrls(
        createDidKeyServiceUrl = keyServiceUrls?.getStringOpt("createDidKeyServiceUrl") ?: ""
      ),
      jwtServiceUrls = VCLJwtServiceUrls(
        jwtSignServiceUrl = jwtServiceUrls?.getStringOpt("jwtSignServiceUrl") ?: "",
        jwtVerifyServiceUrl = jwtServiceUrls?.getStringOpt("jwtVerifyServiceUrl")
      )
    )
    return VCLCryptoServicesDescriptor(
      cryptoServiceType = cryptoServiceType,
      remoteCryptoServicesUrlsDescriptor = remoteCryptoServicesUrlsDescriptor
    )
  }

  private fun mapToXVnfProtocolVersion(xVnfProtocolVersion: String?) =
    VCLXVnfProtocolVersion.fromString(xVnfProtocolVersion ?: "")

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
      credentialType.putArray("jsonldContext", it.jsonldContext?.toReadableArray())
      credentialType.putString("issuerCategory", it.issuerCategory)
      credentialTypesArray.pushMap(credentialType)
    }
    return credentialTypesArray
  }

  fun mapTopPresentationRequestDescriptor(presentationRequestDescriptorLinkMap: ReadableMap) =
    VCLPresentationRequestDescriptor(
      deepLink = mapToDeepLink(presentationRequestDescriptorLinkMap.getMapOpt("deepLink"))
        ?: VCLDeepLink(""),
      pushDelegate = mapToPushDelegate(presentationRequestDescriptorLinkMap.getMapOpt("pushDelegate"))
    )

  fun mapToDeepLink(deepLinkMap: ReadableMap?): VCLDeepLink? {
    deepLinkMap?.getStringOpt("value")?.let {
      return VCLDeepLink(it)
    }
    return null
  }

  fun deepLinkToMap(deepLink: VCLDeepLink?): ReadableMap? {
    deepLink?.value?.let {
      val retVal = Arguments.createMap()
      retVal.putString("value", deepLink?.value)
      return retVal
    }
    return null
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
    token.expiresIn?.toDouble()?.let {
      retVal.putDouble("expiresIn", it)
    }
    return retVal
  }

  fun mapToPresentationRequest(
    presentationRequestMap: ReadableMap?
  ) = VCLPresentationRequest(
    mapToJwt(presentationRequestMap?.getMapOpt("jwt")),
    mapToPublicJwk(presentationRequestMap?.getMapOpt("publicJwk")),
    mapToDeepLink(presentationRequestMap?.getMapOpt("deepLink")) ?: VCLDeepLink("")
  )

  fun presentationRequestToMap(
    presentationRequest: VCLPresentationRequest
  ): ReadableMap {
    val presentationRequestMap = Arguments.createMap()
    val jwtMap = Arguments.createMap()
    jwtMap.putString("encodedJwt", presentationRequest.jwt.encodedJwt)
    presentationRequestMap.putMap("jwt", jwtMap)
    val jwkMap = Arguments.createMap()
    jwkMap.putString("valueStr", presentationRequest.publicJwk.valueStr)
    presentationRequestMap.putMap("publicJwk", jwkMap)
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
      VCLSubmissionResult.KeyToken, tokenToMap(presentationSubmissionResult.sessionToken)
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
    sessionToken = mapToToken(submissionResultMap?.getMapOpt(VCLSubmissionResult.KeyToken)),
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
      mapToDeepLink(credentialManifestDescriptorByDeepLinkMap.getMapOpt("deepLink"))
        ?: VCLDeepLink(""),
      mapToIssuingType(credentialManifestDescriptorByDeepLinkMap, VCLIssuingType.Career),
      mapToPushDelegate(credentialManifestDescriptorByDeepLinkMap.getMapOpt("pushDelegate"))
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
  ): VCLServiceCredentialAgentIssuer =
    VCLServiceCredentialAgentIssuer(
      payload = serviceMap?.getMapOpt("payload")?.toJsonObject() ?: JSONObject()
    )

  fun credentialManifestToMap(
    credentialManifest: VCLCredentialManifest
  ): ReadableMap {
    val credentialManifestMap = Arguments.createMap()
    val jwtMap = Arguments.createMap()
    jwtMap.putString("encodedJwt", credentialManifest.jwt.encodedJwt)
    credentialManifestMap.putMap("jwt", jwtMap)
    credentialManifestMap.putString("did", credentialManifest.did)
    credentialManifestMap.putString("iss", credentialManifest.iss)
    credentialManifestMap.putString("exchangeId", credentialManifest.exchangeId)
    credentialManifestMap.putString("vendorOriginContext", credentialManifest.vendorOriginContext)
    credentialManifestMap.putMap(
      "verifiedProfile",
      credentialManifest.verifiedProfile.payload.toReadableMap()
    )
    credentialManifestMap.putMap("deepLink", deepLinkToMap(credentialManifest.deepLink))
    return credentialManifestMap
  }

  fun mapToCredentialManifest(
    credentialManifestMap: ReadableMap?
  ): VCLCredentialManifest {
    val jwt =
      VCLJwt(encodedJwt = credentialManifestMap?.getMapOpt("jwt")?.getStringOpt("encodedJwt") ?: "")
    val vendorOriginContext: String? = credentialManifestMap?.getStringOpt("vendorOriginContext")
    val verifiedProfileMap: ReadableMap? = credentialManifestMap?.getMapOpt("verifiedProfile")
    val deepLinkMap: ReadableMap? = credentialManifestMap?.getMapOpt("deepLink")
    return VCLCredentialManifest(
      jwt = jwt,
      vendorOriginContext = vendorOriginContext,
      verifiedProfile = VCLVerifiedProfile(
        payload = verifiedProfileMap?.toJsonObject() ?: JSONObject()
      ),
      deepLink = mapToDeepLink(deepLinkMap)
    )
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

  fun offersToMap(
    offers: VCLOffers
  ): ReadableMap {
    val generatedOffersMap = Arguments.createMap()
    generatedOffersMap.putMap("payload", offers.payload.toReadableMap())
    generatedOffersMap.putArray("all", allOffersToArray(offers.all))
    generatedOffersMap.putInt("responseCode", offers.responseCode)
    generatedOffersMap.putMap("sessionToken", tokenToMap(offers.sessionToken))
    generatedOffersMap.putString("challenge", offers.challenge)
    return generatedOffersMap
  }

  fun mapToOffers(offersMap: ReadableMap?): VCLOffers {
    return VCLOffers(
      payload = offersMap?.getMapOpt("payload")?.toJsonObject() ?: JSONObject(),
      all = arrayToAllOffers(offersMap?.getArrayOpt("all")),
      responseCode = offersMap?.getIntOpt("responseCode") ?: -1,
      sessionToken = mapToToken(offersMap?.getMapOpt("sessionToken")),
      challenge = offersMap?.getStringOpt("challenge") ?: ""
    )
  }

  fun arrayToAllOffers(allOffersArray: ReadableArray?): List<VCLOffer> {
    val allOffers = mutableListOf<VCLOffer>()
    for (i in 0 until (allOffersArray?.size() ?: 0)) {
      allOffers.add(VCLOffer(allOffersArray?.getMapOpt(i)?.toJsonObject() ?: JSONObject()))
    }
    return allOffers
  }

  fun allOffersToArray(allOffers: List<VCLOffer>?): ReadableArray {
    val allOffersArr = Arguments.createArray()
    for (i in 0 until (allOffers?.size ?: 0)) {
      val offerMap = Arguments.createMap()
      offerMap.putMap("payload", allOffers?.get(i)?.payload?.toReadableMap())
      offerMap.putString("issuerId", allOffers?.get(i)?.issuerId)
      offerMap.putString("id", allOffers?.get(i)?.id)
      allOffersArr.pushMap(offerMap)
    }
    return allOffersArr
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

  fun mapToPublicJwk(publicJwkMap: ReadableMap?) =
    VCLPublicJwk(valueStr = publicJwkMap?.getStringOpt("valueStr") ?: "")

  fun mapToFinalizedOffersDescriptor(
    finalizedOffersDescriptorMap: ReadableMap
  ) = VCLFinalizeOffersDescriptor(
    credentialManifest = mapToCredentialManifest(finalizedOffersDescriptorMap.getMapOpt("credentialManifest")),
    offers = mapToOffers(finalizedOffersDescriptorMap.getMapOpt("offers")),
    approvedOfferIds = (finalizedOffersDescriptorMap.getArrayOpt("approvedOfferIds")?.toArrayList()
      ?.toList() as? List<String>) ?: listOf(),
    rejectedOfferIds = (finalizedOffersDescriptorMap.getArrayOpt("rejectedOfferIds")?.toArrayList()
      ?.toList() as? List<String>) ?: listOf()
  )

  fun jwtVerifiableCredentialsToMap(
    jwtVerifiableCredentials: VCLJwtVerifiableCredentials
  ): ReadableMap {
    val jwtVerifiableCredentialsMap = Arguments.createMap()
    val passedCredentials = Arguments.createArray()
    val failedCredentials = Arguments.createArray()
    jwtVerifiableCredentials.passedCredentials.forEach {
      passedCredentials.pushString(it.encodedJwt)
    }
    jwtVerifiableCredentials.failedCredentials.forEach {
      failedCredentials.pushString(it.encodedJwt)
    }
    jwtVerifiableCredentialsMap.putArray("passedCredentials", passedCredentials)
    jwtVerifiableCredentialsMap.putArray("failedCredentials", failedCredentials)
    return jwtVerifiableCredentialsMap
  }

  fun jwtToMap(jwt: VCLJwt): ReadableMap {
    val jwtReadableMap = Arguments.createMap()
    jwtReadableMap.putString("encodedJwt", jwt.encodedJwt)
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

  fun didJwkToMap(didJwk: VCLDidJwk): ReadableMap {
      val didJwkMap = Arguments.createMap()
      didJwkMap.putString("did", didJwk.did)
      didJwkMap.putMap("publicJwk", didJwk.publicJwk.valueJson.toReadableMap())
      didJwkMap.putString("kid", didJwk.kid)
      didJwkMap.putString("keyId", didJwk.keyId)
      return didJwkMap
  }

  fun mapToDidJwk(didJwkMap: ReadableMap): VCLDidJwk {
      return VCLDidJwk(
        did = didJwkMap.getStringOpt("did") ?: "",
        publicJwk = mapToPublicJwk(didJwkMap.getMap("publicJwk")),
        kid = didJwkMap.getStringOpt("kid") ?: "",
        keyId = didJwkMap.getStringOpt("keyId") ?: ""
      )
  }
}

