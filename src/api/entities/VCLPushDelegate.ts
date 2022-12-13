/**
 * Created by Michael Avoyan.
 *
 * Copyright 2022 Velocity Career Labs inc.
 * SPDX-License-Identifier: Apache-2.0
 */

export interface VCLPushDelegate {
  /**
   * the url of the endpoint that will send pushes to the device
   */
  pushUrl: string;
  /**
   * the token to use for identifying the group of devices this device belongs to
   */
  pushToken: string;
}
