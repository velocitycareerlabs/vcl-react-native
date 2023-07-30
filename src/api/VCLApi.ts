/**
 * Created by Michael Avoyan.
 *
 * Copyright 2022 Velocity Career Labs inc.
 * SPDX-License-Identifier: Apache-2.0
 */

import type { VCLCredentialManifest } from './entities/VCLCredentialManifest';
import type { VCLCredentialManifestDescriptor } from './entities/VCLCredentialManifestDescriptor';
import type { VCLCredentialTypeSchemas } from './entities/VCLCredentialTypeSchemas';
import type { VCLCredentialTypesUIFormSchema } from './entities/VCLCredentialTypesUIFormSchema';
import type { VCLCredentialTypesUIFormSchemaDescriptor } from './entities/VCLCredentialTypesUIFormSchemaDescriptor';
import type { VCLExchange } from './entities/VCLExchange';
import type { VCLExchangeDescriptor } from './entities/VCLExchangeDescriptor';
import type { VCLFinalizeOffersDescriptor } from './entities/VCLFinalizeOffersDescriptor';
import type { VCLGenerateOffersDescriptor } from './entities/VCLGenerateOffersDescriptor';
import type { VCLJwt } from './entities/VCLJwt';
import type { VCLJwtVerifiableCredentials } from './entities/VCLJwtVerifiableCredentials';
import type { VCLOffers } from './entities/VCLOffers';
import type { VCLOrganizations } from './entities/VCLOrganizations';
import type { VCLOrganizationsSearchDescriptor } from './entities/VCLOrganizationsSearchDescriptor';
import type { VCLPresentationRequest } from './entities/VCLPresentationRequest';
import type { VCLPresentationSubmission } from './entities/VCLPresentationSubmission';
import type { VCLJwkPublic } from './entities/VCLJwkPublic';
import type { VCLToken } from './entities/VCLToken';
import type { VCLVerifiedProfile } from './entities/VCLVerifiedProfile';
import type { VCLVerifiedProfileDescriptor } from './entities/VCLVerifiedProfileDescriptor';
import type { VCLCountries } from './entities/VCLCountries';
import type { VCLInitializationDescriptor } from './entities/VCLInitializationDescriptor';
import type { VCLSubmissionResult } from './entities/VCLSubmissionResult';
import type { VCLPresentationRequestDescriptor } from './entities/VCLPresentationRequestDescriptor';
import type { VCLJwtDescriptor } from './entities/VCLJwtDescriptor';
import type { VCLDidJwk } from './entities/VCLDidJwk';
import type { VCLCredentialTypes } from './entities/VCLCredentialTypes';

import { NativeModules } from 'react-native';
import { VCLError } from './entities/VCLError';
const { VclReactNative } = NativeModules;

