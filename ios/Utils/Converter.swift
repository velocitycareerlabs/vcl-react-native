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
    _ initializationDescriptorDictionary: [String: Sendable]
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
      initializationDescriptorDictionary["cryptoServicesDescriptor"] as? [String : Sendable]
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
  _ cryptoServicesDescriptorDictionary: [String: Sendable]?
) -> VCLCryptoServicesDescriptor {
  let cryptoServiceType =
  VCLCryptoServiceType.fromString(
    value: cryptoServicesDescriptorDictionary?["cryptoServiceType"] as? String ?? ""
  )
  let remoteCryptoServicesUrlsDescriptorDictionary = cryptoServicesDescriptorDictionary?["remoteCryptoServicesUrlsDescriptor"] as? [String: Sendable]
  let keyServiceUrls = remoteCryptoServicesUrlsDescriptorDictionary?["keyServiceUrls"] as? [String: Sendable]
  let jwtServiceUrls = remoteCryptoServicesUrlsDescriptorDictionary?["jwtServiceUrls"] as? [String: Sendable]
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
) -> [String: Sendable] {
  var regionDict = [String: Sendable]()
  regionDict["payload"] = region.payload
  regionDict["code"] = region.code
  regionDict["name"] = region.name
  return regionDict
}

func regionsToDictionary(
    _ regions: VCLRegions
) -> [String: Sendable] {
  var regionsMap = [String: Sendable]()
  var regionsArr = [[String: Sendable]]()
  for i in 0..<regions.all.count {
    regionsArr.append(regionToDictionary(regions.all[i]))
  }
  regionsMap["all"] = regionsArr
  return regionsMap
}

func countryToDictionary(
    _ country: VCLCountry
) -> [String: Sendable] {
  var countryDict = [String: Sendable]()
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
) -> [String: [[String: Sendable]?]] {
  var countriesArr = [[String: Sendable]?] ()
  if let all = countries.all {
    for i in 0..<all.count {
      countriesArr.append(countryToDictionary(all[i]))
    }
  }
  return ["all": countriesArr]
}

func credentialTypeSchemasToDictionary(
    _ credentialTypeSchemas: VCLCredentialTypeSchemas
) -> [String: [String: Sendable]]  {
  var credentialTypeSchemasMap = [String: [String: Sendable]]()
  if let all = credentialTypeSchemas.all {
    for (key, credentialTypeSchema) in all {
      var credentialTypeSchemaDictionary = [String: Sendable]()
      credentialTypeSchemaDictionary["payload"] = credentialTypeSchema.payload
      credentialTypeSchemasMap[key] = credentialTypeSchemaDictionary
    }
  }
  return ["all": credentialTypeSchemasMap]
}

func credentialTypesToDictionary(
    _ credentialTypes: VCLCredentialTypes
) -> [String: [[String: Sendable?]]]  {
  var credentialTypesArray = [[String: Sendable?]]()
  var recommendedCredentialTypesArray = [[String: Sendable?]]()
  if let all = credentialTypes.all {
    credentialTypesArray = parseCredentialTypesArray(all)
  }
  if let recommendedTypes = credentialTypes.recommendedTypes {
    recommendedCredentialTypesArray = parseCredentialTypesArray(recommendedTypes)
  }
  return ["all": credentialTypesArray, "recommendedTypes": recommendedCredentialTypesArray]
}

