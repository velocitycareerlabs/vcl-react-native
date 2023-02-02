/**
 * Created by Michael Avoyan.
 *
 * Copyright 2022 Velocity Career Labs inc.
 * SPDX-License-Identifier: Apache-2.0
 */

import type { VCLJwt } from './VCLJwt';

export interface VCLCredentialManifest {
  jwt: VCLJwt;
  iss: string;
  did: string;
  exchangeId: string;
  presentationDefinitionId: string;
}
