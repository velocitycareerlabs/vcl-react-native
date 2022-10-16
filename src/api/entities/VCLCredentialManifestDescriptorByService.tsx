/**
 * Created by Michael Avoyan.
 *
 * Copyright 2022 Velocity Career Labs inc.
 * SPDX-License-Identifier: Apache-2.0
 */

import type { VCLCredentialManifestDescriptor } from './VCLCredentialManifestDescriptor';
import type { VCLService } from './VCLService';

export interface VCLCredentialManifestDescriptorByService
  extends VCLCredentialManifestDescriptor {
  service: VCLService;
}
