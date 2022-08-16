import type { Dictionary } from '../Dictionary';

export interface VCLRegion {
  payload: Dictionary<string>;
  code: string;
  name: string;
}
