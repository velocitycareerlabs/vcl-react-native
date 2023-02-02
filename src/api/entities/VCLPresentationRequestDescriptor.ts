/**
 * Created by Michael Avoyan.
 *
 * Copyright 2022 Velocity Career Labs inc.
 * SPDX-License-Identifier: Apache-2.0
 */

import type { VCLDeepLink } from './VCLDeepLink';
import type { VCLPushDelegate } from './VCLPushDelegate';
import type { VCLServiceType } from './VCLServiceType';

export interface VCLPresentationRequestDescriptor {
  deepLink: VCLDeepLink;
  serviceType?: VCLServiceType;
  pushDelegate?: VCLPushDelegate;
}
