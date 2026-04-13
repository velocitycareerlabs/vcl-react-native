/**
 * Created by Michael Avoyan.
 *
 * Copyright 2022 Velocity Career Labs inc.
 * SPDX-License-Identifier: Apache-2.0
 */

import { VCLError } from './VCLError';

export const BRIDGED_VCL_ERROR_CODE = 'VCL_BRIDGED_ERROR_V1';

type SerializedVCLError = {
  payload?: string;
  error?: string;
  errorCode?: string;
  requestId?: string;
  message?: string;
  statusCode?: unknown;
};

export class VCLErrorDeserializer {
  static fromJsonString(jsonString: string): VCLError {
    try {
      const error = JSON.parse(jsonString) as SerializedVCLError;
      return new VCLError({
        payload: error.payload,
        error: error.error,
        errorCode: error.errorCode,
        requestId: error.requestId,
        message: error.message,
        statusCode: VCLErrorDeserializer.parseStatusCode(error.statusCode),
      });
    } catch (_parseError) {
      return new VCLError({ message: jsonString });
    }
  }

  private static parseStatusCode(statusCode: unknown): number | undefined {
    if (statusCode == null) {
      return undefined;
    }

    const parsedStatusCode = parseInt(String(statusCode), 10);
    return Number.isNaN(parsedStatusCode) ? undefined : parsedStatusCode;
  }
}
