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

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
    end
  end
end
