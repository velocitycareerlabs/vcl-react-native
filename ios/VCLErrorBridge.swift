//
//  VCLErrorBridge.swift
//  vcl-react-native
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation
import React
import VCL

final class VCLErrorBridge {

  private static let bridgedVCLErrorCode = "VCL_BRIDGED_ERROR_V1"
  private static let defaultNativeErrorStackFrameLimit = 5
  private static let maxNativeErrorStackFrameLimit = 20
  private static let nativeStackFramesDictionaryKey = "callStackSymbols"

  private var nativeErrorStackFrameLimit = VCLErrorBridge.defaultNativeErrorStackFrameLimit

  func updateConfiguration(_ initializationDescriptorDictionary: [String: Any]) {
    let stackFrameLimit = initializationDescriptorDictionary["nativeErrorStackFrameLimit"] as? Int
    nativeErrorStackFrameLimit =
      stackFrameLimit.map { min(max($0, 0), Self.maxNativeErrorStackFrameLimit) }
      ?? Self.defaultNativeErrorStackFrameLimit
  }

  func rejectBridgedVCLError(
    _ reject: @escaping RCTPromiseRejectBlock,
    error: VCLError
  ) {
    let serializedError =
      bridgedVCLErrorPayload(error).toJsonString()
      ?? error.message
      ?? "Unexpected VCLError"
    reject(Self.bridgedVCLErrorCode, serializedError, error)
  }

  private func bridgedVCLErrorPayload(_ error: VCLError) -> [String: Any] {
    var payload = error.toDictionary().compactMapValues { $0 }
    payload.removeValue(forKey: Self.nativeStackFramesDictionaryKey)
    payload["diagnostics"] = bridgedDiagnostics(error)
    return payload
  }

  private func bridgedDiagnostics(_ error: VCLError) -> [String: Any] {
    var diagnostics: [String: Any] = [
      "nativePlatform": "ios",
      "nativeType": String(describing: type(of: error)),
    ]

    if let nativeStackFrames =
      limitedStackFrames(
        error.toDictionary()[Self.nativeStackFramesDictionaryKey] as? [String]
      )
    {
      diagnostics["nativeStackFrames"] = nativeStackFrames
    }

    if let cause = error.cause {
      var nativeCause: [String: Any] = [
        "type": String(describing: type(of: cause)),
        "message": String(describing: cause),
      ]

      if let stackFrames =
        limitedStackFrames(
          (cause as? VCLError)?.toDictionary()[Self.nativeStackFramesDictionaryKey] as? [String]
        )
      {
        nativeCause["stackFrames"] = stackFrames
      }

      diagnostics["nativeCause"] = nativeCause
    }

    return diagnostics
  }

  private func limitedStackFrames(_ stackFrames: [String]?) -> [String]? {
    guard nativeErrorStackFrameLimit > 0, let stackFrames else {
      return nil
    }

    let trimmedStackFrames = Array(stackFrames.prefix(nativeErrorStackFrameLimit))
    return trimmedStackFrames.isEmpty ? nil : trimmedStackFrames
  }
}
