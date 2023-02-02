/**
 * Created by Michael Avoyan.
 *
 * Copyright 2022 Velocity Career Labs inc.
 * SPDX-License-Identifier: Apache-2.0
 */

import type { Dictionary } from '../Dictionary';
import type { VCLServiceCredentialAgentIssuer } from './VCLServiceCredentialAgentIssuer';

export interface VCLOrganization {
  payload: Dictionary<any>;
  serviceCredentialAgentIssuers: VCLServiceCredentialAgentIssuer[];
}
