/**
 * Created by Michael Avoyan.
 *
 * Copyright 2022 Velocity Career Labs inc.
 * SPDX-License-Identifier: Apache-2.0
 */

export class VCLError extends Error {
  payload?: string;
  error?: string;
  errorCode?: string;
  requestId?: string;
  statusCode?: number;

  constructor(error: any) {
    super(error);
    try {
      const errorJson = JSON.parse(error.message);
      this.payload = errorJson.payload;
      this.error = errorJson.error;
      this.errorCode = errorJson.errorCode;
      this.requestId = errorJson.requestId;
      this.message = errorJson.message;
      this.statusCode = parseInt(errorJson.statusCode, 10);
    } catch (e) {
      this.message = JSON.stringify(error);
    }
  }
}
