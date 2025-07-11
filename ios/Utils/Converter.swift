//
//  Converter.swift
//  VclReactNative
//
//  Created by Michael Avoyan on 05/07/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation
import VCL

func dictionaryToInitializationDescriptor(
    _ initializationDescriptorDictionary: [String: Any]
) -> VCLInitializationDescriptor {
  return VCLInitializationDescriptor(
    environment: dictionaryToEnvironment(
      initializationDescriptorDictionary["environment"] as? String
    ),
    xVnfProtocolVersion: dictionaryToXVnfProtocolVersion (
      initializationDescriptorDictionary["xVnfProtocolVersion"] as? String
    ),
    cacheSequence: initializationDescriptorDictionary["cacheSequence"] as? Int ?? 0,
    isDebugOn: initializationDescriptorDictionary["isDebugOn"] as? Bool ?? false,
    cryptoServicesDescriptor: dictionaryToCryptoServicesDescriptor(
      initializationDescriptorDictionary["cryptoServicesDescriptor"] as? [String : Any]
    ),
    isDirectIssuerCheckOn: initializationDescriptorDictionary["isDirectIssuerCheckOn"] as? Bool ?? true
  )
}

private func dictionaryToEnvironment(
    _ environment: String?
) -> VCLEnvironment {
  return VCLEnvironment.fromString(value: environment ?? "")
}

private func dictionaryToCryptoServicesDescriptor(
  _ cryptoServicesDescriptorDictionary: [String: Any]?
) -> VCLCryptoServicesDescriptor {
  let cryptoServiceType =
  VCLCryptoServiceType.fromString(
    value: cryptoServicesDescriptorDictionary?["cryptoServiceType"] as? String ?? ""
  )
  let remoteCryptoServicesUrlsDescriptorDictionary = cryptoServicesDescriptorDictionary?["remoteCryptoServicesUrlsDescriptor"] as? [String: Any]
  let keyServiceUrls = remoteCryptoServicesUrlsDescriptorDictionary?["keyServiceUrls"] as? [String: Any]
  let jwtServiceUrls = remoteCryptoServicesUrlsDescriptorDictionary?["jwtServiceUrls"] as? [String: Any]
  let remoteCryptoServicesUrlsDescriptor = VCLRemoteCryptoServicesUrlsDescriptor(
    keyServiceUrls:  VCLKeyServiceUrls(
      createDidKeyServiceUrl: keyServiceUrls?["createDidKeyServiceUrl"] as? String ?? ""
    ),
    jwtServiceUrls:  VCLJwtServiceUrls(
      jwtSignServiceUrl: jwtServiceUrls?["jwtSignServiceUrl"] as? String ?? "",
      jwtVerifyServiceUrl: jwtServiceUrls?["jwtVerifyServiceUrl"] as? String
    )
  )
  return VCLCryptoServicesDescriptor(
    cryptoServiceType: cryptoServiceType,
    remoteCryptoServicesUrlsDescriptor: remoteCryptoServicesUrlsDescriptor
  )
}

private func dictionaryToXVnfProtocolVersion(
    _ xVnfProtocolVersion: String?
) -> VCLXVnfProtocolVersion {
  return VCLXVnfProtocolVersion.fromString(value: xVnfProtocolVersion ?? "")
}

func regionToDictionary(
    _ region: VCLRegion
) -> [String: Any] {
  var regionDict = [String: Any]()
  regionDict["payload"] = region.payload
  regionDict["code"] = region.code
  regionDict["name"] = region.name
  return regionDict
}

func regionsToDictionary(
    _ regions: VCLRegions
) -> [String: Any] {
  var regionsMap = [String: Any]()
  var regionsArr = [[String: Any]]()
  for i in 0..<regions.all.count {
    regionsArr.append(regionToDictionary(regions.all[i]))
  }
  regionsMap["all"] = regionsArr
  return regionsMap
}

func countryToDictionary(
    _ country: VCLCountry
) -> [String: Any] {
  var countryDict = [String: Any]()
  countryDict["payload"] = country.payload
  countryDict["code"] = country.code
  countryDict["name"] = country.name
  if let regions = country.regions {
    countryDict["regions"] = regionsToDictionary(regions)
  }
  return countryDict
}

func countriesToDictionary(
    _ countries: VCLCountries
) -> [String: [[String: Any]?]] {
  var countriesArr = [[String: Any]?] ()
  if let all = countries.all {
    for i in 0..<all.count {
      countriesArr.append(countryToDictionary(all[i]))
    }
  }
  return ["all": countriesArr]
}

