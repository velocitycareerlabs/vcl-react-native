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
        keyServiceType: dictionaryToKeyServiceType(
            initializationDescriptorDictionary["keyServiceType"] as? String
            ),
        xVnfProtocolVersion: dictionaryToXVnfProtocolVersion (
            initializationDescriptorDictionary["xVnfProtocolVersion"] as? String
        ),
        cacheSequence: initializationDescriptorDictionary["cacheSequence"] as? Int ?? 0
    )
}

private func dictionaryToEnvironment(
    _ environment: String?
) -> VCLEnvironment {
    switch environment {
    case VCLEnvironment.Dev.rawValue:
        return VCLEnvironment.Dev
    case VCLEnvironment.Qa.rawValue:
        return VCLEnvironment.Qa
    case VCLEnvironment.Staging.rawValue:
        return VCLEnvironment.Staging
    case VCLEnvironment.Prod.rawValue:
        return VCLEnvironment.Prod
    default:
        return VCLEnvironment.Prod
    }
}

private func dictionaryToKeyServiceType(
    _ keyServiceType: String?
) -> VCLKeyServiceType {
    switch keyServiceType {
    case VCLKeyServiceType.Local.rawValue:
        return VCLKeyServiceType.Local
    case VCLKeyServiceType.Remote.rawValue:
        return VCLKeyServiceType.Remote
    default:
        return VCLKeyServiceType.Local
    }
}

private func dictionaryToXVnfProtocolVersion(
    _ xVnfProtocolVersion: String?
) -> VCLXVnfProtocolVersion {
    switch xVnfProtocolVersion {
    case VCLXVnfProtocolVersion.XVnfProtocolVersion1.rawValue:
        return VCLXVnfProtocolVersion.XVnfProtocolVersion1
    case VCLXVnfProtocolVersion.XVnfProtocolVersion2.rawValue:
        return VCLXVnfProtocolVersion.XVnfProtocolVersion2
    default:
        return VCLXVnfProtocolVersion.XVnfProtocolVersion1
    }
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
        credentialTypesArray.append(credentialType)
    }
    return credentialTypesArray
}

func dictionaryTopPresentationRequestDescriptor(
    _ presentationRequestDescriptorLinkDictionary: [String: Any]
) -> VCLPresentationRequestDescriptor {
    return VCLPresentationRequestDescriptor(
        deepLink: dictionaryToDeepLink(presentationRequestDescriptorLinkDictionary["deepLink"] as? [String: Any]),
        pushDelegate: dictionaryToPushDelegate(presentationRequestDescriptorLinkDictionary["pushDelegate"] as? [String: Any])
    )
}

func dictionaryToDeepLink(_ deepLinkDictionary: [String: Any]?) -> VCLDeepLink {
    return VCLDeepLink(value: deepLinkDictionary?["value"] as? String ?? "")
}

func deepLinkToDictionary(_ deepLink: VCLDeepLink) -> [String: Any] {
    return ["value": deepLink.value]
}

func dictionaryToToken(_ tokenDictionary: [String: Any]?) -> VCLToken {
    return VCLToken(value: tokenDictionary?["value"] as? String ?? "")
}

func tokenToDictionary(_ token: VCLToken) -> [String: Any] {
    return ["value": token.value]
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
        jwkPublic: dictionaryToPJwkPublic(presentationRequestDictionary?["jwkPublic"] as? [String: Any]),
        deepLink: dictionaryToDeepLink(presentationRequestDictionary?["deepLink"] as? [String : Any])
    )
}

