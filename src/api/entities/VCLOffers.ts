/**
 * Created by Michael Avoyan.
 *
 * Copyright 2022 Velocity Career Labs inc.
 * SPDX-License-Identifier: Apache-2.0
 */

import type { Dictionary } from '../Dictionary';
import type { VCLOffer } from './VCLOffer';
import type { VCLToken } from './VCLToken';

export interface VCLOffers {
  payload: Dictionary<any>;
  all: [VCLOffer];
  responseCode: number;
  sessionToken: VCLToken;
  challenge: string;
}
