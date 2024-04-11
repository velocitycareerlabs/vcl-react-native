/**
 * Created by Michael Avoyan.
 *
 * Copyright 2022 Velocity Career Labs inc.
 * SPDX-License-Identifier: Apache-2.0
 */

import type { Dictionary } from '../Dictionary';

export interface VCLJwtDescriptor {
  /**
   * The Id of the existing private key to sign with
   */
  keyId?: string;
  /**
   * Json formatted payload
   */
  payload: Dictionary<any>;
  /**
   * JWT ID
   */
  jti: string;
  /**
   * The did of the wallet owner
   */
  iss: string;
  /**
   * The issuer DID
   */
  aud?: string;
}
