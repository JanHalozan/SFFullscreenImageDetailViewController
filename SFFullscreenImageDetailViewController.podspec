Pod::Spec.new do |s|
  s.name             = 'SFFullscreenImageDetailViewController'
  s.version          = '0.1.2'
  s.summary          = 'An interactive full screen image presentation view controller.'

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

  s.source_files = 'SFFullscreenImageDetailViewController'

  s.resource_bundles = {
    'SFFullscreenImageDetailViewController' => ['SFFullscreenImageDetailViewController/Assets/*.png']
  }

  s.requires_arc = true
  s.frameworks = 'UIKit', 'QuartzCore'
end
