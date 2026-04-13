/**
 * Created by Michael Avoyan on 20/12/2022.
 *
 * Copyright 2022 Velocity Career Labs inc.
 * SPDX-License-Identifier: Apache-2.0
 */

package io.velocitycareerlabs.reactnative.extensions

import com.facebook.react.bridge.Promise
import io.velocitycareerlabs.api.entities.error.VCLError

const val BRIDGED_VCL_ERROR_CODE = "VCL_BRIDGED_ERROR_V1"

fun Promise.rejectBridgedVCLError(error: VCLError) {
  val serializedError = error.toJsonObject().toString()
  reject(BRIDGED_VCL_ERROR_CODE, serializedError, Throwable(serializedError))
}
