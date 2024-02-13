/**
 * Created by Michael Avoyan.
 *
 * Copyright 2022 Velocity Career Labs inc.
 * SPDX-License-Identifier: Apache-2.0
 */

import type { VCLCryptoServiceType } from '../../VCLCryptoServiceType';
import type { VCLSignatureAlgorithm } from '../../VCLSignatureAlgorithm';
import type { VCLRemoteCryptoServicesUrlsDescriptor } from './VCLRemoteCryptoServicesUrlsDescriptor';

export interface VCLCryptoServicesDescriptor {
  cryptoServiceType?: VCLCryptoServiceType;
  signatureAlgorithm?: VCLSignatureAlgorithm;
  remoteCryptoServicesUrlsDescriptor?: VCLRemoteCryptoServicesUrlsDescriptor;
}
