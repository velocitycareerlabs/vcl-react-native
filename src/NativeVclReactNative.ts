import { TurboModuleRegistry, type TurboModule } from 'react-native';

export interface Spec extends TurboModule {
  initialize(initializationDescriptor: unknown): Promise<void>;

  getCountries(): Promise<unknown>;

  getCredentialTypes(): Promise<unknown>;

  getCredentialTypeSchemas(): Promise<unknown>;

  getPresentationRequest(
    presentationRequestDescriptor: unknown
  ): Promise<unknown>;

  submitPresentation(
    presentationSubmission: unknown,
    authToken?: unknown
  ): Promise<unknown>;

  getExchangeProgress(exchangeDescriptor: unknown): Promise<unknown>;

  searchForOrganizations(
    organizationsSearchDescriptor: unknown
  ): Promise<unknown>;

  getCredentialManifest(
    credentialManifestDescriptor: unknown
  ): Promise<unknown>;

  generateOffers(generateOffersDescriptor: unknown): Promise<unknown>;

  checkForOffers(
    generateOffersDescriptor: unknown,
    sessionToken: unknown
  ): Promise<unknown>;

  finalizeOffers(
    finalizeOffersDescriptor: unknown,
    sessionToken: unknown
  ): Promise<unknown>;

  getAuthToken(authTokenDescriptor: unknown): Promise<unknown>;

  getCredentialTypesUIFormSchema(
    credentialTypesUIFormSchemaDescriptor: unknown
  ): Promise<unknown>;

  getVerifiedProfile(verifiedProfileDescriptor: unknown): Promise<unknown>;

  verifyJwt(
    jwt: unknown,
    jwkPublic: unknown,
    remoteCryptoServicesToken?: unknown
  ): Promise<boolean>;

  generateSignedJwt(
    jwtDescriptor: unknown,
    didJwk: unknown,
    remoteCryptoServicesToken?: unknown
  ): Promise<unknown>;

  generateDidJwk(didJwkDescriptor: unknown): Promise<unknown>;
}

export default TurboModuleRegistry.getEnforcing<Spec>('VclReactNative');
