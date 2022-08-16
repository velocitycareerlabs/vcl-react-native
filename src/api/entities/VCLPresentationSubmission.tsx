import type { VCLPresentationRequest } from './VCLPresentationRequest';
import type { VCLVerifiableCredential } from './VCLVerifiableCredential';

export interface VCLPresentationSubmission {
  presentationRequest: VCLPresentationRequest;
  verifiableCredentials: VCLVerifiableCredential[];
}
