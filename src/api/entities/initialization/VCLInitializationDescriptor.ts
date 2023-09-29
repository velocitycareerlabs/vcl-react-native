/**
 * Created by Michael Avoyan.
 *
 * Copyright 2022 Velocity Career Labs inc.
 * SPDX-License-Identifier: Apache-2.0
 */

import type { VCLEnvironment } from '../../VCLEnvironment';
import type { VCLCryptoServicesDescriptor } from './VCLCryptoServicesDescriptor';
import type { VCLXVnfProtocolVersion } from '../../VCLXVnfProtocolVersion';

export interface VCLInitializationDescriptor {
  environment?: VCLEnvironment;
  xVnfProtocolVersion?: VCLXVnfProtocolVersion;
  cacheSequence?: number;
  isDebugOn?: boolean;
  cryptoServicesDescriptor?: VCLCryptoServicesDescriptor;
}
