import type { VCLCredentialManifest } from './VCLCredentialManifest';
import type { VCLVerifiableCredential } from './VCLVerifiableCredential';

export interface VCLGenerateOffersDescriptor {
  credentialManifest: VCLCredentialManifest;
  types?: string[];
  offerHashes?: string[];
  identificationVerifiableCredentials: VCLVerifiableCredential[];
}
