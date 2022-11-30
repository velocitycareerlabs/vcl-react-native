/**
 * Created by Michael Avoyan.
 *
 * Copyright 2022 Velocity Career Labs inc.
 * SPDX-License-Identifier: Apache-2.0
 */

import type { VCLFilter } from './VCLFilter';
import type { VCLPage } from './VCLPage';

export interface VCLOrganizationsSearchDescriptor {
  filter?: VCLFilter;
  page?: VCLPage;
  sort?: string[][];
  query?: string;
}