func credentialTypeSchemasToDictionary(
    _ credentialTypeSchemas: VCLCredentialTypeSchemas
) -> [String: [String: Any]]  {
  var credentialTypeSchemasMap = [String: [String: Any]]()
  if let all = credentialTypeSchemas.all {
    for (key, credentialTypeSchema) in all {
      var credentialTypeSchemaDictionary = [String: Any]()
      credentialTypeSchemaDictionary["payload"] = credentialTypeSchema.payload
      credentialTypeSchemasMap[key] = credentialTypeSchemaDictionary
    }
  }
  return ["all": credentialTypeSchemasMap]
}

func credentialTypesToDictionary(
    _ credentialTypes: VCLCredentialTypes
) -> [String: [[String: Any?]]]  {
  var credentialTypesArray = [[String: Any?]]()
  var recommendedCredentialTypesArray = [[String: Any?]]()
  if let all = credentialTypes.all {
    credentialTypesArray = parseCredentialTypesArray(all)
  }
  if let recommendedTypes = credentialTypes.recommendedTypes {
    recommendedCredentialTypesArray = parseCredentialTypesArray(recommendedTypes)
  }
  return ["all": credentialTypesArray, "recommendedTypes": recommendedCredentialTypesArray]
}

private func parseCredentialTypesArray(_ credentialTypesArr: [VCLCredentialType]) -> [[String: Any?]] {
  var credentialTypesArray = [[String: Any?]]()
  credentialTypesArr.forEach {
    var credentialType = [String: Any?]()
    credentialType["payload"] = $0.payload
    credentialType["id"] = $0.id
    credentialType["schema"] = $0.schema
    credentialType["createdAt"] = $0.createdAt
    credentialType["schemaName"] = $0.schemaName
    credentialType["credentialType"] = $0.credentialType
    credentialType["recommended"] = $0.recommended
    credentialType["jsonldContext"] = $0.jsonldContext
    credentialType["issuerCategory"] = $0.issuerCategory
    credentialTypesArray.append(credentialType)
  }
  return credentialTypesArray
}

func dictionaryTopPresentationRequestDescriptor(
    _ presentationRequestDescriptorLinkDictionary: [String: Any]
) -> VCLPresentationRequestDescriptor {
  return VCLPresentationRequestDescriptor(
    deepLink: dictionaryToDeepLink(presentationRequestDescriptorLinkDictionary["deepLink"] as? [String: Any]) ?? VCLDeepLink(value: ""),
    pushDelegate: dictionaryToPushDelegate(presentationRequestDescriptorLinkDictionary["pushDelegate"] as? [String: Any]),
    didJwk: dictionaryToDidJwk(presentationRequestDescriptorLinkDictionary["didJwk"] as? [String: Any]),
    remoteCryptoServicesToken: dictionaryToToken(
      presentationRequestDescriptorLinkDictionary["remoteCryptoServicesToken"] as? [String: Any]
    )
  )
}

func dictionaryToDeepLink(_ deepLinkDictionary: [String: Any]?) -> VCLDeepLink? {
  if let value = deepLinkDictionary?["value"] as? String {
    return VCLDeepLink(value: value)
  }
  return nil
}

func deepLinkToDictionary(_ deepLink: VCLDeepLink?) -> [String: Any]? {
  if let value = deepLink?.value {
    return ["value": value]
  }
  return nil
}

func dictionaryToToken(_ tokenDictionary: [String: Any]?) -> VCLToken {
  return VCLToken(value: tokenDictionary?["value"] as? String ?? "")
}

func tokenToDictionary(_ token: VCLToken?) -> [String: Any] {
  var retVal = [String: Any]()
  retVal["value"] = token?.value
  if let expiresIn = token?.expiresIn {
    retVal["expiresIn"] = expiresIn
  }
  return retVal
}

func dictionaryToIssuingType(
    issuingTypeDictionary: [String: Any],
    defaultIssuingType: VCLIssuingType
) -> VCLIssuingType {
  if let issuingType = issuingTypeDictionary["issuingType"] as? String {
    return VCLIssuingType.fromString(value: issuingType)
  }
  return defaultIssuingType
}

