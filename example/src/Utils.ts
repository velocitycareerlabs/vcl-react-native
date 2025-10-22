/**
 * Created by Michael Avoyan.
 *
 * Copyright 2022 Velocity Career Labs inc.
 * SPDX-License-Identifier: Apache-2.0
 */

import type { VCLOffers, VCLToken } from '@velocitycareerlabs/vcl-react-native';

export const getApprovedRejectedOfferIdsMock = (
  offers: VCLOffers
): string[][] => {
  const approvedOfferIds: string[] = [];
  const rejectedOfferIds: string[] = [];
  if (offers.all.length > 0) {
    approvedOfferIds.push(offers.all[0]?.id || '');
  }
  if (offers.all.length > 1) {
    rejectedOfferIds.push(offers.all[1]?.id || '');
  }
  return [approvedOfferIds, rejectedOfferIds];
};

export const verifyToken = (token?: VCLToken) => {
  return (token?.expiresIn ?? 0) > Date.now() / 1000;
};
