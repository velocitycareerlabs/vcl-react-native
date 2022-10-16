/**
 * Created by Michael Avoyan.
 *
 * Copyright 2022 Velocity Career Labs inc.
 * SPDX-License-Identifier: Apache-2.0
 */

import type { VCLServiceType } from './VCLServiceType';

export interface VCLFilter {
  did?: string;
  serviceTypes?: VCLServiceType[];
  credentialTypes?: string[];
}