func dictionaryToPresentationRequest(
    _ presentationRequestDictionary: [String: Any]?
) -> VCLPresentationRequest {
  return VCLPresentationRequest(
    jwt: dictionaryToJwt(presentationRequestDictionary?["jwt"] as? [String : Any]),
    verifiedProfile: dictionaryToVerifiedProfile(presentationRequestDictionary?["verifiedProfile"] as? [String: Any]),
    deepLink: dictionaryToDeepLink(presentationRequestDictionary?["deepLink"] as? [String : Any]) ?? VCLDeepLink(value: ""),
    pushDelegate: dictionaryToPushDelegate(presentationRequestDictionary?["pushDelegate"] as? [String : Any]),
    didJwk: dictionaryToDidJwk(presentationRequestDictionary?["didJwk"] as? [String : Any]),
    remoteCryptoServicesToken: dictionaryToToken(presentationRequestDictionary?["remoteCryptoServicesToken"] as? [String : Any])
  )
}

func presentationRequestToDictionary(
    _ presentationRequest: VCLPresentationRequest
) -> [String: Any] {
  var presentationRequestDictionary = [String: Any]()
  presentationRequestDictionary["jwt"] = ["encodedJwt": presentationRequest.jwt.encodedJwt]
  presentationRequestDictionary["verifiedProfile"] = verifiedProfileToDictionary(presentationRequest.verifiedProfile)
  presentationRequestDictionary["iss"] = presentationRequest.iss
  presentationRequestDictionary["exchangeId"] = presentationRequest.exchangeId
  presentationRequestDictionary["presentationDefinitionId"] = presentationRequest.presentationDefinitionId
  presentationRequestDictionary["deepLink"] = deepLinkToDictionary(presentationRequest.deepLink)
  presentationRequestDictionary["didJwk"] = didJwkToDictionary(presentationRequest.didJwk)
  presentationRequestDictionary["feed"] = presentationRequest.feed
  presentationRequestDictionary["remoteCryptoServicesToken"] = tokenToDictionary(presentationRequest.remoteCryptoServicesToken)
  return presentationRequestDictionary
}

func dictionaryToPresentationSubmission(
    _ presentationSubmissionDictionary: [String: Any]?
) -> VCLPresentationSubmission {
  var verifiableCredentialsList = [VCLVerifiableCredential]()
  if let verifiableCredentialsArr = (presentationSubmissionDictionary?["verifiableCredentials"] as? [[String: String]]) {
    for verifiableCredential in verifiableCredentialsArr {
      verifiableCredentialsList.append(
        VCLVerifiableCredential(
          inputDescriptor: verifiableCredential["inputDescriptor"] ?? "",
          jwtVc: verifiableCredential["jwtVc"] ?? ""
        )
      )
    }
  }
  return VCLPresentationSubmission(
    presentationRequest: dictionaryToPresentationRequest(presentationSubmissionDictionary?["presentationRequest"] as? [String: Any]),
    verifiableCredentials: verifiableCredentialsList
  )
}

func presentationSubmissionResultToDictionary(
    _ presentationSubmissionResult: VCLSubmissionResult
) -> [String: Any] {
  var presentationSubmissionResulDictionary = [String: Any]()
  presentationSubmissionResulDictionary[VCLSubmissionResult.CodingKeys.KeyToken] = tokenToDictionary(presentationSubmissionResult.sessionToken)
  presentationSubmissionResulDictionary[VCLSubmissionResult.CodingKeys.KeyExchange] = exchangeToDictionary(presentationSubmissionResult.exchange)
  presentationSubmissionResulDictionary[VCLSubmissionResult.CodingKeys.KeyJti] = presentationSubmissionResult.jti
  presentationSubmissionResulDictionary[VCLSubmissionResult.CodingKeys.KeySubmissionId] = presentationSubmissionResult.submissionId
  return presentationSubmissionResulDictionary
}

func exchangeToDictionary(
    _ exchange: VCLExchange?
) -> [String: Any] {
  var exchangeDictionary = [String: Any]()
  exchangeDictionary["id"] = exchange?.id
  exchangeDictionary["type"] = exchange?.type
  exchangeDictionary["disclosureComplete"] = exchange?.disclosureComplete
  exchangeDictionary["exchangeComplete"] = exchange?.exchangeComplete
  return exchangeDictionary
}

func dictionaryToSubmissionResult(_ submissionResultDictionary: [String: Any]?) -> VCLSubmissionResult {
  return VCLSubmissionResult(
    sessionToken: dictionaryToToken(submissionResultDictionary?[VCLSubmissionResult.CodingKeys.KeyToken] as? [String: Any]),
    exchange: dictionaryToExchange(submissionResultDictionary?[VCLSubmissionResult.CodingKeys.KeyExchange] as? [String: Any]),
    jti: submissionResultDictionary?[VCLSubmissionResult.CodingKeys.KeyJti] as? String ?? "",
    submissionId: submissionResultDictionary?[VCLSubmissionResult.CodingKeys.KeySubmissionId] as? String ?? ""
  )
}

