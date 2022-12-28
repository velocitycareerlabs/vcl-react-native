/**
 * Created by Michael Avoyan.
 *
 * Copyright 2022 Velocity Career Labs inc.
 * SPDX-License-Identifier: Apache-2.0
 */

import type { VCLJWT } from './VCLJWT';
import type { VCLJwkPublic } from './VCLJwkPublic';

export interface VCLPresentationRequest {
  exchangeId: string;
  jwt: VCLJWT;
  jwkPublic: VCLJwkPublic;
  keyID: string;
  presentationDefinitionId: string;
  iss: string;
}
