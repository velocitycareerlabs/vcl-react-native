/**
 * Created by Michael Avoyan.
 *
 * Copyright 2022 Velocity Career Labs inc.
 * SPDX-License-Identifier: Apache-2.0
 */

import type { VCLDeepLink } from './VCLDeepLink';
import type { VCLDidJwk } from './VCLDidJwk';
import type { VCLPushDelegate } from './VCLPushDelegate';
import type { VCLToken } from './VCLToken';

export interface VCLPresentationRequestDescriptor {
  deepLink: VCLDeepLink;
  pushDelegate?: VCLPushDelegate;
  didJwk: VCLDidJwk;
  remoteCryptoServicesToken?: VCLToken;
}