func dictionaryToExchange(
    _ exchangeReadableMap: [String: Any]?
) -> VCLExchange {
  return VCLExchange(
    id: exchangeReadableMap?["id"] as? String ?? "",
    type: exchangeReadableMap?["type"] as? String  ?? "",
    disclosureComplete: exchangeReadableMap?["disclosureComplete"] as? Bool ?? false,
    exchangeComplete: exchangeReadableMap?["exchangeComplete"] as? Bool ?? false
  )
}

func dictionaryToExchangeDescriptor(
    _ exchangeDescriptorDictionary: [String: Any]?
) -> VCLExchangeDescriptor {
  return VCLExchangeDescriptor(
    presentationSubmission: dictionaryToPresentationSubmission(exchangeDescriptorDictionary?["presentationSubmission"] as? [String: Any]),
    submissionResult: dictionaryToSubmissionResult(exchangeDescriptorDictionary?["submissionResult"] as? [String: Any])
  )
}

func dictionayToOrganizationsSearchDescriptor(
    _ organizationsDescriptorDictionary: [String: Any]
) -> VCLOrganizationsSearchDescriptor {
  return VCLOrganizationsSearchDescriptor(
    filter: dictionaryToFilter(organizationsDescriptorDictionary["filter"] as? [String : Any]),
    page: dictionaryToPage(organizationsDescriptorDictionary["page"] as? [String : Any]),
    sort: organizationsDescriptorDictionary["sort"] as? [[String]],
    query: organizationsDescriptorDictionary["query"] as? String
  )
}

func dictionaryToFilter(
    _ filterDictionary: [String: Any]?
) -> VCLFilter {
  let did: String? = filterDictionary?["did"] as? String
  var serviceTypesList: [VCLServiceType]? = nil
  if let serviceTypesArr = (filterDictionary?["serviceTypes"] as? [String]) {
    serviceTypesList = [VCLServiceType]()
    for serviceTypeStr in serviceTypesArr {
      serviceTypesList?.append(VCLServiceType.fromString(value: serviceTypeStr))
    }
  }
  var credentialTypesList: [String]? = nil
  if let credentialTypesArr = (filterDictionary?["credentialTypes"] as? [String]) {
    credentialTypesList = [String]()
    for credentialType in credentialTypesArr {
      credentialTypesList?.append(credentialType)
    }
  }
  let serviceTypes: VCLServiceTypes? = serviceTypesList != nil ? VCLServiceTypes(all: serviceTypesList ?? [VCLServiceType]()) : nil
  return VCLFilter(did: did, serviceTypes: serviceTypes, credentialTypes: credentialTypesList)
}

func dictionaryToPage(_ pageDictionary: [String: Any]?) -> VCLPage {
  return VCLPage(
    size: pageDictionary?["size"] as? String,
    skip: pageDictionary?["skip"] as? String
  )
}

func organizationsToDictionary(
    _ organizations: VCLOrganizations
) -> [String: Any] {
  var organizationsMap = [String: Any]()
  var organizationsArr = [[String: Any]]()
  organizations.all.forEach { organization in
    var organizationMap = [String: Any]()
    organizationMap["payload"] = organization.payload
    var serviceCredentialAgentIssuersArr = [[String: Any]]()
    organization.serviceCredentialAgentIssuers.forEach { service in
      var serviceCredentialAgentIssuerMap = [String: Any]()
      if let credentialTypes = service.credentialTypes {
        serviceCredentialAgentIssuerMap["credentialTypes"] = credentialTypes
      }
      serviceCredentialAgentIssuerMap["id"] = service.id
      serviceCredentialAgentIssuerMap["type"] = service.type
      serviceCredentialAgentIssuerMap["serviceEndpoint"] = service.serviceEndpoint
      serviceCredentialAgentIssuerMap["payload"] = service.payload
      serviceCredentialAgentIssuersArr.append(serviceCredentialAgentIssuerMap)
    }
    organizationMap["serviceCredentialAgentIssuers"] = serviceCredentialAgentIssuersArr
    organizationMap["did"] = organization.did
    organizationMap["payload"] = organization.payload
    organizationsArr.append(organizationMap)
  }
  organizationsMap["all"] = organizationsArr
  return organizationsMap
}

