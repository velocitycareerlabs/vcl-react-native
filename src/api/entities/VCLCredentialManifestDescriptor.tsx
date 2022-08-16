import type { VCLPushDelegate } from './VCLPushDelegate';

export interface VCLCredentialManifestDescriptor {
  credentialTypes?: string[];
  pushDelegate?: VCLPushDelegate;
}