export const VclApi = {
  initialize: async (
    initializationDescriptor: VCLInitializationDescriptor
  ): Promise<void> => {
    try {
      return await VclReactNative.initialize(initializationDescriptor);
    } catch (e) {
      throw new VCLError(e);
    }
  },

  getCountries: async (): Promise<VCLCountries> => {
    try {
      return await VclReactNative.getCountries();
    } catch (e) {
      throw new VCLError(e);
    }
  },

  getCredentialTypes: async (): Promise<VCLCredentialTypes> => {
    try {
      return await VclReactNative.getCredentialTypes();
    } catch (e) {
      throw new VCLError(e);
    }
  },

  getCredentialTypeSchemas: async (): Promise<VCLCredentialTypeSchemas> => {
    try {
      return await VclReactNative.getCredentialTypeSchemas();
    } catch (e) {
      throw new VCLError(e);
    }
  },

  getPresentationRequest: async (
    presentationRequestDescriptor: VCLPresentationRequestDescriptor
  ): Promise<VCLPresentationRequest> => {
    try {
      return await VclReactNative.getPresentationRequest(
        presentationRequestDescriptor
      );
    } catch (e) {
      throw new VCLError(e);
    }
  },

  submitPresentation: async (
    presentationSubmission: VCLPresentationSubmission,
    didJwk?: VCLDidJwk
  ): Promise<VCLSubmissionResult> => {
    try {
      return await VclReactNative.submitPresentation(
        presentationSubmission,
        didJwk
      );
    } catch (e) {
      throw new VCLError(e);
    }
  },

  getExchangeProgress: async (
    exchangeDescriptor: VCLExchangeDescriptor
  ): Promise<VCLExchange> => {
    try {
      return await VclReactNative.getExchangeProgress(exchangeDescriptor);
    } catch (e) {
      throw new VCLError(e);
    }
  },

  searchForOrganizations: async (
    organizationsSearchDescriptor: VCLOrganizationsSearchDescriptor
  ): Promise<VCLOrganizations> => {
    try {
      return await VclReactNative.searchForOrganizations(
        organizationsSearchDescriptor
      );
    } catch (e) {
      throw new VCLError(e);
    }
  },

  getCredentialManifest: async (
    credentialManifestDescriptor: VCLCredentialManifestDescriptor
  ): Promise<VCLCredentialManifest> => {
    try {
      return await VclReactNative.getCredentialManifest(
        credentialManifestDescriptor
      );
    } catch (e) {
      throw new VCLError(e);
    }
  },

  generateOffers: async (
    generateOffersDescriptor: VCLGenerateOffersDescriptor,
    didJwk?: VCLDidJwk
  ): Promise<VCLOffers> => {
    try {
      return await VclReactNative.generateOffers(
        generateOffersDescriptor,
        didJwk
      );
    } catch (e) {
      throw new VCLError(e);
    }
  },

  checkForOffers: async (
    generateOffersDescriptor: VCLGenerateOffersDescriptor,
    token: VCLToken
  ): Promise<VCLOffers> => {
    try {
      return await VclReactNative.checkForOffers(
        generateOffersDescriptor,
        token
      );
    } catch (e) {
      throw new VCLError(e);
    }
  },

  finalizeOffers: async (
    finalizeOffersDescriptor: VCLFinalizeOffersDescriptor,
    token: VCLToken,
    didJwk?: VCLDidJwk
  ): Promise<VCLJwtVerifiableCredentials> => {
    try {
      return await VclReactNative.finalizeOffers(
        finalizeOffersDescriptor,
        didJwk,
        token
      );
    } catch (e) {
      throw new VCLError(e);
    }
  },

  getCredentialTypesUIFormSchema: async (
    credentialTypesUIFormSchemaDescriptor: VCLCredentialTypesUIFormSchemaDescriptor
  ): Promise<VCLCredentialTypesUIFormSchema> => {
    try {
      return await VclReactNative.getCredentialTypesUIFormSchema(
        credentialTypesUIFormSchemaDescriptor
      );
    } catch (e) {
      throw new VCLError(e);
    }
  },

  getVerifiedProfile: async (
    verifiedProfileDescriptor: VCLVerifiedProfileDescriptor
  ): Promise<VCLVerifiedProfile> => {
    try {
      return await VclReactNative.getVerifiedProfile(verifiedProfileDescriptor);
    } catch (e) {
      throw new VCLError(e);
    }
  },

  verifyJwt: async (jwt: VCLJwt, jwkPublic: VCLJwkPublic): Promise<boolean> => {
    try {
      return await VclReactNative.verifyJwt(jwt, jwkPublic);
    } catch (e) {
      throw new VCLError(e);
    }
  },

  generateSignedJwt: async (
    jwtDescriptor: VCLJwtDescriptor
  ): Promise<VCLJwt> => {
    try {
      return await VclReactNative.generateSignedJwt(jwtDescriptor);
    } catch (e) {
      throw new VCLError(e);
    }
  },

  generateDidJwk: async (): Promise<VCLDidJwk> => {
    try {
      return await VclReactNative.generateDidJwk();
    } catch (e) {
      throw new VCLError(e);
    }
  },
};
