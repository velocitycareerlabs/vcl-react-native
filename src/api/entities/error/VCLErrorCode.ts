/**
 * Created by Michael Avoyan.
 *
 * Copyright 2022 Velocity Career Labs inc.
 * SPDX-License-Identifier: Apache-2.0
 */

export enum VCLErrorCode {
  // Initialization
  RemoteServicesUrlsNotFound = 'remote_services_urls_not_found',
  InjectedServicesNotFound = 'injected_services_not_found',

  // Credential issuer verification error codes:
  CredentialTypeNotRegistered = 'credential_type_not_registered',
  IssuerRequiresIdentityPermission = 'issuer_requires_identity_permission',
  IssuerRequiresNotaryPermission = 'issuer_requires_notary_permission',
  CredentialSubjectContextMissing = 'credential_subject_context_missing',
  InvalidCredentialSubjectType = 'invalid_credential_subject_type',
  InvalidCredentialSubjectContext = 'invalid_credential_subject_context',
  IssuerUnexpectedPermissionFailure = 'issuer_unexpected_permission_failure',
  // DID consistent with the Deep Link
  MismatchedRequestIssuerDid = 'mismatched_request_issuer_did',
  MismatchedOfferIssuerDid = 'mismatched_offer_issuer_did',
  MismatchedCredentialIssuerDid = 'mismatched_credential_issuer_did',
  MismatchedPresentationRequestInspectorDid = 'mismatched_presentation_request_inspector_did',
  // Error taxonomy
  InvalidLink = 'invalid_link',
  ConnectivityFailure = 'connectivity_failure',
  ClientRequestUnauthorized = 'client_request_unauthorized',
  ClientRequestRejected = 'client_request_rejected',
  IssuerDidUnresolvable = 'issuer_did_unresolvable',
  VerifierDidUnresolvable = 'verifier_did_unresolvable',
  RegistrationCheckInconclusive = 'registration_check_inconclusive',
  IssuerNotRegistered = 'issuer_not_registered',
  VerifierNotRegistered = 'verifier_not_registered',
  IssuerRequestInvalid = 'issuer_request_invalid',
  VerifierRequestInvalid = 'verifier_request_invalid',
  IssuerRequestUnauthorized = 'issuer_request_unauthorized',
  VerifierRequestUnauthorized = 'verifier_request_unauthorized',
  // General error
  SdkError = 'sdk_error',
}
