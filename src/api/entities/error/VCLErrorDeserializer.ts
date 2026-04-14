/**
 * Created by Michael Avoyan.
 *
 * Copyright 2022 Velocity Career Labs inc.
 * SPDX-License-Identifier: Apache-2.0
 */

import {
  VCLError,
  type VCLDiagnostics,
  type VCLNativeCauseDiagnostics,
} from './VCLError';

export const BRIDGED_VCL_ERROR_CODE = 'VCL_BRIDGED_ERROR_V1';

type SerializedVCLError = {
  payload?: string;
  error?: string;
  errorCode?: string;
  requestId?: string;
  message?: string;
  statusCode?: unknown;
  diagnostics?: unknown;
};

export class VCLErrorDeserializer {
  static fromJsonString(jsonString: string): VCLError {
    try {
      const parsedError = JSON.parse(jsonString);

      if (!VCLErrorDeserializer.isSerializedVCLError(parsedError)) {
        return new VCLError({ message: jsonString });
      }

      const error = parsedError as SerializedVCLError;
      return new VCLError({
        payload: error.payload,
        error: error.error,
        errorCode: error.errorCode,
        requestId: error.requestId,
        message: error.message,
        statusCode: VCLErrorDeserializer.parseStatusCode(error.statusCode),
        diagnostics: VCLErrorDeserializer.parseDiagnostics(error.diagnostics),
      });
    } catch (_parseError) {
      return new VCLError({ message: jsonString });
    }
  }

  private static isSerializedVCLError(
    value: unknown
  ): value is SerializedVCLError {
    return typeof value === 'object' && value != null && !Array.isArray(value);
  }

  private static parseStatusCode(statusCode: unknown): number | undefined {
    if (statusCode == null) {
      return undefined;
    }

    const parsedStatusCode = parseInt(String(statusCode), 10);
    return Number.isNaN(parsedStatusCode) ? undefined : parsedStatusCode;
  }

  private static parseDiagnostics(
    diagnostics: unknown
  ): VCLDiagnostics | undefined {
    if (typeof diagnostics !== 'object' || diagnostics == null) {
      return undefined;
    }

    const nativePlatform = VCLErrorDeserializer.parseNativePlatform(
      (diagnostics as { nativePlatform?: unknown }).nativePlatform
    );
    const nativeType = VCLErrorDeserializer.parseString(
      (diagnostics as { nativeType?: unknown }).nativeType
    );
    const nativeStackFrames = VCLErrorDeserializer.parseStringArray(
      (diagnostics as { nativeStackFrames?: unknown }).nativeStackFrames
    );
    const nativeCause = VCLErrorDeserializer.parseNativeCause(
      (diagnostics as { nativeCause?: unknown }).nativeCause
    );

    if (
      nativePlatform == null &&
      nativeType == null &&
      nativeStackFrames == null &&
      nativeCause == null
    ) {
      return undefined;
    }

    return {
      nativePlatform,
      nativeType,
      nativeStackFrames,
      nativeCause,
    };
  }

  private static parseNativeCause(
    nativeCause: unknown
  ): VCLNativeCauseDiagnostics | undefined {
    if (typeof nativeCause !== 'object' || nativeCause == null) {
      return undefined;
    }

    const type = VCLErrorDeserializer.parseString(
      (nativeCause as { type?: unknown }).type
    );
    const message = VCLErrorDeserializer.parseString(
      (nativeCause as { message?: unknown }).message
    );
    const stackFrames = VCLErrorDeserializer.parseStringArray(
      (nativeCause as { stackFrames?: unknown }).stackFrames
    );

    if (type == null && message == null && stackFrames == null) {
      return undefined;
    }

    return { type, message, stackFrames };
  }

  private static parseNativePlatform(
    nativePlatform: unknown
  ): VCLDiagnostics['nativePlatform'] {
    if (nativePlatform === 'ios' || nativePlatform === 'android') {
      return nativePlatform;
    }

    return undefined;
  }

  private static parseString(value: unknown): string | undefined {
    return typeof value === 'string' ? value : undefined;
  }

  private static parseStringArray(value: unknown): string[] | undefined {
    if (!Array.isArray(value)) {
      return undefined;
    }

    const stackFrames = value.filter(
      (stackFrame): stackFrame is string => typeof stackFrame === 'string'
    );

    return stackFrames.length > 0 ? stackFrames : undefined;
  }
}