func presentationRequestToDictionary(
    _ presentationRequest: VCLPresentationRequest
) -> [String: Any] {
    var presentationRequestDictionary = [String: Any]()
    presentationRequestDictionary["jwt"] = ["encodedJwt": presentationRequest.jwt.encodedJwt]
    var jwkPublicDictionary = [String: Any]()
    jwkPublicDictionary["valueStr"] = presentationRequest.jwkPublic.valueStr
    presentationRequestDictionary["jwkPublic"] = jwkPublicDictionary
    presentationRequestDictionary["iss"] = presentationRequest.iss
    presentationRequestDictionary["exchangeId"] = presentationRequest.exchangeId
    presentationRequestDictionary["presentationDefinitionId"] = presentationRequest.presentationDefinitionId
    presentationRequestDictionary["deepLink"] = deepLinkToDictionary(presentationRequest.deepLink)
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
    presentationSubmissionResulDictionary[VCLSubmissionResult.CodingKeys.KeyToken] = tokenToDictionary(presentationSubmissionResult.token)
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
        token: dictionaryToToken(submissionResultDictionary?["token"] as? [String: Any]),
        exchange: dictionaryToExchange(submissionResultDictionary?["exchange"] as? [String: Any]),
        jti: submissionResultDictionary?["jti"] as? String ?? "",
        submissionId: submissionResultDictionary?["submissionId"] as? String ?? ""
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
    var serviceTypes: VCLServiceTypes? = serviceTypesList != nil ? VCLServiceTypes(all: serviceTypesList ?? [VCLServiceType]()) : nil
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
    _ credentialManifestDescriptorByDeepLinkDictionary: [String: Any]
) -> VCLCredentialManifestDescriptorByDeepLink {
    return VCLCredentialManifestDescriptorByDeepLink(
        deepLink: dictionaryToDeepLink(
            credentialManifestDescriptorByDeepLinkDictionary["deepLink"] as? [String : Any]
        ),
        issuingType: dictionaryToIssuingType(
            issuingTypeDictionary: credentialManifestDescriptorByDeepLinkDictionary,
            defaultIssuingType: VCLIssuingType.Career
        )
    )
}

func dictionaryToCredentialManifestDescriptorByService(
    _ credentialManifestDescriptorByServiceDictionary: [String: Any]
) -> VCLCredentialManifestDescriptorByService {
    let pushDelegateDictionary = credentialManifestDescriptorByServiceDictionary["pushDelegate"] as? [String: Any]
    let pushDelegate = dictionaryToPushDelegate(pushDelegateDictionary)
    return VCLCredentialManifestDescriptorByService(
        service: dictionaryToServiceCredentialAgentIssuer(
            credentialManifestDescriptorByServiceDictionary["service"] as? [String : Any]
        ),
        issuingType: dictionaryToIssuingType(
            issuingTypeDictionary: credentialManifestDescriptorByServiceDictionary,
            defaultIssuingType: VCLIssuingType.Career
        ),
        credentialTypes: credentialManifestDescriptorByServiceDictionary["credentialTypes"] as? [String],
        pushDelegate: pushDelegate
    )
}

func dictionaryToCredentialManifestDescriptorRefresh(
    _ credentialManifestDescriptorRefreshDictionary: [String: Any]
) -> VCLCredentialManifestDescriptorRefresh {
    return VCLCredentialManifestDescriptorRefresh(
        service: dictionaryToServiceCredentialAgentIssuer(
            credentialManifestDescriptorRefreshDictionary["service"] as? [String : Any]
        ),
        credentialIds: credentialManifestDescriptorRefreshDictionary["credentialIds"] as? [String] ?? [String]()
    )
}

func dictionaryToServiceCredentialAgentIssuer(
    _ serviceDictionary: [String: Any]?
) -> VCLServiceCredentialAgentIssuer {
    return VCLServiceCredentialAgentIssuer(payload: serviceDictionary?["payload"] as? [String : Any] ?? [String: Any]())
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
    return credentialManifestDictinary
}

