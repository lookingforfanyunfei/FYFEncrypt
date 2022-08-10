#
# Be sure to run `pod lib lint FYFEncrypt.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'FYFEncrypt'
  s.version          = '0.1.0'
  s.summary          = 'A short description of FYFEncrypt.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/786452470@qq.com/FYFEncrypt'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '786452470@qq.com' => 'fyf786452470@gmail.com' }
  s.source           = { :git => 'https://github.com/lookingforfanyunfei/FYFEncrypt.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  # s.source_files = 'FYFEncrypt/Classes/**/*'
  # 组件支持的架构，并且module化，为后期组件混编做准备，也为了规范化管理
  s.pod_target_xcconfig = {
    'VALID_ARCHS' => 'arm64e arm64 armv7 armv7s x86_64',
    'DEFINES_MODULE' => 'YES'
  }
  
  # 组件支持swift混编的版本
  s.swift_versions = ['5.1', '5.2','5.3', '5.4']
  s.static_framework = true
  # 默认base64, md5
  s.default_subspecs = ['base64','md5']
  
  s.subspec 'base64' do |sp|
    sp.source_files = ['FYFEncrypt/Classes/base64/*.{h,m}','FYFEncrypt/Classes/base64/gtm/*.{h,m}']
    sp.public_header_files = 'FYFEncrypt/Classes/base64/*.h'
    
  end
  
  s.subspec 'aes' do |sp|
    sp.source_files = ['FYFEncrypt/Classes/aes/*.{h,m}']
    sp.public_header_files = 'FYFEncrypt/Classes/aes/*.h'
    sp.dependency 'FYFEncrypt/base64'
    
  end
  
  
  s.subspec 'des' do |sp|
    sp.source_files = ['FYFEncrypt/Classes/des/*.{h,m}']
    sp.public_header_files = 'FYFEncrypt/Classes/des/*.h'
    sp.dependency 'FYFEncrypt/base64'
    
  end
  
  s.subspec 'hex' do |sp|
    sp.source_files = ['FYFEncrypt/Classes/hex/*.{h,m}']
    sp.public_header_files = 'FYFEncrypt/Classes/hex/*.h'
    
  end
  
  s.subspec 'md5' do |sp|
    sp.source_files = ['FYFEncrypt/Classes/md5/*.{h,m}']
    sp.public_header_files = 'FYFEncrypt/Classes/md5/*.h'
    
  end
  
  s.subspec 'rsa' do |sp|
    sp.source_files = ['FYFEncrypt/Classes/rsa/*.{h,m,mm}']
    sp.public_header_files = 'FYFEncrypt/Classes/rsa/*.h'
    sp.libraries =  'c++'
    sp.dependency 'FYFOpenSSL'
    sp.dependency 'FYFEncrypt/hex'
    
  end
  
  s.dependency 'FYFCategory'
  
end
