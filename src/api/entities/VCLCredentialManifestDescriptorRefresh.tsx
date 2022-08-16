import type { VCLCredentialManifestDescriptor } from './VCLCredentialManifestDescriptor';
import type { VCLService } from './VCLService';

export interface VCLCredentialManifestDescriptorRefresh
  extends VCLCredentialManifestDescriptor {
  service: VCLService;
  credentialIds: string[];
}
