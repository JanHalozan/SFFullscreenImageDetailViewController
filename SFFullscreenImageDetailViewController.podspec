Pod::Spec.new do |s|
  s.name             = 'SFFullscreenImageDetailViewController'
  s.version          = '0.1.0'
  s.summary          = 'An interactive full screen image presentation view controller.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
An UIViewController which presents a given image view in full screen and allows for fully dynamic and interactive behaviour. Both presentation and dismissal are animated and dismissal is fully interactive. User can also zoom the photo.
                       DESC

  s.homepage         = 'https://github.com/JanHalozan/SFFullscreenImageDetailViewController'
  s.screenshots      = 'https://camo.githubusercontent.com/44534e658201734106fbaf2dd7bbdb93ed018fa1/68747470733a2f2f6d656469612e67697068792e636f6d2f6d656469612f3236746e68514764727a4c734d4f526b412f67697068792e676966'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Jan Haložan' => 'j.halozan.services@gmail.com' }
  s.source           = { :git => 'https://github.com/JanHalozan/SFFullscreenImageDetailViewController.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/JanHalozan'

  s.ios.deployment_target = '8.0'

  s.source_files = 'SFFullscreenImageDetailViewController/*'

  s.resource_bundles = {
    'SFFullscreenImageDetailViewController' => ['SFFullscreenImageDetailViewController/Assets/*.png']
  }

  s.frameworks = 'UIKit', 'QuartzCore'
end
