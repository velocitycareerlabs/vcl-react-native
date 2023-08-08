/**
 * Created by Michael Avoyan on 08/08/2023.
 *
 * Copyright 2022 Velocity Career Labs inc.
 * SPDX-License-Identifier: Apache-2.0
 */

package io.velocitycareerlabs.reactnative

import io.velocitycareerlabs.api.VCLEnvironment

internal object GlobalConfig {

  var CurrentEnvironment = VCLEnvironment.PROD

  var IsDebugOn = false //BuildConfig.DEBUG

  const val LogTagPrefix = "VCL RN Android "
  val IsLoggerOn get() = CurrentEnvironment != VCLEnvironment.PROD || IsDebugOn
}
