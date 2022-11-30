/**
 * Created by Michael Avoyan.
 *
 * Copyright 2022 Velocity Career Labs inc.
 * SPDX-License-Identifier: Apache-2.0
 */

import type { Dictionary } from '../Dictionary';
import type { VCLToken } from './VCLToken';

export interface VCLOffers {
  all: Dictionary<string>[];
  responseCode: number;
  token: VCLToken;
}
