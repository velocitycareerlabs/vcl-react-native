/**
 * Created by Michael Avoyan.
 *
 * Copyright 2022 Velocity Career Labs inc.
 * SPDX-License-Identifier: Apache-2.0
 */

import type { VCLPresentationSubmission } from './VCLPresentationSubmission';
import type { VCLSubmissionResult } from './VCLSubmissionResult';

export interface VCLExchangeDescriptor {
  presentationSubmission: VCLPresentationSubmission;
  submissionResult: VCLSubmissionResult;
}
