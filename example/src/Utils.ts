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
    var offerId1 = '';
    var offerId2 = '';
    if (offers.all.length > 0) {
      offerId1 = offers.all[0]?.id ?? '';
      offerId2 = offers.all[offers.all.length - 1]?.id ?? '';
    }
    let approvedOfferIds: string[] = [offerId1].filter(
      (offer) => offer.length > 0
    );
    let rejectedOfferIds: string[] = [offerId2].filter(
      (offer) => offer.length > 0
    );
    console.log(approvedOfferIds, rejectedOfferIds);

    return [approvedOfferIds, rejectedOfferIds];
  };
}
