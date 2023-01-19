/**
 * Created by Michael Avoyan.
 *
 * Copyright 2022 Velocity Career Labs inc.
 * SPDX-License-Identifier: Apache-2.0
 */

import type { Dictionary } from '../Dictionary';

export interface VCLRegion {
  payload: Dictionary<any>;
  code: string;
  name: string;
}
