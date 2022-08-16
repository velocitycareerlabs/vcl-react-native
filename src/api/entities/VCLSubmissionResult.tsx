import type { VCLExchange } from './VCLExchange';
import type { VCLToken } from './VCLToken';

export interface VCLSubmissionResult {
  token: VCLToken;
  exchange: VCLExchange;
}
