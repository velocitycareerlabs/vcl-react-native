#!/usr/bin/env node

const fs = require('node:fs');
const path = require('node:path');

const packageJsonPath =
  process.env.PACKAGE_JSON_PATH ?? path.join(__dirname, '..', 'package.json');
const rcSuffix = process.env.RC_SUFFIX ?? 'rc';
const rcIndex = process.env.RC_INDEX || process.env.GITHUB_RUN_NUMBER;

const semverIdentifierRegex = /^[0-9A-Za-z-]+$/;
const numericIdentifierRegex = /^(0|[1-9]\d*)$/;

const fail = (message) => {
  console.error(message);
  process.exit(1);
};

if (!semverIdentifierRegex.test(rcSuffix)) {
  fail(`Invalid RC_SUFFIX "${rcSuffix}". Expected a SemVer identifier.`);
}

if (!rcIndex || !numericIdentifierRegex.test(rcIndex)) {
  fail(
    `Invalid RC index "${rcIndex ?? ''}". Set RC_INDEX or GITHUB_RUN_NUMBER to a non-negative integer.`
  );
}

const packageJson = JSON.parse(fs.readFileSync(packageJsonPath, 'utf8'));
const currentVersion = packageJson.version;
const stableVersionRegex = /^(\d+)\.(\d+)\.(\d+)$/;
const match = currentVersion.match(stableVersionRegex);

if (!match) {
  fail(
    `Package version "${currentVersion}" must be a target patch version before CI can append ${rcSuffix}.<index>.`
  );
}

const [, major, minor, patch] = match;
const nextVersion = `${major}.${minor}.${patch}-${rcSuffix}.${rcIndex}`;
packageJson.version = nextVersion;

fs.writeFileSync(
  packageJsonPath,
  `${JSON.stringify(packageJson, null, 2)}\n`,
  'utf8'
);

if (process.env.GITHUB_OUTPUT) {
  fs.appendFileSync(process.env.GITHUB_OUTPUT, `version=${nextVersion}\n`);
}

console.info(`Applied CI package version ${nextVersion}`);
