import type { VCLPresentationSubmission } from './VCLPresentationSubmission';
import type { VCLSubmissionResult } from './VCLSubmissionResult';

export interface VCLExchangeDescriptor {
  presentationSubmission: VCLPresentationSubmission;
  submissionResult: VCLSubmissionResult;
}