func dictionaryToPushDelegate(_ pushDelegateMap: [String: Any]?) -> VCLPushDelegate? {
  let pushUrl = pushDelegateMap?["pushUrl"] as? String
  let pushToken = pushDelegateMap?["pushToken"] as? String
  if (pushUrl != nil && pushToken != nil) {
    return VCLPushDelegate(
      pushUrl: pushUrl!,
      pushToken: pushToken!
    )
  }
  else { return nil }
}

func dictionaryToCredentialManifestDescriptor(
    _ credentialManifestDescriptorDictionary: [String: Any]
) -> VCLCredentialManifestDescriptor? {
    let hasDeepLink = credentialManifestDescriptorDictionary["deepLink"] != nil
    let hasService = credentialManifestDescriptorDictionary["service"] != nil
    let hasCredentialIds = credentialManifestDescriptorDictionary["credentialIds"] != nil

    switch (hasDeepLink, hasService, hasCredentialIds) {
    case (true, _, _):
        return dictionaryToCredentialManifestDescriptorByDeepLink(credentialManifestDescriptorDictionary)
    case (false, true, true):
        return dictionaryToCredentialManifestDescriptorRefresh(credentialManifestDescriptorDictionary)
    case (false, true, false):
        return dictionaryToCredentialManifestDescriptorByService(credentialManifestDescriptorDictionary)
    default:
        return nil
    }
}

func dictionaryToCredentialManifestDescriptorByDeepLink(
    _ credentialManifestDescriptorByDeepLinkDictionary: [String: Any]
) -> VCLCredentialManifestDescriptorByDeepLink {
  return VCLCredentialManifestDescriptorByDeepLink(
    deepLink: dictionaryToDeepLink(
      credentialManifestDescriptorByDeepLinkDictionary["deepLink"] as? [String: Any]
    ) ?? VCLDeepLink(value: ""),
    issuingType: dictionaryToIssuingType(
      issuingTypeDictionary: credentialManifestDescriptorByDeepLinkDictionary,
      defaultIssuingType: VCLIssuingType.Career
    ),
    pushDelegate: dictionaryToPushDelegate(credentialManifestDescriptorByDeepLinkDictionary["pushDelegate"] as? [String: Any]),
    didJwk: dictionaryToDidJwk(credentialManifestDescriptorByDeepLinkDictionary["didJwk"] as? [String: Any]),
    remoteCryptoServicesToken: dictionaryToToken(
      credentialManifestDescriptorByDeepLinkDictionary["remoteCryptoServicesToken"] as? [String: Any]
    )
  )
}

func dictionaryToCredentialManifestDescriptorByService(
    _ credentialManifestDescriptorByServiceDictionary: [String: Any]
) -> VCLCredentialManifestDescriptorByService {
  return VCLCredentialManifestDescriptorByService(
    service: dictionaryToService(
      credentialManifestDescriptorByServiceDictionary["service"] as? [String : Any]
    ),
    issuingType: dictionaryToIssuingType(
      issuingTypeDictionary: credentialManifestDescriptorByServiceDictionary,
      defaultIssuingType: VCLIssuingType.Career
    ),
    credentialTypes: credentialManifestDescriptorByServiceDictionary["credentialTypes"] as? [String],
    pushDelegate: dictionaryToPushDelegate(
      credentialManifestDescriptorByServiceDictionary["pushDelegate"] as? [String: Any]
    ),
    didJwk: dictionaryToDidJwk(credentialManifestDescriptorByServiceDictionary["didJwk"] as? [String: Any]),
    did: credentialManifestDescriptorByServiceDictionary["did"] as? String ?? "",
    remoteCryptoServicesToken: dictionaryToToken(
      credentialManifestDescriptorByServiceDictionary["remoteCryptoServicesToken"] as? [String: Any]
    )
  )
}

func dictionaryToCredentialManifestDescriptorRefresh(
    _ credentialManifestDescriptorRefreshDictionary: [String: Any]
) -> VCLCredentialManifestDescriptorRefresh {
  return VCLCredentialManifestDescriptorRefresh(
    service: dictionaryToService(
      credentialManifestDescriptorRefreshDictionary["service"] as? [String : Any]
    ),
    credentialIds: credentialManifestDescriptorRefreshDictionary["credentialIds"] as? [String] ?? [],
    didJwk: dictionaryToDidJwk(credentialManifestDescriptorRefreshDictionary["didJwk"] as? [String: Any]),
    did: credentialManifestDescriptorRefreshDictionary["did"] as? String ?? "",
    remoteCryptoServicesToken: dictionaryToToken(
      credentialManifestDescriptorRefreshDictionary["remoteCryptoServicesToken"] as? [String: Any]
    )
  )
}

