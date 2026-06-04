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

More details can be found [HERE](https://www.velocitynetwork.foundation/main/career-wallets-velocity-sdks#react-native)
