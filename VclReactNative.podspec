require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

vcl_native_sdk_versions = package["vclNativeSdkVersions"] || {}
vcl_ios_sdk_version = [
  vcl_native_sdk_versions["ios"],
  package["version"]
].find { |value| !value.nil? && !value.to_s.strip.empty? }

Pod::Spec.new do |s|
  s.name         = "VclReactNative"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.homepage     = package["homepage"]
  s.license      = package["license"]
  s.authors      = package["author"]

  s.platforms    = { :ios => min_ios_version_supported }
  s.source       = { :git => "https://github.com/velocitycareerlabs/vcl-react-native.git", :tag => "#{s.version}" }

  s.source_files = "ios/**/*.{h,m,mm,cpp,swift}"
  s.private_header_files = "ios/**/*.h"

  s.swift_version = "5.0"

  s.dependency "VCL", vcl_ios_sdk_version

  install_modules_dependencies(s)
end