func dictionaryToService(
    _ serviceDictionary: [String: Any]?
) -> VCLService {
  return VCLService(payload: serviceDictionary?["payload"] as? [String : Any] ?? [:])
}

func credentialManifestToDictionary(
    _ credentialManifest: VCLCredentialManifest
) -> [String: Any] {
  var credentialManifestDictinary = [String: Any]()
  credentialManifestDictinary["jwt"] = ["encodedJwt": credentialManifest.jwt.encodedJwt]
  credentialManifestDictinary["did"] = credentialManifest.did
  credentialManifestDictinary["iss"] = credentialManifest.iss
  credentialManifestDictinary["exchangeId"] = credentialManifest.exchangeId
  credentialManifestDictinary["vendorOriginContext"] = credentialManifest.vendorOriginContext
  credentialManifestDictinary["verifiedProfile"] = credentialManifest.verifiedProfile.payload
  credentialManifestDictinary["deepLink"] = deepLinkToDictionary(credentialManifest.deepLink)
  credentialManifestDictinary["didJwk"] = didJwkToDictionary(credentialManifest.didJwk)
  credentialManifestDictinary["remoteCryptoServicesToken"] = tokenToDictionary(credentialManifest.remoteCryptoServicesToken)
  return credentialManifestDictinary
}

func dictionaryToCredentialManifest(
    _ credentialManifestDictionary: [String: Any]?
) -> VCLCredentialManifest {
  let jwt = VCLJwt(encodedJwt: (credentialManifestDictionary?["jwt"] as? [String: Any])?["encodedJwt"] as? String ?? "")
  let vendorOriginContext = credentialManifestDictionary?["vendorOriginContext"] as? String
  let verifiedProfileDictionary = credentialManifestDictionary?["verifiedProfile"] as? [String: Any]
  let deepLink = dictionaryToDeepLink(credentialManifestDictionary?["deepLink"] as? [String: Any])
  let didJwk = dictionaryToDidJwk(credentialManifestDictionary?["didJwk"] as? [String: Any])
  let remoteCryptoServicesToken = dictionaryToToken(credentialManifestDictionary?["remoteCryptoServicesToken"] as? [String: Any])

  return VCLCredentialManifest(
    jwt: jwt,
    vendorOriginContext: vendorOriginContext,
    verifiedProfile: VCLVerifiedProfile(payload: verifiedProfileDictionary ?? [:]),
    deepLink: deepLink,
    didJwk: didJwk,
    remoteCryptoServicesToken: remoteCryptoServicesToken
  )
}

func dictionaryToGenerateOffersDescriptor(
    _ generateOffersDescriptorDictionary: [String: Any]
) -> VCLGenerateOffersDescriptor {
  let verifiableCredentialsArr = generateOffersDescriptorDictionary["identificationVerifiableCredentials"] as? [Any]
  var verifiableCredentialsList: [VCLVerifiableCredential]? = nil
  if let verifiableCredentials = verifiableCredentialsArr {
    verifiableCredentialsList = [VCLVerifiableCredential]()
    for i in 0..<verifiableCredentials.count {
      let verifiableCredentialDict = verifiableCredentials[i] as? [String: String]
      verifiableCredentialsList?.append(
        VCLVerifiableCredential(
          inputDescriptor: verifiableCredentialDict?["inputDescriptor"] ?? "",
          jwtVc: verifiableCredentialDict?["jwtVc"] ?? ""
        )
      )
    }
  }
  return VCLGenerateOffersDescriptor(
    credentialManifest: dictionaryToCredentialManifest(generateOffersDescriptorDictionary["credentialManifest"] as? [String: Any]),
    types: generateOffersDescriptorDictionary["types"] as? [String],
    offerHashes: generateOffersDescriptorDictionary["offerHashes"] as? [String],
    identificationVerifiableCredentials: verifiableCredentialsList
  )
}

func offersToDictionary(_ offers: VCLOffers) -> [String: Any] {
  var offersDictionary = [String: Any]()
  offersDictionary["payload"] = offers.payload
  offersDictionary["all"] = allOffersToArray(offers.all)
  offersDictionary["responseCode"] = offers.responseCode
  offersDictionary["sessionToken"] = tokenToDictionary(offers.sessionToken)
  offersDictionary["challenge"] = offers.challenge
  return offersDictionary
}

