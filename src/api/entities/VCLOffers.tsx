import type { Dictionary } from '../Dictionary';
import type { VCLToken } from './VCLToken';

export interface VCLOffers {
  all: Dictionary<string>[];
  responseCode: number;
  token: VCLToken;
}
