# @velocitycareerlabs/vcl-react-native

Velocity Career Labs React Native SDK


Android:

kotlin version: 1.9.24

minSdkVersion: 24

compileSdkVersion: 34

targetSdkVersion: 34


iOS:

swift version: 5

deployment target: 13


React Native:

react version 18.2.0

react native version 0.73.6

# React Native SDK

The React Native SDK is a wrapper of iOS and Android SDKs.
The minimum supported Android API is 24.
The iOS target deployment API is 13.0.

## Installation
- Add the path to the Velocity specs to the head of the Pod file in the iOS folder
`source 'https://github.com/velocitycareerlabs/Specs.git'`
- SDK installation:
```js
yarn add @velocitycareerlabs/vcl-react-native
```
  or
```js
npm install @velocitycareerlabs/vcl-react-native --save
```

### Native SDK versions
By default, the package pins native iOS and Android SDK versions through
`vclNativeSdkVersions` in its `package.json`, falling back to the React Native
package version if no native pin is present.

```json
{
  "version": "2.10.0",
  "vclNativeSdkVersions": {
    "ios": "2.10.0-rc",
    "android": "2.10.0-rc"
  }
}
```

### Usage
To start using the VCL SDK, you’ll need to create its object and initialize it in Velocity Network&trade;:
```js
import vcl, {
  VCLErrorCodeCompatibilityMode,
} from '@velocitycareerlabs/vcl-react-native';
```
```js
const initializationDescriptor: VCLInitializationDescriptor = {
  environment: environment,
};
vcl.initialize(initializationDescriptor).then(
  () => {
    // Do your magic
  },
  (err: VCLError) => {
    // Handle initialization failure
  }
);
```

SDK `2.10.0` uses native taxonomy error codes by default. To temporarily
preserve legacy native error-code mappings during migration, initialize with:
```js
const initializationDescriptor: VCLInitializationDescriptor = {
  environment: environment,
  errorCodeCompatibilityMode: VCLErrorCodeCompatibilityMode.Legacy,
};
```

### Error context
When the native SDKs map a failure to a taxonomy `errorCode`, `VCLError` keeps
the original error code and the request it belongs to. Each field is an optional
string, set only when the native SDK recorded it:

| Field | Description |
| --- | --- |
| `sourceErrorCode` | The error code before the taxonomy mapping, e.g. the server's `exchange_invalid` behind `client_request_rejected`. Failures the SDK detects itself have no `payload`, so this is their only record of the cause. |
| `validationPhase` | The phase that failed: `link_validation`, `client_request_fetch`, `did_resolution`, `registration_check`, `request_validation` or `request_authorization`. |
| `requestDid` | The DID of the issuer or verifier the request was for. |
| `requestUri` | The URI of the failed request, with the `push_delegate.push_token` value replaced by `[redacted]`. |
| `requestKind` | `issuing_request` or `presentation_request`. |

```js
try {
  await vcl.getCredentialManifest(credentialManifestDescriptor);
} catch (error) {
  // error.errorCode === 'client_request_rejected'
  // error.sourceErrorCode === 'exchange_invalid'
  // error.validationPhase === 'client_request_fetch'
  // error.requestKind === 'issuing_request'
}
```

The SDK passes these values through unchanged, with one exception. When you
pass a `pushDelegate`, the native SDKs add its push URL and push token to the
request URI, so the SDK replaces the `push_delegate.push_token` value in
`requestUri` with `[redacted]`. `requestUri` can still carry other query
parameters (`exchange_id`, `credential_types`, `vendorOriginContext` and
issuer-specific values), so redact it before sending it to telemetry.

In `Legacy` mode the native SDKs clear these fields and report the error codes
they used before 2.10.0.

A rejection that does not come from a native `VCLError` is still thrown as a
`VCLError`, with the original rejection as its `cause`.

More details can be found [HERE](https://www.velocitynetwork.foundation/main/career-wallets-velocity-sdks#react-native)
