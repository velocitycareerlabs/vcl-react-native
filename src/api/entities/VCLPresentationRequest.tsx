import type { VCLJWT } from './VCLJWT';
import type { VCLPublicKey } from './VCLPublicKey';

export interface VCLPresentationRequest {
  exchangeId: string;
  jwt: VCLJWT;
  publicKey: VCLPublicKey;
  keyID: string;
  presentationDefinitionId: string;
  iss: string;
}
