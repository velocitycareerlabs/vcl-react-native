import type { VCLServiceType } from './VCLServiceType';

export interface VCLFilter {
  did?: string;
  serviceTypes?: VCLServiceType[];
  credentialTypes?: string[];
}
