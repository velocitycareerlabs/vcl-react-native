import type { VCLCredentialManifestDescriptor } from './VCLCredentialManifestDescriptor';
import type { VCLDeepLink } from './VCLDeepLink';

export interface VCLCredentialManifestDescriptorByDeepLink
  extends VCLCredentialManifestDescriptor {
  deepLink: VCLDeepLink;
}
