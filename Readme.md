<p align="center">
    <img src ="screenshots/RawgBanner.png" alt="Rawg Logo" title="Rawg" />
</p>

<p align="center">
    <img src="https://img.shields.io/badge/platform-SwiftUI-blue.svg" alt="Swift UI" title="Swift UI" />
    <img src="https://img.shields.io/github/license/demola234/rawg_gammers_ios" alt="MIT License" />
    <a href="https://twitter.com/ademoladi"><img src="https://img.shields.io/twitter/url?label=Twitter&style=social&url=https%3A%2F%2Ftwitter.com%2Fademoladi" alt="Twitter: @danielsaidi" title="Twitter: @ademoladi" /></a>

</p>

## About Rawg Gammers

<p align="center">
    <img src="https://github.com/danielsaidi/OnboardingKit/releases/download/8.0.0/Demo.gif" width=350 />
</p>

RawgGammers is an iOS app that uses the RAWG API to display a list of games and their details. The app is built using SwiftUI and Combine.

## Features

<!-- List of Features -->

- [x] Display a list of games
- [x] Display game details
- [x] Search for games
- [x] Filter games by platform
- [x] Filter games by genre
- [x] Filter games by tags
- [x] Change App Icon
- [x] Change App Theme
- [x] Add Game to Favourites
- [x] Select Favourites Game Avatar for Profile
- [x] Authentication with X OAuth
- [x] Authentication with Apple Sign In
- [x] Authentication with Google Sign In

## Requirements

- iOS 14.0+
- Xcode 12.0+
- Swift 5.0+
- [RAWG API Key](https://rawg.io/apidocs)
- [Firebase Project](https://console.firebase.google.com/)
- [Google Sign In](https://developers.google.com/identity/sign-in/ios/start)
- [Apple Developer Account](https://developer.apple.com/)
- [Apple Sign In](https://developer.apple.com/documentation/authenticationservices/implementing_user_authentication_with_sign_in_with_apple)
- [Swift Package Manager](https://swift.org/package-manager/)
- [Cocoapods](https://cocoapods.org/)

## Installation

1. Clone the repository

```bash
git clone
```

2. Install dependencies

```bash
pod install
```

3. Open the project in Xcode

```bash
open RawgGammers.xcworkspace
```

4. Add your RAWG API Key to the project

```swift
// Constants.swift
static let rawgApiKey
```

5. Add your Firebase configuration file to the project

```bash
GoogleService-Info.plist
```

6. Add your Google Sign In configuration file to the project

```bash
GoogleService-Info.plist
```

7. Add your Apple Sign In configuration file to the project

```bash
Info.plist
```

8. Run the project

```bash
Cmd + R
```

## Author

- [Ademola Kolawole](https://twitter.com/ademoladi)

## License

RawgGammers is available under the MIT license. See the LICENSE file for more info.

## Acknowledgements

- [RAWG API](https://rawg.io/apidocs)
- [Firebase](https://firebase.google.com/)
