/**
 * Created by Michael Avoyan.
 *
 * Copyright 2022 Velocity Career Labs inc.
 * SPDX-License-Identifier: Apache-2.0
 */

import type { VCLExchange } from './VCLExchange';
import type { VCLToken } from './VCLToken';

export interface VCLSubmissionResult {
  sessionToken: VCLToken;
  exchange: VCLExchange;
  jti: string;
  submissionId: string;
}