private func parseCredentialTypesArray(_ credentialTypesArr: [VCLCredentialType]) -> [[String: Sendable?]] {
  var credentialTypesArray = [[String: Sendable?]]()
  credentialTypesArr.forEach {
    var credentialType = [String: Sendable?]()
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
    _ presentationRequestDescriptorLinkDictionary: [String: Sendable]
) -> VCLPresentationRequestDescriptor {
  return VCLPresentationRequestDescriptor(
    deepLink: dictionaryToDeepLink(presentationRequestDescriptorLinkDictionary["deepLink"] as? [String: Sendable]) ?? VCLDeepLink(value: ""),
    pushDelegate: dictionaryToPushDelegate(presentationRequestDescriptorLinkDictionary["pushDelegate"] as? [String: Sendable]),
    didJwk: dictionaryToDidJwk(presentationRequestDescriptorLinkDictionary["didJwk"] as? [String: Sendable]),
    remoteCryptoServicesToken: dictionaryToToken(
      presentationRequestDescriptorLinkDictionary["remoteCryptoServicesToken"] as? [String: Sendable]
    )
  )
}

func dictionaryToDeepLink(_ deepLinkDictionary: [String: Sendable]?) -> VCLDeepLink? {
  if let value = deepLinkDictionary?["value"] as? String {
    return VCLDeepLink(value: value)
  }
  return nil
}

func deepLinkToDictionary(_ deepLink: VCLDeepLink?) -> [String: Sendable]? {
  if let value = deepLink?.value {
    return ["value": value]
  }
  return nil
}

func dictionaryToToken(_ tokenDictionary: [String: Sendable]?) -> VCLToken {
  return VCLToken(value: tokenDictionary?["value"] as? String ?? "")
}

func tokenToDictionary(_ token: VCLToken?) -> [String: Sendable] {
  var retVal = [String: Sendable]()
  retVal["value"] = token?.value
  if let expiresIn = token?.expiresIn {
    retVal["expiresIn"] = expiresIn
  }
  return retVal
}

func dictionaryToIssuingType(
    issuingTypeDictionary: [String: Sendable],
    defaultIssuingType: VCLIssuingType
) -> VCLIssuingType {
  if let issuingType = issuingTypeDictionary["issuingType"] as? String {
    return VCLIssuingType.fromString(value: issuingType)
  }
  return defaultIssuingType
}

func dictionaryToPresentationRequest(
    _ presentationRequestDictionary: [String: Sendable]?
) -> VCLPresentationRequest {
  return VCLPresentationRequest(
    jwt: dictionaryToJwt(presentationRequestDictionary?["jwt"] as? [String : Sendable]),
    verifiedProfile: dictionaryToVerifiedProfile(presentationRequestDictionary?["verifiedProfile"] as? [String: Sendable]),
    deepLink: dictionaryToDeepLink(presentationRequestDictionary?["deepLink"] as? [String : Sendable]) ?? VCLDeepLink(value: ""),
    pushDelegate: dictionaryToPushDelegate(presentationRequestDictionary?["pushDelegate"] as? [String : Sendable]),
    didJwk: dictionaryToDidJwk(presentationRequestDictionary?["didJwk"] as? [String : Sendable]),
    remoteCryptoServicesToken: dictionaryToToken(presentationRequestDictionary?["remoteCryptoServicesToken"] as? [String : Sendable])
  )
}

func presentationRequestToDictionary(
    _ presentationRequest: VCLPresentationRequest
) -> [String: Sendable] {
  var presentationRequestDictionary = [String: Sendable]()
  presentationRequestDictionary["jwt"] = ["encodedJwt": presentationRequest.jwt.encodedJwt]
  presentationRequestDictionary["verifiedProfile"] = verifiedProfileToDictionary(presentationRequest.verifiedProfile)
  presentationRequestDictionary["iss"] = presentationRequest.iss
  presentationRequestDictionary["exchangeId"] = presentationRequest.exchangeId
  presentationRequestDictionary["presentationDefinitionId"] = presentationRequest.presentationDefinitionId
  presentationRequestDictionary["deepLink"] = deepLinkToDictionary(presentationRequest.deepLink)
  presentationRequestDictionary["didJwk"] = didJwkToDictionary(presentationRequest.didJwk)
  presentationRequestDictionary["remoteCryptoServicesToken"] = tokenToDictionary(presentationRequest.remoteCryptoServicesToken)
  return presentationRequestDictionary
}

func dictionaryToPresentationSubmission(
    _ presentationSubmissionDictionary: [String: Sendable]?
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
    presentationRequest: dictionaryToPresentationRequest(presentationSubmissionDictionary?["presentationRequest"] as? [String: Sendable]),
    verifiableCredentials: verifiableCredentialsList
  )
}

func presentationSubmissionResultToDictionary(
    _ presentationSubmissionResult: VCLSubmissionResult
) -> [String: Sendable] {
  var presentationSubmissionResulDictionary = [String: Sendable]()
  presentationSubmissionResulDictionary[VCLSubmissionResult.CodingKeys.KeyToken] = tokenToDictionary(presentationSubmissionResult.sessionToken)
  presentationSubmissionResulDictionary[VCLSubmissionResult.CodingKeys.KeyExchange] = exchangeToDictionary(presentationSubmissionResult.exchange)
  presentationSubmissionResulDictionary[VCLSubmissionResult.CodingKeys.KeyJti] = presentationSubmissionResult.jti
  presentationSubmissionResulDictionary[VCLSubmissionResult.CodingKeys.KeySubmissionId] = presentationSubmissionResult.submissionId
  return presentationSubmissionResulDictionary
}

