/**
 * Created by Michael Avoyan on 05/02/2025.
 *
 * Copyright 2022 Velocity Career Labs inc.
 * SPDX-License-Identifier: Apache-2.0
 */
const fs = require("fs");
const path = require("path");

const filePath = path.resolve(__dirname, "../.yarnrc.yml");

try {
  if (fs.existsSync(filePath)) {
    const content = fs.readFileSync(filePath, "utf8");
    const updatedContent = content
      .split("\n")
      .filter(line => !line.includes("yarnPath: .yarn/releases/yarn-3.6.1.cjs"))
      .join("\n");

    fs.writeFileSync(filePath, updatedContent, "utf8");
    console.log("✅ Removed 'yarnPath' from .yarnrc.yml");
  }
} catch (error) {
  console.error("❌ Error updating .yarnrc.yml:", error);
}
