source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

def shared_pods_for_target
    pod 'Kingfisher'
    pod 'Fabric'
    pod 'Crashlytics', '~>  3.12'
    pod 'MapKitGoogleStyler'
end

target 'ADSB Radar' do
    shared_pods_for_target
    pod 'NVActivityIndicatorView', :path => '../../NVActivityIndicatorView/'
end

target 'ADSB RadarTests' do
    shared_pods_for_target
end

target 'ADSB RadarUITests' do
    shared_pods_for_target
end