func exchangeToDictionary(
    _ exchange: VCLExchange?
) -> [String: Sendable] {
  var exchangeDictionary = [String: Sendable]()
  exchangeDictionary["id"] = exchange?.id
  exchangeDictionary["type"] = exchange?.type
  exchangeDictionary["disclosureComplete"] = exchange?.disclosureComplete
  exchangeDictionary["exchangeComplete"] = exchange?.exchangeComplete
  return exchangeDictionary
}

func dictionaryToSubmissionResult(_ submissionResultDictionary: [String: Sendable]?) -> VCLSubmissionResult {
  return VCLSubmissionResult(
    sessionToken: dictionaryToToken(submissionResultDictionary?[VCLSubmissionResult.CodingKeys.KeyToken] as? [String: Sendable]),
    exchange: dictionaryToExchange(submissionResultDictionary?[VCLSubmissionResult.CodingKeys.KeyExchange] as? [String: Sendable]),
    jti: submissionResultDictionary?[VCLSubmissionResult.CodingKeys.KeyJti] as? String ?? "",
    submissionId: submissionResultDictionary?[VCLSubmissionResult.CodingKeys.KeySubmissionId] as? String ?? ""
  )
}

func dictionaryToExchange(
    _ exchangeReadableMap: [String: Sendable]?
) -> VCLExchange {
  return VCLExchange(
    id: exchangeReadableMap?["id"] as? String ?? "",
    type: exchangeReadableMap?["type"] as? String  ?? "",
    disclosureComplete: exchangeReadableMap?["disclosureComplete"] as? Bool ?? false,
    exchangeComplete: exchangeReadableMap?["exchangeComplete"] as? Bool ?? false
  )
}

func dictionaryToExchangeDescriptor(
    _ exchangeDescriptorDictionary: [String: Sendable]?
) -> VCLExchangeDescriptor {
  return VCLExchangeDescriptor(
    presentationSubmission: dictionaryToPresentationSubmission(exchangeDescriptorDictionary?["presentationSubmission"] as? [String: Sendable]),
    submissionResult: dictionaryToSubmissionResult(exchangeDescriptorDictionary?["submissionResult"] as? [String: Sendable])
  )
}

func dictionayToOrganizationsSearchDescriptor(
    _ organizationsDescriptorDictionary: [String: Sendable]
) -> VCLOrganizationsSearchDescriptor {
  return VCLOrganizationsSearchDescriptor(
    filter: dictionaryToFilter(organizationsDescriptorDictionary["filter"] as? [String : Sendable]),
    page: dictionaryToPage(organizationsDescriptorDictionary["page"] as? [String : Sendable]),
    sort: organizationsDescriptorDictionary["sort"] as? [[String]],
    query: organizationsDescriptorDictionary["query"] as? String
  )
}

