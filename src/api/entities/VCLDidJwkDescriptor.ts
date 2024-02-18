/**
 * Created by Michael Avoyan.
 *
 * Copyright 2022 Velocity Career Labs inc.
 * SPDX-License-Identifier: Apache-2.0
 */

import type { VCLSignatureAlgorithm } from '../VCLSignatureAlgorithm';
import type { VCLToken } from './VCLToken';

export interface VCLDidJwkDescriptor {
  signatureAlgorithm: VCLSignatureAlgorithm;
  remoteCryptoServicesToken?: VCLToken;
}
