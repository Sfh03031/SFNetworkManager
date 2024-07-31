#
# Be sure to run `pod lib lint SFNetworkManager.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SFNetworkManager'
  s.version          = '0.1.3'
  s.summary          = 'A network request framework based on Moya and HandyJSON, which can return an object model that follows the HandyJSON protocol and can be flexibly customized according to needs.(zh: 基于Moya、HandyJSON的网络请求框架，可返回遵循HandyJSON协议的对象模型，可根据需求灵活自定义。)'
  s.description      = <<-DESC
  A network request framework based on Moya and HandyJSON, which can return an object model that follows the HandyJSON protocol and can be flexibly customized according to needs.I have written several examples to demonstrate usage, and the object model can be customized according to requirements by following the HandyJSON protocol.(zh: 基于Moya、HandyJSON的网络请求框架，可返回遵循HandyJSON协议的对象模型，可根据需求灵活自定义。写了几个例子展示用法，对象模型可按需求进行自定义，只需遵循HandyJSON协议即可。)
                       DESC
  s.homepage         = 'https://github.com/Sfh03031/SFNetworkManager'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Sfh03031' => 'sfh894645252@163.com' }
  s.source           = { :git => 'https://github.com/Sfh03031/SFNetworkManager.git', :tag => s.version.to_s }
  s.requires_arc     = true
  s.swift_versions   = '5.0'
  s.platform         = :ios, '12.0'
  s.source_files     = 'SFNetworkManager/Classes/**/*'
  
  s.dependency 'Moya'
  s.dependency 'HandyJSON'
  s.dependency 'SFNetworkMonitor', '~> 0.1.6'
  s.dependency 'NVActivityIndicatorView'
  
end
