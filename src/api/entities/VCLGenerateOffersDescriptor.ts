/**
 * Created by Michael Avoyan.
 *
 * Copyright 2022 Velocity Career Labs inc.
 * SPDX-License-Identifier: Apache-2.0
 */

import type { VCLCredentialManifest } from './VCLCredentialManifest';
import type { VCLVerifiableCredential } from './VCLVerifiableCredential';

export interface VCLGenerateOffersDescriptor {
  credentialManifest: VCLCredentialManifest;
  types?: string[];
  offerHashes?: string[];
  identificationVerifiableCredentials?: VCLVerifiableCredential[];
}
