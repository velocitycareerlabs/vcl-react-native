/**
 * Created by Michael Avoyan.
 *
 * Copyright 2022 Velocity Career Labs inc.
 * SPDX-License-Identifier: Apache-2.0
 */

import type { VCLPublicJwk } from './VCLPublicJwk';

export interface VCLDidJwk {
  /**
   * The did in jwk format encoded to Base64 format
   */
  did: string;
  /**
   * The public JWK
   */
  publicJwk: VCLPublicJwk;
  /**
   * The kid of jwt - did:jwk suffixed with #0
   */
  kid: string;
  /**
   * The id of private key save in the key store or secure inclave
   */
  keyId: string;
}
