/**
 * Created by Michael Avoyan.
 *
 * Copyright 2022 Velocity Career Labs inc.
 * SPDX-License-Identifier: Apache-2.0
 */

export interface VCLDidJwk {
  /**
   * The id of private key save in secure enclave
   */
  keyId: string;
  /**
   * The did:jwk
   */
  value: string;
  /**
   * kid of jwt - did:jwk suffixed with #0
   */
  kid: string;
}
