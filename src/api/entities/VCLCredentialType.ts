/**
 * Created by Michael Avoyan.
 *
 * Copyright 2022 Velocity Career Labs inc.
 * SPDX-License-Identifier: Apache-2.0
 */

import type { Dictionary } from '../Dictionary';

export interface VCLCredentialType {
  payload: Dictionary<any>;
  id: string;
  schema: string;
  createdAt: string;
  schemaName: string;
  credentialType: string;
  recommended: boolean;
}
