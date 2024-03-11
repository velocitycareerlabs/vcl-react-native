/**
 * Created by Michael Avoyan.
 *
 * Copyright 2022 Velocity Career Labs inc.
 * SPDX-License-Identifier: Apache-2.0
 */

import type { VCLOffers } from '@velocitycareerlabs/vcl-react-native';

export class Utils {
  static readonly getApprovedRejectedOfferIdsMock = (
    offers: VCLOffers
  ): string[][] => {
    var approvedOfferIds: string[] = [];
    var rejectedOfferIds: string[] = [];
    if (offers.all.length > 0) {
      approvedOfferIds.push(offers.all[0]?.id || '');
    }
    if (offers.all.length > 1) {
      rejectedOfferIds.push(offers.all[1]?.id || '');
    }
    return [approvedOfferIds, rejectedOfferIds];
  };
}
