/**
 * Created by Michael Avoyan.
 *
 * Copyright 2022 Velocity Career Labs inc.
 * SPDX-License-Identifier: Apache-2.0
 */

import type { VCLSignatureAlgorithm } from '../VCLSignatureAlgorithm';
import type { VCLToken } from './VCLToken';

export interface VCLDidJwkDescriptor {
  /**
   * Signature algorithm of the generated key. Defaults to
   * `VCLSignatureAlgorithm.ES256` (P-256) when omitted. The native bridge also
   * accepts the JWS algorithm names `'ES256'` and `'ES256K'`, and rejects any
   * other value with a `VCLError`.
   */
  signatureAlgorithm?: VCLSignatureAlgorithm;
  remoteCryptoServicesToken?: VCLToken;
}
