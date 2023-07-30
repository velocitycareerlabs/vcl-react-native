/**
 * Created by Michael Avoyan.
 *
 * Copyright 2022 Velocity Career Labs inc.
 * SPDX-License-Identifier: Apache-2.0
 */

export enum VCLErrorCode {
  // Credential issuer verification error codes:
  CredentialTypeNotRegistered = 'credential_type_not_registered',
  IssuerRequiresIdentityPermission = 'issuer_requires_identity_permission',
  IssuerRequiresNotaryPermission = 'issuer_requires_notary_permission',
  CredentialSubjectContextMissing = 'credential_subject_context_missing',
  InvalidCredentialSubjectType = 'invalid_credential_subject_type',
  InvalidCredentialSubjectContext = 'invalid_credential_subject_context',
  IssuerUnexpectedPermissionFailure = 'issuer_unexpected_permission_failure',
}
