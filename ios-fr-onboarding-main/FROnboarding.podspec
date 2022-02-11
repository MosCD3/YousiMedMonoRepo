#
#  Be sure to run `pod spec lint FROnboarding.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|
  spec.name         = "FROnboarding"
  spec.version      = "0.0.6"
  spec.summary      = "Onboarding module for Scobrea Apps"
  spec.description  = <<-DESC
  This is a private onboarding module for scobrea apps
                   DESC

  spec.homepage     = "https://scobrea.com"
  spec.license      = "MIT"
  spec.author       = { "Mostafa Gamal" => "moscd3@gmail.com" }
  spec.platform     = :ios
  spec.ios.deployment_target = "13.0"
  spec.swift_version = '5.0'
  spec.source       = { :git => "https://github.com/Scobrea/ios-fr-onboarding", :tag => "#{spec.version}" }
  spec.source_files  = "FROnboarding/**/*.{swift,h,m}"
  spec.resource_bundles = {
    'FROnboarding' => ['FROnboarding/**/*.xib']
  }
  spec.requires_arc = true

end
