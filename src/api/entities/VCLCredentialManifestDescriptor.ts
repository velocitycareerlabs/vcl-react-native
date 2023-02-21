/**
 * Created by Michael Avoyan.
 *
 * Copyright 2022 Velocity Career Labs inc.
 * SPDX-License-Identifier: Apache-2.0
 */

import type { VCLPushDelegate } from './VCLPushDelegate';
import type { VCLIssuingType } from './VCLIssuingType';

export interface VCLCredentialManifestDescriptor {
  issuingType?: VCLIssuingType;
  credentialTypes?: string[];
  pushDelegate?: VCLPushDelegate;
}
