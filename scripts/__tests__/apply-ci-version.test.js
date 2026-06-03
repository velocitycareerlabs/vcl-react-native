const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');
const { spawnSync } = require('node:child_process');

const scriptPath = path.join(__dirname, '..', 'apply-ci-version.js');

const writePackageJson = (version) => {
  const tmpDir = fs.mkdtempSync(path.join(os.tmpdir(), 'vcl-ci-version-'));
  const packageJsonPath = path.join(tmpDir, 'package.json');
  fs.writeFileSync(
    packageJsonPath,
    `${JSON.stringify({ name: 'test-package', version }, null, 2)}\n`
  );
  return packageJsonPath;
};

const runScript = (packageJsonPath, env) =>
  spawnSync(process.execPath, [scriptPath], {
    env: {
      ...process.env,
      GITHUB_OUTPUT: '',
      PACKAGE_JSON_PATH: packageJsonPath,
      ...env,
    },
    encoding: 'utf8',
  });

describe('apply-ci-version', () => {
  it('adds the CI release candidate index to the package version', () => {
    const packageJsonPath = writePackageJson('2.10.0');

    const result = runScript(packageJsonPath, {
      RC_INDEX: '7',
      RC_SUFFIX: 'rc',
    });

    expect(result.status).toBe(0);
    expect(JSON.parse(fs.readFileSync(packageJsonPath, 'utf8')).version).toBe(
      '2.10.0-rc.7'
    );
  });

  it('uses the GitHub run number when no explicit index is provided', () => {
    const packageJsonPath = writePackageJson('2.10.0');

    const result = runScript(packageJsonPath, {
      RC_INDEX: '',
      GITHUB_RUN_NUMBER: '42',
      RC_SUFFIX: 'rc',
    });

    expect(result.status).toBe(0);
    expect(JSON.parse(fs.readFileSync(packageJsonPath, 'utf8')).version).toBe(
      '2.10.0-rc.42'
    );
  });

  it('rejects invalid release candidate indexes', () => {
    const packageJsonPath = writePackageJson('2.10.0');

    const result = runScript(packageJsonPath, {
      RC_INDEX: '01',
      RC_SUFFIX: 'rc',
    });

    expect(result.status).toBe(1);
    expect(result.stderr).toContain('Invalid RC index');
    expect(JSON.parse(fs.readFileSync(packageJsonPath, 'utf8')).version).toBe(
      '2.10.0'
    );
  });

  it('rejects prerelease package versions', () => {
    const packageJsonPath = writePackageJson('2.10.0-rc');

    const result = runScript(packageJsonPath, {
      RC_INDEX: '1',
      RC_SUFFIX: 'rc',
    });

    expect(result.status).toBe(1);
    expect(result.stderr).toContain('target patch version');
    expect(JSON.parse(fs.readFileSync(packageJsonPath, 'utf8')).version).toBe(
      '2.10.0-rc'
    );
  });
});
