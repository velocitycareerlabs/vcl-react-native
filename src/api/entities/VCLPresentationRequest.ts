/**
 * Created by Michael Avoyan.
 *
 * Copyright 2022 Velocity Career Labs inc.
 * SPDX-License-Identifier: Apache-2.0
 */

import type { VCLDidJwk } from './VCLDidJwk';
import type { VCLJwt } from './VCLJwt';
import type { VCLToken } from './VCLToken';
import type { VCLVerifiedProfile } from './VCLVerifiedProfile';

export interface VCLPresentationRequest {
  exchangeId: string;
  jwt: VCLJwt;
  verifiedProfile: VCLVerifiedProfile;
  keyID: string;
  presentationDefinitionId: string;
  iss: string;
  didJwk: VCLDidJwk;
  remoteCryptoServicesToken?: VCLToken;
}
