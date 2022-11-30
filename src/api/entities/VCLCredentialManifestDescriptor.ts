/**
 * Created by Michael Avoyan.
 *
 * Copyright 2022 Velocity Career Labs inc.
 * SPDX-License-Identifier: Apache-2.0
 */

import type { VCLPushDelegate } from './VCLPushDelegate';

export interface VCLCredentialManifestDescriptor {
  credentialTypes?: string[];
  pushDelegate?: VCLPushDelegate;
}
