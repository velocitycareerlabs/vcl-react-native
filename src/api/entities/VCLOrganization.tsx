import type { Dictionary } from '../Dictionary';
import type { VCLServiceCredentialAgentIssuer } from './VCLServiceCredentialAgentIssuer';

export interface VCLOrganization {
  payload: Dictionary<string>;
  serviceCredentialAgentIssuers: VCLServiceCredentialAgentIssuer[];
}
