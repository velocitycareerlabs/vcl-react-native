//
//  GlobalConfig.swift
//  vcl-react-native
//
//  Created by Michael Avoyan on 08/08/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
import VCL

struct GlobalConfig {

    static var CurrentEnvironment = VCLEnvironment.Prod

    static var IsDebugOn = false

    static let LogTagPrefix = "VCL RN iOS "

    static var IsLoggerOn: Bool { get { CurrentEnvironment != VCLEnvironment.Prod || GlobalConfig.IsDebugOn } }
}
