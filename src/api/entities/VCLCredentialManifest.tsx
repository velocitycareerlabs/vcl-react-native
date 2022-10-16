/**
 * Created by Michael Avoyan.
 *
 * Copyright 2022 Velocity Career Labs inc.
 * SPDX-License-Identifier: Apache-2.0
 */

import type { VCLJWT } from './VCLJWT';

export interface VCLCredentialManifest {
  jwt: VCLJWT;
  iss: string;
  did: string;
  exchangeId: string;
  presentationDefinitionId: string;
}
