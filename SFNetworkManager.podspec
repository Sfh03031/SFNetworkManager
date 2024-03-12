#
# Be sure to run `pod lib lint SFNetworkManager.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SFNetworkManager'
  s.version          = '0.1.0'
  s.summary          = '基于Moya、HandyJSON的网络请求框架，可返回遵循HandyJSON协议的对象模型，可根据需求灵活自定义。'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
写了几个例子展示用法，对象模型可按需求进行自定义，只需遵循HandyJSON协议即可。
                       DESC

  s.homepage         = 'https://github.com/Sfh03031/SFNetworkManager'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Sfh03031' => 'sfh894645252@163.com' }
  s.source           = { :git => 'https://github.com/Sfh03031/SFNetworkManager.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '12.0'

  s.source_files = 'SFNetworkManager/Classes/**/*'
  
  # s.resource_bundles = {
  #   'SFNetworkManager' => ['SFNetworkManager/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  
    s.dependency 'Moya'
    s.dependency 'HandyJSON'
  
end
