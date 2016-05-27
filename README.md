# SFFullscreenImageDetailViewController  

An interactive full screen image presentation view controller.

![image](https://media.giphy.com/media/26tnhQGdrzLsMORkA/giphy.gif)

## Usage

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

Note that you cannot present the view controller in the traditional way using `presentViewController(_:animated:completion:)`

## Installation

##### Using cocapods:

`pod 'SFFullscreenImageDetailViewController'`

##### Carthage

Not yet. But soon.

##### Source

You can also download and copy the source code into your project. There are no fancy build settings to tweak, just make sure you link against `QuartzCore` framework.

## Contribution

You are more than welcome to drop me a pull request or an issue if you find anything missing and/or would like to see added in the future.

## Authors
[JanHalozan](https://github.com/JanHalozan/)
