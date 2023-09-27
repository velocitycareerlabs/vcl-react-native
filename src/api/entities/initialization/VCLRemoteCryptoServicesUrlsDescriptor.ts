/**
 * Created by Michael Avoyan.
 *
 * Copyright 2022 Velocity Career Labs inc.
 * SPDX-License-Identifier: Apache-2.0
 */

import type { VCLJwtServiceUrls } from './VCLJwtServiceUrls';
import type { VCLKeyServiceUrls } from './VCLKeyServiceUrls';

export interface VCLRemoteCryptoServicesUrlsDescriptor {
  keyServiceUrls: VCLKeyServiceUrls;
  jwtServiceUrls: VCLJwtServiceUrls;
}
