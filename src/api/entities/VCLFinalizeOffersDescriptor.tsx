import type { VCLCredentialManifest } from './VCLCredentialManifest';

export interface VCLFinalizeOffersDescriptor {
  credentialManifest: VCLCredentialManifest;
  rejectedOfferIds: string[];
  approvedOfferIds: string[];
}
