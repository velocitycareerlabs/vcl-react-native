/**
 * Created by Michael Avoyan.
 *
 * Copyright 2022 Velocity Career Labs inc.
 * SPDX-License-Identifier: Apache-2.0
 */

import type { VCLEnvironment } from '../../VCLEnvironment';
import type { VCLCryptoServicesDescriptor } from './VCLCryptoServicesDescriptor';
import type { VCLErrorCodeCompatibilityMode } from './VCLErrorCodeCompatibilityMode';
import type { VCLXVnfProtocolVersion } from '../../VCLXVnfProtocolVersion';

export interface VCLInitializationDescriptor {
  environment?: VCLEnvironment;
  xVnfProtocolVersion?: VCLXVnfProtocolVersion;
  cacheSequence?: number;
  isDebugOn?: boolean;
  cryptoServicesDescriptor?: VCLCryptoServicesDescriptor;
  isDirectIssuerCheckOn?: boolean;
  /**
   * Controls whether native SDK errors use the new taxonomy codes or legacy
   * backward-compatible mappings. Native SDKs default to taxonomy mode.
   */
  errorCodeCompatibilityMode?: VCLErrorCodeCompatibilityMode;
  /**
   * Maximum number of native stack frames to include in bridged error diagnostics.
   * Native implementations clamp values to the range `0..20`.
   * Use `0` to disable native stack frames.
   */
  nativeErrorStackFrameLimit?: number;
}
