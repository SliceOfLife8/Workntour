# Uncomment the next line to define a global platform for your project
platform :ios, '15.0'

use_frameworks!
inhibit_all_warnings!

workspace 'workntour.xcworkspace'

def firebase
  pod 'Firebase/Crashlytics'
  pod 'Firebase/Core'
end

def kingfisher
  pod 'Kingfisher'
end

def snapkit
  pod 'FlexiblePageControl'
  pod 'SnapKit'
end

def common
  pod 'DropDown'
  pod 'NVActivityIndicatorView'
  pod 'EasyTipView'
  pod 'KDCircularProgress'
  pod 'HorizonCalendar'
  pod 'FloatingPanel'
  pod 'GooglePlaces'
  pod 'SkeletonView'
  pod 'Cluster'
end

def logging
  pod 'SwiftyBeaver'
end

target 'workntour' do
  inherit! :search_paths

  logging
  common
  firebase
  kingfisher
  snapkit
end

target 'Networking' do
  project 'Networking/Networking.xcodeproj'
  logging

  target 'NetworkingTests' do
  end
end

target 'CommonUI' do
  project 'CommonUI/CommonUI.xcodeproj'
  kingfisher
  snapkit
  pod 'NVActivityIndicatorView'
  pod 'KDCircularProgress'

  target 'CommonUITests' do
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
    end
  end
end
