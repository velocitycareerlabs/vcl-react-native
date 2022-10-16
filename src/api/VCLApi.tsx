/**
 * Created by Michael Avoyan.
 *
 * Copyright 2022 Velocity Career Labs inc.
 * SPDX-License-Identifier: Apache-2.0
 */

import type { VCLCredentialManifest } from './entities/VCLCredentialManifest';
import type { VCLCredentialManifestDescriptor } from './entities/VCLCredentialManifestDescriptor';
import type { VCLCredentialType } from './entities/VCLCredentialType';
import type { VCLCredentialTypeSchemas } from './entities/VCLCredentialTypeSchemas';
import type { VCLCredentialTypesUIFormSchema } from './entities/VCLCredentialTypesUIFormSchema';
import type { VCLCredentialTypesUIFormSchemaDescriptor } from './entities/VCLCredentialTypesUIFormSchemaDescriptor';
import type { VCLDeepLink } from './entities/VCLDeepLink';
import type { VCLEnvironment } from './VCLEnvironment';
import type { VCLExchange } from './entities/VCLExchange';
import type { VCLExchangeDescriptor } from './entities/VCLExchangeDescriptor';
import type { VCLFinalizeOffersDescriptor } from './entities/VCLFinalizeOffersDescriptor';
import type { VCLGenerateOffersDescriptor } from './entities/VCLGenerateOffersDescriptor';
import type { VCLJWT } from './entities/VCLJWT';
import type { VCLJwtVerifiableCredentials } from './entities/VCLJwtVerifiableCredentials';
import type { VCLOffers } from './entities/VCLOffers';
import type { VCLOrganizations } from './entities/VCLOrganizations';
import type { VCLOrganizationsSearchDescriptor } from './entities/VCLOrganizationsSearchDescriptor';
import type { VCLPresentationRequest } from './entities/VCLPresentationRequest';
import type { VCLPresentationSubmission } from './entities/VCLPresentationSubmission';
import type { VCLPresentationSubmissionResult } from './entities/VCLPresentationSubmissionResult';
import type { VCLPublicKey } from './entities/VCLPublicKey';
import type { VCLToken } from './entities/VCLToken';
import type { VCLVerifiedProfile } from './entities/VCLVerifiedProfile';
import type { VCLVerifiedProfileDescriptor } from './entities/VCLVerifiedProfileDescriptor';
import type { VCLCountries } from './entities/VCLCountries';
import type { Dictionary } from './Dictionary';

export type VclApi = {
  initialize(environment: VCLEnvironment): Promise<void>;

  getCountries(): Promise<VCLCountries>;
  getCredentialTypeSchemas(): Promise<VCLCredentialTypeSchemas>;
  getCredentialTypes(): Promise<Array<VCLCredentialType>>;

  getPresentationRequest(
    deepLink: VCLDeepLink
  ): Promise<VCLPresentationRequest>;

  submitPresentation(
    presentationSubmission: VCLPresentationSubmission
  ): Promise<VCLPresentationSubmissionResult>;

  getExchangeProgress(
    exchangeDescriptor: VCLExchangeDescriptor
  ): Promise<VCLExchange>;

  searchForOrganizations(
    organizationsSearchDescriptor: VCLOrganizationsSearchDescriptor
  ): Promise<VCLOrganizations>;

  getCredentialManifest(
    credentialManifestDescriptor: VCLCredentialManifestDescriptor
  ): Promise<VCLCredentialManifest>;

  generateOffers(
    generateOffersDescriptor: VCLGenerateOffersDescriptor
  ): Promise<VCLOffers>;

  checkForOffers(
    generateOffersDescriptor: VCLGenerateOffersDescriptor,
    token: VCLToken
  ): Promise<VCLOffers>;

  finalizeOffers(
    finalizeOffersDescriptor: VCLFinalizeOffersDescriptor,
    token: VCLToken
  ): Promise<VCLJwtVerifiableCredentials>;

  getCredentialTypesUIFormSchema(
    credentialTypesUIFormSchemaDescriptor: VCLCredentialTypesUIFormSchemaDescriptor
  ): Promise<VCLCredentialTypesUIFormSchema>;

  getVerifiedProfile(
    verifiedProfileDescriptor: VCLVerifiedProfileDescriptor
  ): Promise<VCLVerifiedProfile>;

  verifyJwt(jwt: VCLJWT, publicKey: VCLPublicKey): Promise<boolean>;

  generateSignedJwt(payload: Dictionary<any>, iss: string): Promise<VCLJWT>;
};