func dictionaryToOffers(_ offersDictionary: [String : Any]?) -> VCLOffers {
  return VCLOffers(
    payload: offersDictionary?["payload"] as? [String: Any] ?? [String: Any](),
    all: arrayToAllOffers(offersDictionary!["all"] as? [[String : Any]]),
    responseCode: offersDictionary?["responseCode"] as? Int ?? 0,
    sessionToken: dictionaryToToken(offersDictionary?["sessionToken"] as? [String: Any]),
    challenge: offersDictionary?["challenge"] as? String ?? ""
  )
}

func arrayToAllOffers(_ allOffersArray: [[String : Any]]?) -> [VCLOffer] {
  return allOffersArray?.map {
    VCLOffer(payload: $0["payload"] as? [String : Any] ?? [:])
  } ?? [VCLOffer(payload: [:])]
}

func allOffersToArray(_ allOffers: [VCLOffer]?) -> [[String : Any]]? {
  return allOffers?.map { [
    "payload": $0.payload,
    "issuerId": $0.issuerId,
    "id": $0.id
  ] }
}

func credentialTypesFormSchemaToDictionary(
    _ credentialTypesFormSchema: VCLCredentialTypesUIFormSchema
) -> [String: Any] {
  var credentialTypesFormSchemaDictionary = [String: Any]()
  credentialTypesFormSchemaDictionary["payload"] = credentialTypesFormSchema.payload
  return credentialTypesFormSchemaDictionary
}

func dictionaryToJwt(
    _ jwtDictionary: [String: Any]?
) -> VCLJwt {
  return VCLJwt(encodedJwt: jwtDictionary?["encodedJwt"] as? String ?? "")
}

func jwtToDictionary(_ jwt: VCLJwt) -> [String: Any?] {
  return [
    "encodedJwt": jwt.encodedJwt,
    "header": jwt.header,
    "payload": jwt.payload,
    "signature": jwt.signature
  ]
}

func dictionaryToPublicJwk(
    _ publicJwkDictionary: [String: Any]?
) -> VCLPublicJwk {
  return VCLPublicJwk(valueStr: (publicJwkDictionary?["valueStr"] as? String ?? ""))
}

func publicJwkToDictionary(
    _ publicJwk: VCLPublicJwk?
) -> [String: Any] {
  return ["valueStr": publicJwk?.valueStr ?? ""]
}

func dictionaryToFinalizedOffersDescriptor(
    _ finalizedOffersDescriptorDictionary: [String: Any]
) -> VCLFinalizeOffersDescriptor {
  return VCLFinalizeOffersDescriptor(
    credentialManifest: dictionaryToCredentialManifest(finalizedOffersDescriptorDictionary["credentialManifest"] as? [String : Any]),
    challenge: finalizedOffersDescriptorDictionary["challenge"] as? String,
    approvedOfferIds: finalizedOffersDescriptorDictionary["approvedOfferIds"] as? [String] ?? [String](),
    rejectedOfferIds: finalizedOffersDescriptorDictionary["rejectedOfferIds"] as? [String] ?? [String]()
  )
}

func jwtVerifiableCredentialsToDictionary(
    _ jwtVerifiableCredentials: VCLJwtVerifiableCredentials
) -> [String: Any] {
  var jwtVerifiableCredentialsDictionary = [String: Any]()
  let passedCredentials = jwtVerifiableCredentials.passedCredentials.map {
    jwtToDictionary($0)
  }
  let failedCredentials = jwtVerifiableCredentials.failedCredentials.map {
    jwtToDictionary($0)
  }
  jwtVerifiableCredentialsDictionary["passedCredentials"] = passedCredentials
  jwtVerifiableCredentialsDictionary["failedCredentials"] = failedCredentials
  return jwtVerifiableCredentialsDictionary
}

func dictionaryToAuthTokenDescriptor(
  _ authTokenDescriptorDictionary: [String: Any]
) -> VCLAuthTokenDescriptor {
  if let presentationRequestDictionary = authTokenDescriptorDictionary["presentationRequest"] as? [String: Any] {
    return VCLAuthTokenDescriptor(presentationRequest: dictionaryToPresentationRequest(presentationRequestDictionary))
  }
  return VCLAuthTokenDescriptor(
    authTokenUri: authTokenDescriptorDictionary["authTokenUri"] as? String ?? "",
    refreshToken: dictionaryToToken(authTokenDescriptorDictionary["refreshToken"] as? [String : Any]),
    walletDid: authTokenDescriptorDictionary["walletDid"] as? String,
    relyingPartyDid: authTokenDescriptorDictionary["relyingPartyDid"] as? String,
    authorizationCode: authTokenDescriptorDictionary["authorizationCode"] as? String
  )
}

