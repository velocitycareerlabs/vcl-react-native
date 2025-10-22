/**
 * Created by Michael Avoyan on 17/04/2025.
 *
 * Copyright 2022 Velocity Career Labs inc.
 * SPDX-License-Identifier: Apache-2.0
 */
import type {
  Dictionary,
  VCLToken,
} from '@velocitycareerlabs/vcl-react-native';

export interface VCLAuthToken {
  payload: Dictionary<any>;
  authTokenUri?: string;
  walletDid?: string;
  relyingPartyDid?: string;
  accessToken: VCLToken;
  refreshToken: VCLToken;
  tokenType: string;
}
