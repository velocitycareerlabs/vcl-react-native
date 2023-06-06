/**
 * Created by Michael Avoyan.
 *
 * Copyright 2022 Velocity Career Labs inc.
 * SPDX-License-Identifier: Apache-2.0
 */

import type { VCLCredentialManifest } from './VCLCredentialManifest';
import type { VCLOffers } from './VCLOffers';

export interface VCLFinalizeOffersDescriptor {
  credentialManifest: VCLCredentialManifest;
  offers: VCLOffers;
  rejectedOfferIds: string[];
  approvedOfferIds: string[];
}
