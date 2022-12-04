/**
 * Created by Michael Avoyan.
 *
 * Copyright 2022 Velocity Career Labs inc.
 * SPDX-License-Identifier: Apache-2.0
 */

import type { VCLCredentialManifest } from './VCLCredentialManifest';

export interface VCLFinalizeOffersDescriptor {
  credentialManifest: VCLCredentialManifest;
  rejectedOfferIds: string[];
  approvedOfferIds: string[];
}
