/**
 * Created by Michael Avoyan.
 *
 * Copyright 2022 Velocity Career Labs inc.
 * SPDX-License-Identifier: Apache-2.0
 */

import type { VCLPresentationRequest } from './VCLPresentationRequest';
import type { VCLVerifiableCredential } from './VCLVerifiableCredential';

export interface VCLPresentationSubmission {
  presentationRequest: VCLPresentationRequest;
  verifiableCredentials: VCLVerifiableCredential[];
}
