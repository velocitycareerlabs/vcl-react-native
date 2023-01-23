/**
 * Created by Michael Avoyan.
 *
 * Copyright 2022 Velocity Career Labs inc.
 * SPDX-License-Identifier: Apache-2.0
 */

export class VCLError extends Error {
  description?: string;
  code?: number;

  constructor(error: any) {
    super(error);
    try {
      const errorJson = JSON.parse(error.message);
      this.description = errorJson.description;
      this.code = parseInt(errorJson.code, 10);
    } catch (e) {
      this.description = JSON.stringify(error);
    }
  }
}

export const toVclError = (error: any) => {
  return new VCLError(error);
};
