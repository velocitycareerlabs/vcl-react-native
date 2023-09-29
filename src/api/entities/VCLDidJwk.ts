/**
 * Created by Michael Avoyan.
 *
 * Copyright 2022 Velocity Career Labs inc.
 * SPDX-License-Identifier: Apache-2.0
 */

import type { VCLPublicJwk } from './VCLPublicJwk';

export interface VCLDidJwk {
  /**
   * The did:jwk
   */
  did: string;
  /**
   * public JWK
   */
  publicJwk: VCLPublicJwk;
  /**
   * kid of jwt - did:jwk suffixed with #0
   */
  kid: string;
  /**
   * The id of private key save in secure enclave
   */
  keyId: string;
}
