# Uncomment the next line to define a global platform for your project
platform :ios, '14.0'

use_frameworks!
inhibit_all_warnings!

def firebase
  pod 'Firebase/Crashlytics'
  pod 'Firebase/Core'
end

def common
  pod 'SwiftLint'
end

target 'workntour' do
  inherit! :search_paths

  common
  firebase

end
