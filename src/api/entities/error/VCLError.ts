/**
 * Created by Michael Avoyan.
 *
 * Copyright 2022 Velocity Career Labs inc.
 * SPDX-License-Identifier: Apache-2.0
 */

export type VCLNativeCauseDiagnostics = {
  type?: string;
  message?: string;
  stackFrames?: string[];
};

export type VCLDiagnostics = {
  nativePlatform?: 'ios' | 'android';
  nativeType?: string;
  nativeStackFrames?: string[];
  nativeCause?: VCLNativeCauseDiagnostics;
};

export type VCLErrorInit = {
  payload?: string;
  error?: string;
  errorCode?: string;
  requestId?: string;
  message?: string;
  statusCode?: number;
  diagnostics?: VCLDiagnostics;
};

export class VCLError extends Error {
  payload?: string;
  error?: string;
  errorCode?: string;
  requestId?: string;
  statusCode?: number;
  diagnostics?: VCLDiagnostics;

  constructor(error: VCLErrorInit = {}) {
    super(error.message);
    this.name = 'VCLError';
    this.payload = error.payload;
    this.error = error.error;
    this.errorCode = error.errorCode;
    this.requestId = error.requestId;
    this.statusCode = error.statusCode;
    this.diagnostics = error.diagnostics;
  }
}