func dictionaryToCredentialManifest(
    _ credentialManifestDictionary: [String: Any]?
) -> VCLCredentialManifest {
    let jwt: VCLJwt = VCLJwt(encodedJwt: (credentialManifestDictionary?["jwt"] as? [String: Any])?["encodedJwt"] as? String ?? "")
    let vendorOriginContext: String? = credentialManifestDictionary?["vendorOriginContext"] as? String
    let verifiedProfileDictionary: [String: Any]? = credentialManifestDictionary?["verifiedProfile"] as? [String: Any]
    return VCLCredentialManifest(
        jwt: jwt,
        vendorOriginContext: vendorOriginContext,
        verifiedProfile: VCLVerifiedProfile(payload: verifiedProfileDictionary ?? [:])
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
    offersDictionary["all"] = offers.all
    offersDictionary["responseCode"] = offers.responseCode
    offersDictionary["token"] = tokenToDictionary(offers.token)
    offersDictionary["challenge"] = offers.challenge
    return offersDictionary
}

func dictionaryToOffers(_ offersDictionary: [String : Any]?) -> VCLOffers {
    return VCLOffers(
        payload: offersDictionary?["payload"] as? [String: Any] ?? [String: Any](),
        all: offersDictionary?["all"] as? [[String: Any]] ?? [[String: Any]](),
        responseCode: offersDictionary?["responseCode"] as? Int ?? 0,
        token: dictionaryToToken(offersDictionary?["token"] as? [String: Any]),
        challenge: offersDictionary?["challenge"] as? String ?? ""
    )
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

func dictionaryToPJwkPublic(
    _ jwkPublicDictionary: [String: Any]?
) -> VCLJwkPublic {
    return VCLJwkPublic(valueStr: (jwkPublicDictionary?["valueStr"] as? String ?? ""))
}

func dictionaryToFinalizedOffersDescriptor(
    _ finalizedOffersDescriptorDictionary: [String: Any]
) -> VCLFinalizeOffersDescriptor {
    return VCLFinalizeOffersDescriptor(
        credentialManifest: dictionaryToCredentialManifest(finalizedOffersDescriptorDictionary["credentialManifest"] as? [String : Any]),
        offers: dictionaryToOffers(finalizedOffersDescriptorDictionary["offers"] as? [String : Any]),
        approvedOfferIds: finalizedOffersDescriptorDictionary["approvedOfferIds"] as? [String] ?? [String](),
        rejectedOfferIds: finalizedOffersDescriptorDictionary["rejectedOfferIds"] as? [String] ?? [String]()
    )
}

func jwtVerifiableCredentialsToDictionary(
    _ jwtVerifiableCredentials: VCLJwtVerifiableCredentials
) -> [String: Any] {
    var jwtVerifiableCredentialsDictionary = [String: Any]()
    let passedCredentials = jwtVerifiableCredentials.passedCredentials.map {
        $0.encodedJwt
    }
    let failedCredentials = jwtVerifiableCredentials.failedCredentials.map {
        $0.encodedJwt
    }
    jwtVerifiableCredentialsDictionary["passedCredentials"] = passedCredentials
    jwtVerifiableCredentialsDictionary["failedCredentials"] = failedCredentials
    return jwtVerifiableCredentialsDictionary
}

func jwtToReadableMap(_ jwt: VCLJwt) -> [String: Any] {
    return ["encodedJwt": jwt.encodedJwt]
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

func dictionaryToJwtDescriptor(
    _ jwtDescriptorDictionary: [String: Any]
) -> VCLJwtDescriptor {
    return VCLJwtDescriptor(
        payload: jwtDescriptorDictionary["payload"] as? [String: Any] ?? [String: Any](),
        jti: jwtDescriptorDictionary["jti"] as? String ?? "",
        iss: jwtDescriptorDictionary["iss"] as? String ?? ""
    )
}

func didJwkToDictionary(_ didJwk: VCLDidJwk?) -> [String: Any]? {
    if let didJwk = didJwk {
        return [
            "keyId": didJwk.keyId,
            "value": didJwk.value,
            "kid": didJwk.kid
        ]
    }
    return nil
}

func dictionaryToJwk(_ didJwkDictionary: [String: Any]?) -> VCLDidJwk? {
    if let didJwkDictionary = didJwkDictionary {
        return VCLDidJwk(
            keyId: didJwkDictionary["keyId"] as? String ?? "",
            value: didJwkDictionary["value"] as? String ?? "",
            kid: didJwkDictionary["kid"] as? String ?? ""
        )
    }
    return nil
}
