/**
 * Created by Michael Avoyan.
 *
 * Copyright 2022 Velocity Career Labs inc.
 * SPDX-License-Identifier: Apache-2.0
 */

import type { VCLJwt } from './VCLJwt';
import type { VCLPublicJwk } from './VCLPublicJwk';

export interface VCLPresentationRequest {
  exchangeId: string;
  jwt: VCLJwt;
  publicJwk: VCLPublicJwk;
  keyID: string;
  presentationDefinitionId: string;
  iss: string;
}
