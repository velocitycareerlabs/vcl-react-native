/**
 * Created by Michael Avoyan.
 *
 * Copyright 2022 Velocity Career Labs inc.
 * SPDX-License-Identifier: Apache-2.0
 */

import type { VCLServiceTypes } from './VCLServiceTypes';
import type { Dictionary } from '../Dictionary';

export interface VCLVerifiedProfile {
  payload: Dictionary<string>;
  credentialSubject: Dictionary<string>;
  name: string;
  logo: string;
  id: string;
  serviceTypes: VCLServiceTypes;
}
