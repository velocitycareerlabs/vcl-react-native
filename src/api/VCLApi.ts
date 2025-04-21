/**
 * Created by Michael Avoyan.
 *
 * Copyright 2022 Velocity Career Labs inc.
 * SPDX-License-Identifier: Apache-2.0
 */

import { NativeModules } from 'react-native';
import {
  type VCLAuthToken,
  type VCLAuthTokenDescriptor,
  type VCLCredentialManifest,
  type VCLCredentialManifestDescriptor,
  type VCLCredentialTypeSchemas,
  type VCLCredentialTypesUIFormSchema,
  type VCLCredentialTypesUIFormSchemaDescriptor,
  type VCLExchange,
  type VCLExchangeDescriptor,
  type VCLFinalizeOffersDescriptor,
  type VCLGenerateOffersDescriptor,
  type VCLJwt,
  type VCLJwtVerifiableCredentials,
  type VCLOffers,
  type VCLOrganizations,
  type VCLOrganizationsSearchDescriptor,
  type VCLPresentationRequest,
  type VCLPresentationSubmission,
  type VCLPublicJwk,
  type VCLToken,
  type VCLVerifiedProfile,
  type VCLVerifiedProfileDescriptor,
  type VCLCountries,
  type VCLInitializationDescriptor,
  type VCLSubmissionResult,
  type VCLPresentationRequestDescriptor,
  type VCLJwtDescriptor,
  type VCLDidJwk,
  type VCLCredentialTypes,
  type VCLDidJwkDescriptor,
  VCLError,
} from '@velocitycareerlabs/vcl-react-native';

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
    authToken?: VCLAuthToken
  ): Promise<VCLSubmissionResult> => {
    try {
      return await VclReactNative.submitPresentation(presentationSubmission, authToken);
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
    generateOffersDescriptor: VCLGenerateOffersDescriptor
  ): Promise<VCLOffers> => {
    try {
      return await VclReactNative.generateOffers(generateOffersDescriptor);
    } catch (e) {
      throw new VCLError(e);
    }
  },

  checkForOffers: async (
    generateOffersDescriptor: VCLGenerateOffersDescriptor,
    sessionToken: VCLToken
  ): Promise<VCLOffers> => {
    try {
      return await VclReactNative.checkForOffers(
        generateOffersDescriptor,
        sessionToken
      );
    } catch (e) {
      throw new VCLError(e);
    }
  },

  finalizeOffers: async (
    finalizeOffersDescriptor: VCLFinalizeOffersDescriptor,
    sessionToken: VCLToken
  ): Promise<VCLJwtVerifiableCredentials> => {
    try {
      return await VclReactNative.finalizeOffers(
        finalizeOffersDescriptor,
        sessionToken
      );
    } catch (e) {
      throw new VCLError(e);
    }
  },

  getAuthToken: async (
    authTokenDescriptor: VCLAuthTokenDescriptor,
  ): Promise<VCLAuthToken> => {
    try {
      return await VclReactNative.getAuthToken(authTokenDescriptor);
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

  verifyJwt: async (
    jwt: VCLJwt,
    jwkPublic: VCLPublicJwk,
    remoteCryptoServicesToken?: VCLToken
  ): Promise<boolean> => {
    try {
      return await VclReactNative.verifyJwt(
        jwt,
        jwkPublic,
        remoteCryptoServicesToken
      );
    } catch (e) {
      throw new VCLError(e);
    }
  },

  generateSignedJwt: async (
    jwtDescriptor: VCLJwtDescriptor,
    didJwk: VCLDidJwk,
    remoteCryptoServicesToken?: VCLToken
  ): Promise<VCLJwt> => {
    try {
      return await VclReactNative.generateSignedJwt(
        jwtDescriptor,
        didJwk,
        remoteCryptoServicesToken
      );
    } catch (e) {
      throw new VCLError(e);
    }
  },

  generateDidJwk: async (
    didJwkDescriptor: VCLDidJwkDescriptor
  ): Promise<VCLDidJwk> => {
    try {
      return await VclReactNative.generateDidJwk(didJwkDescriptor);
    } catch (e) {
      throw new VCLError(e);
    }
  },
};
