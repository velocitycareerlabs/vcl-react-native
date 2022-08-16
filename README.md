# @velocitycareerlabs/vcl-react-native

Velocity Career Labs React Native SDK

## Installation
 
Note that you should have access to [vcl-react-native](https://github.com/velocitycareerlabs/vcl-react-native) repository to be able to use the library

Note that SDK currently doesn't support projects with **IOS version < 11**
### Common steps

#### authenticate to GitHub Packages

To authenticate by adding your personal access token to your `~/.npmrc` file, edit the `~/.npmrc` file for your project to include the following line, replacing TOKEN with your personal access token. Create a new ~/.npmrc file if one doesn't exist.

```sh
//npm.pkg.github.com/:_authToken=TOKEN
```

To authenticate by logging in to npm, use the `npm login` command, replacing USERNAME with your GitHub username, TOKEN with your personal access token, and PUBLIC-EMAIL-ADDRESS with your email address.

For more details please follow [Working with the npm registry
](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-npm-registry) documentation

#### install library

Yarn:

```sh
yarn add @velocitycareerlabs/vcl-react-native --save
```

npm:

```sh
npm install @velocitycareerlabs/vcl-react-native --save
```

### Platform-specific steps

#### iOS

##### 1. Swift support step

If you have no Swift integration in your project follow next steps:

1. In XCode, in the project navigator, right click your `[your project's name]` folder, choose ➜ `Add Files to [your project's name]`

2. Select `Swift File` ➜ `Next`

3. Specify name for example `Dummy.swift` ➜ `Create`

4. Now a pop up is shown select `Create Bridging Header`


##### 2. Pods installation step


1. Add next lines in the beginning of `Podfile`:

```rb
source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/velocitycareerlabs/Specs.git'
```

2. Add link path to `vcl-react-native` into target in `Podfile`:
```rb
pod 'vcl-react-native', :path => '../node_modules/@velocitycareerlabs/vcl-react-native'
```

3. Install pods:

```bash
cd ios && pod install && cd ..
```


#### Android

##### 1. Store your GitHub - Personal Access Token details

- Create a `github.properties` file within your root Android project
- In case of a public repository make sure you add this file to .gitignore to keep the token private
- Add properties gpr.usr=GITHUB_USERID and gpr.key=PERSONAL_ACCESS_TOKEN
```rb
gpr.usr=GITHUB_USERID
gpr.key=PERSONAL_ACCESS_TOKEN
```
- Replace GITHUB_USERID with personal / organisation Github User ID and PERSONAL_ACCESS_TOKEN with the token generated in #Step 1


##### 2. Update build.gradle inside the application module 

- Add the following code to build.gradle inside the application module that will be using the VCL SDK

```sh
def githubProperties = new Properties()
githubProperties.load(new FileInputStream(rootProject.file("github.properties")))
```

```sh
repositories {        
    maven {
        name = "GitHubPackages"
        url = uri("https://maven.pkg.github.com/velocitycareerlabs/VCL-Kotlin")
        credentials {
            username = githubProperties['gpr.usr'] ?: System.getenv("GPR_USER")
            password = githubProperties['gpr.key'] ?: System.getenv("GPR_API_KEY")
        }
    }
}
```

## Usage

```js
import VclReactNative from "@velocitycareerlabs/vcl-react-native";

// ...

const result = await VclReactNative.initialize();
```

## License

MIT
