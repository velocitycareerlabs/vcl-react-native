/**
 * Created by Michael Avoyan.
 *
 * Copyright 2022 Velocity Career Labs inc.
 * SPDX-License-Identifier: Apache-2.0
 */

import type { VCLDeepLink } from './VCLDeepLink';
import type { VCLDidJwk } from './VCLDidJwk';
import type { VCLJwt } from './VCLJwt';
import type { VCLToken } from './VCLToken';
import type { VCLVerifiedProfile } from './VCLVerifiedProfile';

export interface VCLCredentialManifest {
  jwt: VCLJwt;
  vendorOriginContext?: String;
  verifiedProfile: VCLVerifiedProfile;
  deepLink?: VCLDeepLink;
  iss: string;
  did: string;
  exchangeId: string;
  presentationDefinitionId: string;
  didJwk: VCLDidJwk;
  remoteCryptoServicesToken?: VCLToken;
}
