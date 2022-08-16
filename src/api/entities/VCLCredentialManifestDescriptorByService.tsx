import type { VCLCredentialManifestDescriptor } from './VCLCredentialManifestDescriptor';
import type { VCLService } from './VCLService';

export interface VCLCredentialManifestDescriptorByService
  extends VCLCredentialManifestDescriptor {
  service: VCLService;
}
