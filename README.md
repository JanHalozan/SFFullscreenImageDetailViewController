# SFFullscreenImageDetailViewController
An interactive way to present images full screen

![image](http://i.imgur.com/yAOtYG4.gifv)

##Usage

Using `SFFullscreenImageDetailViewController` couldn't be simpler. Here's a two liner for ya:

```swift
let viewController = SFFullscreenImageDetailViewController(imageView: yourImageViewToPresent)
viewController.presentInCurrentKeyWindow()
```

And the good ol' `ObjC`:

```objc
SFFullscreenImageDetailViewController *viewController = [[SFFullscreenImageDetailViewController alloc] initWithImageView:yourImageViewToPresent];
[viewController presentInCurrentKeyWindow];
```

##Installation

Currently `SFFullscreenImageDetailViewController` is only available via direct download and inclusion of the source code into your project. There are no fancy build settings to tweak, just make sure you link against `QuartzCore` framework.

I plan to add Carthage and CocoaPods support as soon as possible. Stay tuned.

##Contribution

You are more than welcome to drop me a pull request or an issue if you find anything missing and/or would like to see added in the future.

##Authors
[JanHalozan](https://github.com/JanHalozan/)
