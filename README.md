# @velocitycareerlabs/vcl-react-native

Velocity Career Labs React Native SDK


Android:

kotlin version: 1.7.21

minSdkVersion 24

targetSdkVersion 33


iOS:

swift version: 5

deployment target: 13


React Native:

react version 18.2.0

react native version 0.72.4

# React Native SDK

The React Native SDK is a wrapper of iOS and Android SDKs.
The minimum supported Android API is 21.
The iOS target deployment API is 12.0.

## Installation
- Add the path to the Velocity specs to the head of the Pod file in the iOS folder
`source 'https://github.com/velocitycareerlabs/Specs.git'`
- SDK installation:
```js 
yarn add @velocitycareerlabs/vcl-react-native --save
```
  or
```js 
npm install @velocitycareerlabs/vcl-react-native --save
```

### Usage
To start using the VCL SDK, you’ll need to create its object and initialize it in Velocity Network&trade;:
```js
import vcl from '@velocitycareerlabs/vcl-react-native';
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
