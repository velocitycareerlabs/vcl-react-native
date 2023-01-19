/**
 * Created by Michael Avoyan.
 *
 * Copyright 2022 Velocity Career Labs inc.
 * SPDX-License-Identifier: Apache-2.0
 */

import type { Dictionary } from '../Dictionary';
import type { VCLRegions } from './VCLRegions';

export interface VCLCountry {
  payload: Dictionary<any>;
  code: string;
  name: string;
  regions: VCLRegions;
}
