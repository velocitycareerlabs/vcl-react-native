/**
 * Created by Michael Avoyan.
 *
 * Copyright 2022 Velocity Career Labs inc.
 * SPDX-License-Identifier: Apache-2.0
 */
import type { Dictionary } from '@velocitycareerlabs/vcl-react-native';

export interface VCLJwt {
  encodedJwt: string; // 3 base64Url strings splitted by a dot
  header?: Dictionary<any>,
  payload?: Dictionary<any>,
  signature?: string
}
