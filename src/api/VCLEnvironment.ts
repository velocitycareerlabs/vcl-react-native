/**
 * Created by Michael Avoyan.
 *
 * Copyright 2022 Velocity Career Labs inc.
 * SPDX-License-Identifier: Apache-2.0
 */

export interface VCLEnvironment {
  value: string;
}

export enum VCLEnvTypes {
  DEV = 'dev',
  QA = 'qa',
  STAGING = 'staging',
  PROD = 'prod',
}
