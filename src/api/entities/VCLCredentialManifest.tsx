import type { VCLJWT } from './VCLJWT';

export interface VCLCredentialManifest {
  jwt: VCLJWT;
  iss: string;
  did: string;
  exchangeId: string;
  presentationDefinitionId: string;
}
