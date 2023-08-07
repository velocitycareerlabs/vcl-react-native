/**
 * Created by Michael Avoyan.
 *
 * Copyright 2022 Velocity Career Labs inc.
 * SPDX-License-Identifier: Apache-2.0
 */

import type { VCLEnvironment } from '../VCLEnvironment';

export interface VCLInitializationDescriptor {
  environment?: VCLEnvironment;
  cacheSequence?: number;
  isDebugOn?: boolean;
}
