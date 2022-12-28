/**
 * Created by Michael Avoyan.
 *
 * Copyright 2022 Velocity Career Labs inc.
 * SPDX-License-Identifier: Apache-2.0
 */

import type { Dictionary } from '../Dictionary';

export interface VCLJwtDescriptor {
  payload: Dictionary<any>;
  iss: string;
  jti: string;
}