func dictionaryToFilter(
    _ filterDictionary: [String: Sendable]?
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

func dictionaryToPage(_ pageDictionary: [String: Sendable]?) -> VCLPage {
  return VCLPage(
    size: pageDictionary?["size"] as? String,
    skip: pageDictionary?["skip"] as? String
  )
}

func organizationsToDictionary(
    _ organizations: VCLOrganizations
) -> [String: Sendable] {
  var organizationsMap = [String: Sendable]()
  var organizationsArr = [[String: Sendable]]()
  organizations.all.forEach { organization in
    var organizationMap = [String: Sendable]()
    organizationMap["payload"] = organization.payload
    var serviceCredentialAgentIssuersArr = [[String: Sendable]]()
    organization.serviceCredentialAgentIssuers.forEach { service in
      var serviceCredentialAgentIssuerMap = [String: Sendable]()
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
    organizationMap["payload"] = organization.payload
    organizationsArr.append(organizationMap)
  }
  organizationsMap["all"] = organizationsArr
  return organizationsMap
}

func dictionaryToPushDelegate(_ pushDelegateMap: [String: Sendable]?) -> VCLPushDelegate? {
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
    _ credentialManifestDescriptorDictionary: [String: Sendable]
) -> VCLCredentialManifestDescriptor? {
  if (credentialManifestDescriptorDictionary["deepLink"] != nil) {
    return dictionaryToCredentialManifestDescriptorByDeepLink(credentialManifestDescriptorDictionary)
  } else if (credentialManifestDescriptorDictionary["service"] != nil) {
    if(credentialManifestDescriptorDictionary["credentialIds"] != nil) {
      return dictionaryToCredentialManifestDescriptorRefresh(credentialManifestDescriptorDictionary)
    } else {
      return dictionaryToCredentialManifestDescriptorByService(credentialManifestDescriptorDictionary)
    }
  }
  return nil
}

func dictionaryToCredentialManifestDescriptorByDeepLink(
    _ credentialManifestDescriptorByDeepLinkDictionary: [String: Sendable]
) -> VCLCredentialManifestDescriptorByDeepLink {
  return VCLCredentialManifestDescriptorByDeepLink(
    deepLink: dictionaryToDeepLink(
      credentialManifestDescriptorByDeepLinkDictionary["deepLink"] as? [String : Sendable]
    ) ?? VCLDeepLink(value: ""),
    issuingType: dictionaryToIssuingType(
      issuingTypeDictionary: credentialManifestDescriptorByDeepLinkDictionary,
      defaultIssuingType: VCLIssuingType.Career
    ),
    pushDelegate: dictionaryToPushDelegate(credentialManifestDescriptorByDeepLinkDictionary["pushDelegate"] as? [String: Sendable]),
    didJwk: dictionaryToDidJwk(credentialManifestDescriptorByDeepLinkDictionary["didJwk"] as? [String: Sendable]),
    remoteCryptoServicesToken: dictionaryToToken(
      credentialManifestDescriptorByDeepLinkDictionary["remoteCryptoServicesToken"] as? [String: Sendable]
    )
  )
}

func dictionaryToCredentialManifestDescriptorByService(
    _ credentialManifestDescriptorByServiceDictionary: [String: Sendable]
) -> VCLCredentialManifestDescriptorByService {
  return VCLCredentialManifestDescriptorByService(
    service: dictionaryToService(
      credentialManifestDescriptorByServiceDictionary["service"] as? [String : Sendable]
    ),
    issuingType: dictionaryToIssuingType(
      issuingTypeDictionary: credentialManifestDescriptorByServiceDictionary,
      defaultIssuingType: VCLIssuingType.Career
    ),
    credentialTypes: credentialManifestDescriptorByServiceDictionary["credentialTypes"] as? [String],
    pushDelegate: dictionaryToPushDelegate(
      credentialManifestDescriptorByServiceDictionary["pushDelegate"] as? [String: Sendable]
    ),
    didJwk: dictionaryToDidJwk(credentialManifestDescriptorByServiceDictionary["didJwk"] as? [String: Sendable]),
    remoteCryptoServicesToken: dictionaryToToken(
      credentialManifestDescriptorByServiceDictionary["remoteCryptoServicesToken"] as? [String: Sendable]
    )
  )
}

func dictionaryToCredentialManifestDescriptorRefresh(
    _ credentialManifestDescriptorRefreshDictionary: [String: Sendable]
) -> VCLCredentialManifestDescriptorRefresh {
  return VCLCredentialManifestDescriptorRefresh(
    service: dictionaryToService(
      credentialManifestDescriptorRefreshDictionary["service"] as? [String : Sendable]
    ),
    credentialIds: credentialManifestDescriptorRefreshDictionary["credentialIds"] as? [String] ?? [],
    didJwk: dictionaryToDidJwk(credentialManifestDescriptorRefreshDictionary["didJwk"] as? [String: Sendable]),
    remoteCryptoServicesToken: dictionaryToToken(
      credentialManifestDescriptorRefreshDictionary["remoteCryptoServicesToken"] as? [String: Sendable]
    )
  )
}

func dictionaryToService(
    _ serviceDictionary: [String: Sendable]?
) -> VCLService {
  return VCLService(payload: serviceDictionary?["payload"] as? [String : Sendable] ?? [:])
}

func credentialManifestToDictionary(
    _ credentialManifest: VCLCredentialManifest
) -> [String: Sendable] {
  var credentialManifestDictinary = [String: Sendable]()
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
    _ credentialManifestDictionary: [String: Sendable]?
) -> VCLCredentialManifest {
  let jwt = VCLJwt(encodedJwt: (credentialManifestDictionary?["jwt"] as? [String: Sendable])?["encodedJwt"] as? String ?? "")
  let vendorOriginContext = credentialManifestDictionary?["vendorOriginContext"] as? String
  let verifiedProfileDictionary = credentialManifestDictionary?["verifiedProfile"] as? [String: Sendable]
  let deepLink = dictionaryToDeepLink(credentialManifestDictionary?["deepLink"] as? [String: Sendable])
  let didJwk = dictionaryToDidJwk(credentialManifestDictionary?["didJwk"] as? [String: Sendable])
  let remoteCryptoServicesToken = dictionaryToToken(credentialManifestDictionary?["remoteCryptoServicesToken"] as? [String: Sendable])
  
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
    _ generateOffersDescriptorDictionary: [String: Sendable]
) -> VCLGenerateOffersDescriptor {
  let verifiableCredentialsArr = generateOffersDescriptorDictionary["identificationVerifiableCredentials"] as? [Sendable]
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
    credentialManifest: dictionaryToCredentialManifest(generateOffersDescriptorDictionary["credentialManifest"] as? [String: Sendable]),
    types: generateOffersDescriptorDictionary["types"] as? [String],
    offerHashes: generateOffersDescriptorDictionary["offerHashes"] as? [String],
    identificationVerifiableCredentials: verifiableCredentialsList
  )
}

func offersToDictionary(_ offers: VCLOffers) -> [String: Sendable] {
  var offersDictionary = [String: Sendable]()
  offersDictionary["payload"] = offers.payload
  offersDictionary["all"] = allOffersToArray(offers.all)
  offersDictionary["responseCode"] = offers.responseCode
  offersDictionary["sessionToken"] = tokenToDictionary(offers.sessionToken)
  offersDictionary["challenge"] = offers.challenge
  return offersDictionary
}

func dictionaryToOffers(_ offersDictionary: [String : Sendable]?) -> VCLOffers {
  return VCLOffers(
    payload: offersDictionary?["payload"] as? [String: Sendable] ?? [String: Sendable](),
    all: arrayToAllOffers(offersDictionary!["all"] as? [[String : Sendable]]),
    responseCode: offersDictionary?["responseCode"] as? Int ?? 0,
    sessionToken: dictionaryToToken(offersDictionary?["sessionToken"] as? [String: Sendable]),
    challenge: offersDictionary?["challenge"] as? String ?? ""
  )
}

func arrayToAllOffers(_ allOffersArray: [[String : Sendable]]?) -> [VCLOffer] {
  return allOffersArray?.map {
    VCLOffer(payload: $0["payload"] as? [String : Sendable] ?? [:])
  } ?? [VCLOffer(payload: [:])]
}

func allOffersToArray(_ allOffers: [VCLOffer]?) -> [[String : Sendable]]? {
  return allOffers?.map { [
    "payload": $0.payload,
    "issuerId": $0.issuerId,
    "id": $0.id
  ] }
}

func credentialTypesFormSchemaToDictionary(
    _ credentialTypesFormSchema: VCLCredentialTypesUIFormSchema
) -> [String: Sendable] {
  var credentialTypesFormSchemaDictionary = [String: Sendable]()
  credentialTypesFormSchemaDictionary["payload"] = credentialTypesFormSchema.payload
  return credentialTypesFormSchemaDictionary
}

func dictionaryToJwt(
    _ jwtDictionary: [String: Sendable]?
) -> VCLJwt {
  return VCLJwt(encodedJwt: jwtDictionary?["encodedJwt"] as? String ?? "")
}

func jwtToDictionary(_ jwt: VCLJwt) -> [String: Sendable?] {
  return [
    "encodedJwt": jwt.encodedJwt,
    "header": jwt.header,
    "payload": jwt.payload,
    "signature": jwt.signature
  ]
}

func dictionaryToPublicJwk(
    _ publicJwkDictionary: [String: Sendable]?
) -> VCLPublicJwk {
  return VCLPublicJwk(valueStr: (publicJwkDictionary?["valueStr"] as? String ?? ""))
}

func publicJwkToDictionary(
    _ publicJwk: VCLPublicJwk?
) -> [String: Sendable] {
  return ["valueStr": publicJwk?.valueStr ?? ""]
}

func dictionaryToFinalizedOffersDescriptor(
    _ finalizedOffersDescriptorDictionary: [String: Sendable]
) -> VCLFinalizeOffersDescriptor {
  return VCLFinalizeOffersDescriptor(
    credentialManifest: dictionaryToCredentialManifest(finalizedOffersDescriptorDictionary["credentialManifest"] as? [String : Sendable]),
    challenge: finalizedOffersDescriptorDictionary["challenge"] as? String,
    approvedOfferIds: finalizedOffersDescriptorDictionary["approvedOfferIds"] as? [String] ?? [String](),
    rejectedOfferIds: finalizedOffersDescriptorDictionary["rejectedOfferIds"] as? [String] ?? [String]()
  )
}

func jwtVerifiableCredentialsToDictionary(
    _ jwtVerifiableCredentials: VCLJwtVerifiableCredentials
) -> [String: Sendable] {
  var jwtVerifiableCredentialsDictionary = [String: Sendable]()
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

func readableMapToCredentialTypesUIFormSchemaDescriptor(
    _ credentialTypesUIFormSchemaDescriptorDictionary: [String: Sendable]
) -> VCLCredentialTypesUIFormSchemaDescriptor {
  return VCLCredentialTypesUIFormSchemaDescriptor(
    credentialType: credentialTypesUIFormSchemaDescriptorDictionary["credentialType"] as? String ?? "",
    countryCode: credentialTypesUIFormSchemaDescriptorDictionary["countryCode"] as? String ?? ""
  )
}

func dictionaryToVerifiedProfileDescriptor(
    _ verifiedProfileDescriptor: [String: Sendable]
) -> VCLVerifiedProfileDescriptor {
  return VCLVerifiedProfileDescriptor(did: (verifiedProfileDescriptor["did"] as? String) ?? "")
}

func verifiedProfileToDictionary(
    _ verifiedProfile: VCLVerifiedProfile
) -> [String: Sendable] {
  var verifiedProfileDictionary = [String: Sendable]()
  verifiedProfileDictionary["payload"] = verifiedProfile.payload
  verifiedProfileDictionary["id"] = verifiedProfile.id
  verifiedProfileDictionary["logo"] = verifiedProfile.logo
  verifiedProfileDictionary["name"] = verifiedProfile.name
  return verifiedProfileDictionary
}

func dictionaryToVerifiedProfile(
    _ verifiedProfileDictionary: [String: Sendable]?
) -> VCLVerifiedProfile {
  return VCLVerifiedProfile(payload: verifiedProfileDictionary?["payload"] as? [String : Sendable] ?? [String : Sendable]())
}

func dictionaryToJwtDescriptor(
    _ jwtDescriptorDictionary: [String: Sendable]
) -> VCLJwtDescriptor {
  return VCLJwtDescriptor(
    payload: jwtDescriptorDictionary["payload"] as? [String: Sendable] ?? [String: Sendable](),
    jti: jwtDescriptorDictionary["jti"] as? String ?? "",
    iss: jwtDescriptorDictionary["iss"] as? String ?? ""
  )
}

func didJwkToDictionary(_ didJwk: VCLDidJwk) -> [String: Sendable] {
  return [
    "did": didJwk.did,
    "publicJwk": publicJwkToDictionary(didJwk.publicJwk),
    "kid": didJwk.kid,
    "keyId": didJwk.keyId
  ]
}

func dictionaryToDidJwk(_ didJwkDictionary: [String: Sendable]?) -> VCLDidJwk {
  return VCLDidJwk(
    did: didJwkDictionary?["did"] as? String ?? "",
    publicJwk: dictionaryToPublicJwk(didJwkDictionary?["publicJwk"] as? [String : Sendable]),
    kid: didJwkDictionary?["kid"] as? String ?? "",
    keyId: didJwkDictionary?["keyId"] as? String ?? ""
  )
}

func dictionaryToDidJwkDescriptor(_ didJwkDescriptorDictionary: [String: Sendable]?) -> VCLDidJwkDescriptor {
  return VCLDidJwkDescriptor(
    signatureAlgorithm: VCLSignatureAlgorithm.fromString(value: didJwkDescriptorDictionary?["signatureAlgorithm"] as? String ?? ""),
    remoteCryptoServicesToken: dictionaryToToken(didJwkDescriptorDictionary?["remoteCryptoServicesToken"] as? [String: Sendable])
  )
}