func authTokenToDictionary(
  _ authToken: VCLAuthToken
) -> [String: Any] {
  var authTokenDictionary = [String: Any]()
  authTokenDictionary["payload"] = authToken.payload
  authTokenDictionary["authTokenUri"] = authToken.authTokenUri
  authTokenDictionary["refreshToken"] = tokenToDictionary(authToken.refreshToken)
  authTokenDictionary["walletDid"] = authToken.walletDid
  authTokenDictionary["relyingPartyDid"] = authToken.relyingPartyDid
  return authTokenDictionary
}

func dictionaryToAuthToken(_ authTokenDictionary: [String: Any]) -> VCLAuthToken {
  return VCLAuthToken(
    payload: authTokenDictionary["payload"] as? [String: Any] ?? [:],
    authTokenUri: authTokenDictionary["authTokenUri"] as? String,
    walletDid: authTokenDictionary["walletDid"] as? String,
    relyingPartyDid: authTokenDictionary["relyingPartyDid"] as? String
  )
}

func readableMapToCredentialTypesUIFormSchemaDescriptor(
    _ credentialTypesUIFormSchemaDescriptorDictionary: [String: Any]
) -> VCLCredentialTypesUIFormSchemaDescriptor {
  return VCLCredentialTypesUIFormSchemaDescriptor(
    credentialType: credentialTypesUIFormSchemaDescriptorDictionary["credentialType"] as? String ?? "",
    countryCode: credentialTypesUIFormSchemaDescriptorDictionary["countryCode"] as? String ?? ""
  )
}

func dictionaryToVerifiedProfileDescriptor(
    _ verifiedProfileDescriptor: [String: Any]
) -> VCLVerifiedProfileDescriptor {
  return VCLVerifiedProfileDescriptor(did: (verifiedProfileDescriptor["did"] as? String) ?? "")
}

func verifiedProfileToDictionary(
    _ verifiedProfile: VCLVerifiedProfile
) -> [String: Any] {
  var verifiedProfileDictionary = [String: Any]()
  verifiedProfileDictionary["payload"] = verifiedProfile.payload
  verifiedProfileDictionary["id"] = verifiedProfile.id
  verifiedProfileDictionary["logo"] = verifiedProfile.logo
  verifiedProfileDictionary["name"] = verifiedProfile.name
  return verifiedProfileDictionary
}

func dictionaryToVerifiedProfile(
    _ verifiedProfileDictionary: [String: Any]?
) -> VCLVerifiedProfile {
  return VCLVerifiedProfile(payload: verifiedProfileDictionary?["payload"] as? [String : Any] ?? [String : Any]())
}

func dictionaryToJwtDescriptor(
    _ jwtDescriptorDictionary: [String: Any]
) -> VCLJwtDescriptor {
  return VCLJwtDescriptor(
    payload: jwtDescriptorDictionary["payload"] as? [String: Any] ?? [String: Any](),
    jti: jwtDescriptorDictionary["jti"] as? String ?? "",
    iss: jwtDescriptorDictionary["iss"] as? String ?? ""
  )
}

func didJwkToDictionary(_ didJwk: VCLDidJwk) -> [String: Any] {
  return [
    "did": didJwk.did,
    "publicJwk": publicJwkToDictionary(didJwk.publicJwk),
    "kid": didJwk.kid,
    "keyId": didJwk.keyId
  ]
}

func dictionaryToDidJwk(_ didJwkDictionary: [String: Any]?) -> VCLDidJwk {
  return VCLDidJwk(
    did: didJwkDictionary?["did"] as? String ?? "",
    publicJwk: dictionaryToPublicJwk(didJwkDictionary?["publicJwk"] as? [String : Any]),
    kid: didJwkDictionary?["kid"] as? String ?? "",
    keyId: didJwkDictionary?["keyId"] as? String ?? ""
  )
}

func dictionaryToDidJwkDescriptor(_ didJwkDescriptorDictionary: [String: Any]?) -> VCLDidJwkDescriptor {
  return VCLDidJwkDescriptor(
    signatureAlgorithm: VCLSignatureAlgorithm.fromString(value: didJwkDescriptorDictionary?["signatureAlgorithm"] as? String ?? ""),
    remoteCryptoServicesToken: dictionaryToToken(didJwkDescriptorDictionary?["remoteCryptoServicesToken"] as? [String: Any])
  )
}
