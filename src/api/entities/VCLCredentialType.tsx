import type { Dictionary } from '../Dictionary';

export interface VCLCredentialType {
  payload: Dictionary<string>;
  id: string;
  schema: string;
  createdAt: string;
  schemaName: string;
  credentialType: string;
  recommended: boolean;
}
