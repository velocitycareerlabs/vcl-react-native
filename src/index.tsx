/**
 * Created by Michael Avoyan.
 *
 * Copyright 2022 Velocity Career Labs inc.
 * SPDX-License-Identifier: Apache-2.0
 */

import { VclApi } from './api/VCLApi';
import type { VCLEnvironment } from './api/VCLEnvironment';
import { VCLEnvTypes } from './api/VCLEnvironment';
import type { VCLCountry } from './api/entities/VCLCountry';
import type { VCLCountries } from './api/entities/VCLCountries';
import { VCLCountryCodes } from './api/entities/VCLCountries';
import type { VCLRegion } from './api/entities/VCLRegion';
import type { VCLRegions } from './api/entities/VCLRegions';
import type { VCLCredentialManifest } from './api/entities/VCLCredentialManifest';
import type { VCLCredentialManifestDescriptor } from './api/entities/VCLCredentialManifestDescriptor';
import type { VCLCredentialManifestDescriptorByDeepLink } from './api/entities/VCLCredentialManifestDescriptorByDeepLink';
import type { VCLCredentialManifestDescriptorByService } from './api/entities/VCLCredentialManifestDescriptorByService';
import type { VCLCredentialManifestDescriptorRefresh } from './api/entities/VCLCredentialManifestDescriptorRefresh';
import type { VCLCredentialType } from './api/entities/VCLCredentialType';
import type { VCLCredentialTypes } from './api/entities/VCLCredentialTypes';
import type { VCLCredentialTypeSchema } from './api/entities/VCLCredentialTypeSchema';
import type { VCLCredentialTypeSchemas } from './api/entities/VCLCredentialTypeSchemas';
import type { VCLCredentialTypesUIFormSchemaDescriptor } from './api/entities/VCLCredentialTypesUIFormSchemaDescriptor';
import type { VCLCredentialTypesUIFormSchema } from './api/entities/VCLCredentialTypesUIFormSchema';
import type { VCLDeepLink } from './api/entities/VCLDeepLink';
import type { VCLExchange } from './api/entities/VCLExchange';
import type { VCLExchangeDescriptor } from './api/entities/VCLExchangeDescriptor';
import type { VCLFilter } from './api/entities/VCLFilter';
import type { VCLFinalizeOffersDescriptor } from './api/entities/VCLFinalizeOffersDescriptor';
import type { VCLGenerateOffersDescriptor } from './api/entities/VCLGenerateOffersDescriptor';
import type { VCLJwt } from './api/entities/VCLJwt';
import type { VCLJwtVerifiableCredentials } from './api/entities/VCLJwtVerifiableCredentials';
import type { VCLOffers } from './api/entities/VCLOffers';
import type { VCLOrganization } from './api/entities/VCLOrganization';
import type { VCLOrganizations } from './api/entities/VCLOrganizations';
import type { VCLOrganizationsSearchDescriptor } from './api/entities/VCLOrganizationsSearchDescriptor';
import type { VCLPage } from './api/entities/VCLPage';
import type { VCLPresentationRequest } from './api/entities/VCLPresentationRequest';
import type { VCLPresentationSubmission } from './api/entities/VCLPresentationSubmission';
import type { VCLJwkPublic } from './api/entities/VCLJwkPublic';
import type { VCLPushDelegate } from './api/entities/VCLPushDelegate';
import type { VCLService } from './api/entities/VCLService';
import type { VCLServiceCredentialAgentIssuer } from './api/entities/VCLServiceCredentialAgentIssuer';
import { VCLServiceType } from './api/entities/VCLServiceType';
import type { VCLSubmissionResult } from './api/entities/VCLSubmissionResult';
import type { VCLToken } from './api/entities/VCLToken';
import type { VCLVerifiableCredential } from './api/entities/VCLVerifiableCredential';
import type { VCLVerifiedProfile } from './api/entities/VCLVerifiedProfile';
import type { VCLVerifiedProfileDescriptor } from './api/entities/VCLVerifiedProfileDescriptor';
import type { Dictionary } from './api/Dictionary';
import type { VCLInitializationDescriptor } from './api/entities/VCLInitializationDescriptor';
import type { VCLPresentationRequestDescriptor } from './api/entities/VCLPresentationRequestDescriptor';
import type { VCLJwtDescriptor } from './api/entities/VCLJwtDescriptor';
import type { VCLDidJwk } from './api/entities/VCLDidJwk';
import { VCLErrorCode } from './api/entities/VCLErrorCode';
import type { VCLError, toVclError } from './api/entities/VCLError';

export default VclApi;
export {
  Dictionary,
  VCLEnvironment,
  VCLEnvTypes,
  VCLCountry,
  VCLCountries,
  VCLCountryCodes,
  VCLRegion,
  VCLRegions,
  VCLCredentialManifest,
  VCLCredentialManifestDescriptor,
  VCLCredentialManifestDescriptorByDeepLink,
  VCLCredentialManifestDescriptorByService,
  VCLCredentialType,
  VCLCredentialTypes,
  VCLCredentialTypeSchema,
  VCLCredentialTypeSchemas,
  VCLCredentialTypesUIFormSchema,
  VCLCredentialTypesUIFormSchemaDescriptor,
  VCLCredentialManifestDescriptorRefresh,
  VCLDeepLink,
  VCLExchange,
  VCLExchangeDescriptor,
  VCLFilter,
  VCLFinalizeOffersDescriptor,
  VCLGenerateOffersDescriptor,
  VCLJwt,
  VCLJwtVerifiableCredentials,
  VCLOffers,
  VCLOrganization,
  VCLOrganizations,
  VCLOrganizationsSearchDescriptor,
  VCLPage,
  VCLPresentationRequest,
  VCLPresentationSubmission,
  VCLJwkPublic,
  VCLPushDelegate,
  VCLService,
  VCLServiceCredentialAgentIssuer,
  VCLServiceType,
  VCLSubmissionResult,
  VCLToken,
  VCLVerifiableCredential,
  VCLVerifiedProfile,
  VCLVerifiedProfileDescriptor,
  VCLInitializationDescriptor,
  VCLPresentationRequestDescriptor,
  VCLJwtDescriptor,
  VCLDidJwk,
  VCLErrorCode,
  VCLError,
  toVclError,
};
