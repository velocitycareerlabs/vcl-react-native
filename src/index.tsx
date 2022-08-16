import { NativeModules } from 'react-native';
import type { VclApi } from './api/VCLApi';
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
import type { VCLCredentialTypeSchema } from './api/entities/VCLCredentialTypeSchema';
import type { VCLCredentialTypeSchemas } from './api/entities/VCLCredentialTypeSchemas';
import type { VCLCredentialTypesUIFormSchemaDescriptor } from './api/entities/VCLCredentialTypesUIFormSchemaDescriptor';
import type { VCLCredentialTypesUIFormSchema } from './api/entities/VCLCredentialTypesUIFormSchema';
import type { VCLDeepLink } from './api/entities/VCLDeepLink';
import type { VCLError } from './api/entities/VCLError';
import type { VCLExchange } from './api/entities/VCLExchange';
import type { VCLExchangeDescriptor } from './api/entities/VCLExchangeDescriptor';
import type { VCLFilter } from './api/entities/VCLFilter';
import type { VCLFinalizeOffersDescriptor } from './api/entities/VCLFinalizeOffersDescriptor';
import type { VCLGenerateOffersDescriptor } from './api/entities/VCLGenerateOffersDescriptor';
import type { VCLJWT } from './api/entities/VCLJWT';
import type { VCLJwtVerifiableCredentials } from './api/entities/VCLJwtVerifiableCredentials';
import type { VCLOffers } from './api/entities/VCLOffers';
import type { VCLOrganization } from './api/entities/VCLOrganization';
import type { VCLOrganizations } from './api/entities/VCLOrganizations';
import type { VCLOrganizationsSearchDescriptor } from './api/entities/VCLOrganizationsSearchDescriptor';
import type { VCLPage } from './api/entities/VCLPage';
import type { VCLPresentationRequest } from './api/entities/VCLPresentationRequest';
import type { VCLPresentationSubmission } from './api/entities/VCLPresentationSubmission';
import type { VCLPresentationSubmissionResult } from './api/entities/VCLPresentationSubmissionResult';
import type { VCLPublicKey } from './api/entities/VCLPublicKey';
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

const { VclReactNative } = NativeModules;

export default VclReactNative as VclApi;
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
  VCLCredentialTypeSchema,
  VCLCredentialTypeSchemas,
  VCLCredentialTypesUIFormSchema,
  VCLCredentialTypesUIFormSchemaDescriptor,
  VCLCredentialManifestDescriptorRefresh,
  VCLDeepLink,
  VCLError,
  VCLExchange,
  VCLExchangeDescriptor,
  VCLFilter,
  VCLFinalizeOffersDescriptor,
  VCLGenerateOffersDescriptor,
  VCLJWT,
  VCLJwtVerifiableCredentials,
  VCLOffers,
  VCLOrganization,
  VCLOrganizations,
  VCLOrganizationsSearchDescriptor,
  VCLPage,
  VCLPresentationRequest,
  VCLPresentationSubmission,
  VCLPresentationSubmissionResult,
  VCLPublicKey,
  VCLPushDelegate,
  VCLService,
  VCLServiceCredentialAgentIssuer,
  VCLServiceType,
  VCLSubmissionResult,
  VCLToken,
  VCLVerifiableCredential,
  VCLVerifiedProfile,
  VCLVerifiedProfileDescriptor,
};
