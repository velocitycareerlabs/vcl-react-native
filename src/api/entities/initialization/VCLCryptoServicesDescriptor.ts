/**
 * Created by Michael Avoyan.
 *
 * Copyright 2022 Velocity Career Labs inc.
 * SPDX-License-Identifier: Apache-2.0
 */

import type { VCLCryptoServiceType } from '../../VCLCryptoServiceType';
import type { VCLRemoteCryptoServicesUrlsDescriptor } from './VCLRemoteCryptoServicesUrlsDescriptor';

export interface VCLCryptoServicesDescriptor {
  cryptoServiceType?: VCLCryptoServiceType;
  remoteCryptoServicesUrlsDescriptor?: VCLRemoteCryptoServicesUrlsDescriptor;
}
