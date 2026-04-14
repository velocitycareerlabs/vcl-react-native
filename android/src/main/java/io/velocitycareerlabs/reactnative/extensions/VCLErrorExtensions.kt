/**
 * Created by Michael Avoyan on 20/12/2022.
 *
 * Copyright 2022 Velocity Career Labs inc.
 * SPDX-License-Identifier: Apache-2.0
 */

package io.velocitycareerlabs.reactnative.extensions

import com.facebook.react.bridge.Promise
import io.velocitycareerlabs.api.entities.error.VCLError
import org.json.JSONArray
import org.json.JSONObject

const val BRIDGED_VCL_ERROR_CODE = "VCL_BRIDGED_ERROR_V1"
private const val DEFAULT_NATIVE_ERROR_STACK_FRAME_LIMIT = 5
private const val MAX_NATIVE_ERROR_STACK_FRAME_LIMIT = 20

object VCLErrorBridgeConfig {
  var nativeErrorStackFrameLimit = DEFAULT_NATIVE_ERROR_STACK_FRAME_LIMIT
    private set

  fun updateNativeErrorStackFrameLimit(nativeErrorStackFrameLimit: Int?) {
    this.nativeErrorStackFrameLimit =
      nativeErrorStackFrameLimit
        ?.coerceIn(0, MAX_NATIVE_ERROR_STACK_FRAME_LIMIT)
        ?: DEFAULT_NATIVE_ERROR_STACK_FRAME_LIMIT
  }
}

fun Promise.rejectBridgedVCLError(error: VCLError) {
  val serializedError =
    error.toBridgedJsonObject(VCLErrorBridgeConfig.nativeErrorStackFrameLimit).toString()
  reject(BRIDGED_VCL_ERROR_CODE, serializedError, error)
}

private fun VCLError.toBridgedJsonObject(
  nativeErrorStackFrameLimit: Int
) = JSONObject().apply {
  putOpt("payload", payload)
  putOpt("error", error)
  putOpt("errorCode", errorCode)
  putOpt("requestId", requestId)
  putOpt("message", message)
  putOpt("statusCode", statusCode)
  put("diagnostics", toDiagnosticsJsonObject(nativeErrorStackFrameLimit))
}

private fun VCLError.toDiagnosticsJsonObject(
  nativeErrorStackFrameLimit: Int
) = JSONObject().apply {
  put("nativePlatform", "android")
  put("nativeType", this@toDiagnosticsJsonObject::class.java.name)
  putOpt(
    "nativeStackFrames",
    stackTrace
      .takeIf { nativeErrorStackFrameLimit > 0 }
      ?.take(nativeErrorStackFrameLimit)
      ?.map { it.toString() }
      ?.takeIf { it.isNotEmpty() }
      ?.let { JSONArray(it) }
  )
  cause?.let { put("nativeCause", it.toNativeCauseJsonObject(nativeErrorStackFrameLimit)) }
}

private fun Throwable.toNativeCauseJsonObject(
  nativeErrorStackFrameLimit: Int
) = JSONObject().apply {
  put("type", javaClass.name)
  put("message", message ?: toString())
  putOpt(
    "stackFrames",
    stackTrace
      .takeIf { nativeErrorStackFrameLimit > 0 }
      ?.take(nativeErrorStackFrameLimit)
      ?.map { it.toString() }
      ?.takeIf { it.isNotEmpty() }
      ?.let { JSONArray(it) }
  )
}
