/**
 * Created by Michael Avoyan.
 *
 * Copyright 2022 Velocity Career Labs inc.
 * SPDX-License-Identifier: Apache-2.0
 */

import type { VCLEnvironment } from '../VCLEnvironment';
import type { VCLKeyServiceType } from '../VCLKeyServiceType';
import type { VCLXVnfProtocolVersion } from '../VCLXVnfProtocolVersion';

export interface VCLInitializationDescriptor {
  environment?: VCLEnvironment;
  keyServiceType?: VCLKeyServiceType;
  xVnfProtocolVersion?: VCLXVnfProtocolVersion;
  cacheSequence?: number;
  isDebugOn?: boolean;
}
