#
# Be sure to run `pod lib lint UnReadBubbleView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'UnReadBubbleView'
  s.version          = '0.1.0'
  s.summary          = '类似qq的可拖拽气泡'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
提供可拖拽功能的气泡类似qq的未读信息
                       DESC

  s.homepage         = 'https://github.com/wang937606063/UnReadBubbleView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'wang937606063' => '937606063@qq.com' }
  s.source           = { :git => 'https://github.com/wang937606063/UnReadBubbleView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'UnReadBubbleView/Classes/**/*'
  
   s.resource_bundles = {
     'UnReadBubbleView' => ['UnReadBubbleView/Assets/*']
   }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
