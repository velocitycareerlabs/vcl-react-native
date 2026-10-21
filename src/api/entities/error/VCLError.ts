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
  sourceErrorCode?: string;
  validationPhase?: string;
  requestDid?: string;
  requestUri?: string;
  requestKind?: string;
  diagnostics?: VCLDiagnostics;
};

export class VCLError extends Error {
  payload?: string;
  error?: string;
  errorCode?: string;
  requestId?: string;
  statusCode?: number;
  /**
   * The error code before the native SDK mapped it to the taxonomy `errorCode`,
   * e.g. the server's `exchange_invalid` behind `client_request_rejected`.
   */
  sourceErrorCode?: string;
  /** The native validation phase that failed, e.g. `client_request_fetch`. */
  validationPhase?: string;
  /** The DID of the issuer or verifier the failed request was for. */
  requestDid?: string;
  /**
   * The URI of the failed request. The value of its `push_delegate.push_token`
   * query parameter is replaced with `[redacted]`, and the rest is passed
   * through unchanged. It can still carry query parameters such as
   * `exchange_id`, `credential_types`, `vendorOriginContext` and
   * issuer-specific values, so redact it before sending it to telemetry.
   */
  requestUri?: string;
  /** The kind of request that failed, e.g. `issuing_request`. */
  requestKind?: string;
  diagnostics?: VCLDiagnostics;

  constructor(error: VCLErrorInit = {}) {
    super(error.message);
    this.name = 'VCLError';
    this.payload = error.payload;
    this.error = error.error;
    this.errorCode = error.errorCode;
    this.requestId = error.requestId;
    this.statusCode = error.statusCode;
    this.sourceErrorCode = error.sourceErrorCode;
    this.validationPhase = error.validationPhase;
    this.requestDid = error.requestDid;
    this.requestUri = error.requestUri;
    this.requestKind = error.requestKind;
    this.diagnostics = error.diagnostics;
  }
}
