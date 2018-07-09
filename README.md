# RKKeyboardManager

[![CI Status](https://img.shields.io/travis/DaskiOFF/RKKeyboardManager.svg?style=flat)](https://travis-ci.org/DaskiOFF/RKKeyboardManager)
[![Cocoapods compatible](https://img.shields.io/badge/Cocoapods-compatible-4BC51D.svg?style=flat)](https://cocoapods.org/)
[![Version](https://img.shields.io/cocoapods/v/RKKeyboardManager.svg?style=flat)](https://cocoapods.org/pods/RKKeyboardManager)
[![Platform iOS](https://img.shields.io/cocoapods/p/RKKeyboardManager.svg?style=flat)](https://cocoapods.org/pods/RKKeyboardManager)
[![Swift Version 4.1](https://img.shields.io/badge/Swift-4.1-brightgreen.svg?style=flat)](https://developer.apple.com/swift)
[![License MIT](https://img.shields.io/cocoapods/l/RKKeyboardManager.svg?style=flat)](https://cocoapods.org/pods/RKKeyboardManager)

## Usage

```swift
let scrollView = UIScrollView()

let keyboardManager = RKKeyboardManager()
// or let keyboardManager = RKKeyboardManager(scrollView: scrollView)

// keyboardManager.subscribe()
// keyboardManager.unsubscribe()

func setupKeyboardManager() {
    keyboardManager.setOnWillChangeFrameBlock { [weak self] keyboardFrame, keyboardEvent in
        guard let sself = self else { return }
        switch keyboardEvent {
        case .willShow, .justChange:
            // do ...
        case .willHide:
            // do ...
        }
    }
}
```

## Requirements

## Installation

RKKeyboardManager is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'RKKeyboardManager'
```

## Author

DaskiOFF, waydeveloper@gmail.com

## License

RKKeyboardManager is available under the MIT license. See the LICENSE file for more info.

## [Dependencies](https://ios-factor.com/dependencies)
Последний раз проект собирался с версией **Xcode** указанной в файле ```.xcode-version``` ([Подробнее](https://github.com/fastlane/ci/blob/master/docs/xcode-version.md))

Последний раз проект собирался с версией **Swift** указанной в файле ```.swift-version```
