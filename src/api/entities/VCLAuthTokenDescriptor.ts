/**
 * Created by Michael Avoyan on 17/04/2025.
 *
 * Copyright 2022 Velocity Career Labs inc.
 * SPDX-License-Identifier: Apache-2.0
 */
import type { VCLPresentationRequest, VCLToken } from '@velocitycareerlabs/vcl-react-native';

export interface VCLAuthTokenDescriptor {
  authTokenUri?: string
  presentationRequest?: VCLPresentationRequest
  refreshToken?: VCLToken
  walletDid?: string
  relyingPartyDid?: string
  authorizationCode?: string
}
