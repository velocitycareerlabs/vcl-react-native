import type { Dictionary } from '../Dictionary';

export interface VCLVerifiedProfile {
  payload: Dictionary<string>;
  credentialSubject: Dictionary<string>;
  name: string;
  logo: string;
  id: string;
}
