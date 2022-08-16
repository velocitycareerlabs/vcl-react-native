import type { VCLFilter } from './VCLFilter';
import type { VCLPage } from './VCLPage';

export interface VCLOrganizationsSearchDescriptor {
  filter?: VCLFilter;
  page?: VCLPage;
  sort?: string[][];
  query?: string;
}
