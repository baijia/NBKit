source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '7.0'

inhibit_all_warnings!

# Uncomment this line if you're using Swift
# use_frameworks!

target 'NBKitDev' do
    
    pod 'NBKit', :path => './'
    
    # pod 'ELCImagePickerController'
    pod 'M9Dev', :git => 'https://github.com/iwill/M9Dev.git', :branch => 'public'
    
    # pod 'CocoaLumberjack'
    pod 'FLEX', :configurations => ['Debug']
    
    target 'NBKitDevTests' do
        inherit! :search_paths
        # Pods for testing
    end
    
    target 'NBKitDevUITests' do
        inherit! :search_paths
        # Pods for testing
    end
    
end
