import type { VCLExchange } from './VCLExchange';
import type { VCLToken } from './VCLToken';

export interface VCLPresentationSubmissionResult {
  token: VCLToken;
  exchange: VCLExchange;
}
