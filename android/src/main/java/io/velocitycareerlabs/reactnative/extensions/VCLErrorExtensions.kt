/**
 * Created by Michael Avoyan on 20/12/2022.
 *
 * Copyright 2022 Velocity Career Labs inc.
 * SPDX-License-Identifier: Apache-2.0
 */

package io.velocitycareerlabs.reactnative.extensions

import io.velocitycareerlabs.api.entities.VCLError
import org.json.JSONObject

fun VCLError.toThrowable() =
  Throwable(this.toJsonObject().toString())
