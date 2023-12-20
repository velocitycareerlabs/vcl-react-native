/**
 * Created by Michael Avoyan.
 *
 * Copyright 2022 Velocity Career Labs inc.
 * SPDX-License-Identifier: Apache-2.0
 */

import type { Dictionary } from '../Dictionary';

export interface VCLOffer {
  payload: Dictionary<any>;
  issuerId: string;
  id: string;
}
