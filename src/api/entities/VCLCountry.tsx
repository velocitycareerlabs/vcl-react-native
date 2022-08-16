import type { Dictionary } from '../Dictionary';
import type { VCLRegions } from './VCLRegions';

export interface VCLCountry {
  payload: Dictionary<string>;
  code: string;
  name: string;
  regions: VCLRegions;
}
