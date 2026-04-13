/**
 * Created by Michael Avoyan.
 *
 * Copyright 2022 Velocity Career Labs inc.
 * SPDX-License-Identifier: Apache-2.0
 */

export type VCLErrorInit = {
  payload?: string;
  error?: string;
  errorCode?: string;
  requestId?: string;
  message?: string;
  statusCode?: number;
};

export class VCLError extends Error {
  payload?: string;
  error?: string;
  errorCode?: string;
  requestId?: string;
  statusCode?: number;

  constructor(error: VCLErrorInit = {}) {
    super(error.message);
    this.name = 'VCLError';
    this.payload = error.payload;
    this.error = error.error;
    this.errorCode = error.errorCode;
    this.requestId = error.requestId;
    this.statusCode = error.statusCode;
  }
}
