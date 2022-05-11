# Securing sensitive data using Cocoapods-Keys
plugin 'cocoapods-keys', {
  :project => "workntour",
  :target => "workntour",
  :keys => [
  "GoogleServiceDevApiKey"
  ]
}
# Uncomment the next line to define a global platform for your project
platform :ios, '14.0'

use_frameworks!
inhibit_all_warnings!

workspace 'workntour.xcworkspace'

def firebase
  pod 'Firebase/Crashlytics'
  pod 'Firebase/Core'
end

def common
  pod 'SwiftLint'
  pod 'Hero'
  pod 'CombineDataSources'
end

def logging
  pod 'SwiftyBeaver'
end

target 'workntour' do
  inherit! :search_paths

  logging
  common
  firebase

end

target 'Networking' do
  project 'Networking/Networking.xcodeproj'
  logging

  target 'NetworkingTests' do
  end
end
