#
# Be sure to run `pod spec lint NAME.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# To learn more about the attributes see http://docs.cocoapods.org/specification.html
#
Pod::Spec.new do |fishlamp|
   
    fishlamp.name         = "FishLamp"
    fishlamp.version      = "3.0.0"
    fishlamp.summary      = "This is the core functionality of the FishLamp Framework."
    fishlamp.homepage     = "http://fishlamp.com"
    fishlamp.license      = 'MIT'
    fishlamp.author       = { "Mike Fullerton" => "hello@fishlamp.com" }
    fishlamp.source       = { :git => "https://github.com/fishlamp/fishlamp-cocoa.git", :tag => fishlamp.version.to_s }

    fishlamp.ios.deployment_target = '6.1'
    fishlamp.osx.deployment_target = '10.6'
    fishlamp.requires_arc = false
    
    fishlamp.ios.frameworks = 'Security', 'MobileCoreServices', 'SystemConfiguration'
    fishlamp.osx.frameworks = 'CoreServices', 'Security', 'SystemConfiguration', 'ApplicationServices', 'Quartz', 'QuartzCore', 'CoreFoundation',  'Foundation'

# these are the core pods

  	fishlamp.subspec 'Cocoa' do |cocoa|

        cocoa.subspec 'Core' do |core|
            core.source_files = 'Cocoa/Classes/FishLampCore.h'

            core.subspec 'Required' do |ss|
                ss.source_files = 'Cocoa/Classes/Required/**/*.{h,m}'
            end

            core.subspec 'Strings' do |ss|
                ss.source_files = 'Cocoa/Classes/Strings/**/*.{h,m}'
            end

            core.subspec 'Errors' do |ss|
                ss.dependency 'FishLamp/Cocoa/Core/Required'
                ss.dependency 'FishLamp/Cocoa/Core/Strings'
                ss.source_files = 'Cocoa/Classes/Errors/**/*.{h,m}'
            end

            core.subspec 'Assertions' do |ss|
                ss.source_files = 'Cocoa/Classes/Assertions/**/*.{h,m}'
                ss.dependency 'FishLamp/Cocoa/Core/Strings'
                ss.dependency 'FishLamp/Cocoa/Core/Errors'
            end

            core.subspec 'SimpleLogger' do |ss|
                ss.dependency 'FishLamp/Cocoa/Core/Required'
                ss.dependency 'FishLamp/Cocoa/Core/Strings'
                ss.dependency 'FishLamp/Cocoa/Core/Errors'
                ss.dependency 'FishLamp/Cocoa/Core/Assertions'
                ss.source_files = 'Cocoa/Classes/SimpleLogger/**/*.{h,m}'
            end
        end

# small util pods

        cocoa.subspec 'Utils' do |utils|

            utils.subspec 'Proxies' do |ss|
                ss.dependency 'FishLamp/Cocoa/Core'
                ss.source_files = 'Cocoa/Classes/Proxies/**/*.{h,m}'
            end

            utils.subspec 'ActivityLog' do |ss|
                ss.dependency 'FishLamp/Cocoa/Core'
                ss.source_files = 'Cocoa/Classes/ActivityLog/**/*.{h,m}'
            end

            utils.subspec 'ObjcRuntime' do |ss|
                ss.source_files = 'Cocoa/Classes/ObjcRuntime/**/*.{h,m}'
            end

            utils.subspec 'BundleUtils' do |ss|
                ss.dependency 'FishLamp/Cocoa/Core'
                ss.source_files = 'Cocoa/Classes/BundleUtils/**/*.{h,m}'
            end

            utils.subspec 'CodeBuilder' do |ss|
                ss.dependency 'FishLamp/Cocoa/Core'
                ss.source_files = 'Cocoa/Classes/CodeBuilder/**/*.{h,m}'
            end

            utils.subspec 'ColorUtils' do |ss|
                ss.dependency 'FishLamp/Cocoa/Core'
                ss.source_files = 'Cocoa/Classes/ColorUtils/**/*.{h,m}'
            end

            utils.subspec 'Containers' do |ss|
                ss.dependency 'FishLamp/Cocoa/Core'
                ss.source_files = 'Cocoa/Classes/Containers/**/*.{h,m}'
            end

            utils.subspec 'Events' do |ss|
                ss.dependency 'FishLamp/Cocoa/Core'
                ss.source_files = 'Cocoa/Classes/Events/**/*.{h,m}'
            end

            utils.subspec 'Files' do |ss|
                ss.dependency 'FishLamp/Cocoa/Core'
                ss.source_files = 'Cocoa/Classes/Files/**/*.{h,m}'
            end

            utils.subspec 'Geometry' do |ss|
                ss.dependency 'FishLamp/Cocoa/Core'
                ss.source_files = 'Cocoa/Classes/Geometry/**/*.{h,m}'
            end

            utils.subspec 'Keychain' do |ss|
                ss.dependency 'FishLamp/Cocoa/Core'
                ss.source_files = 'Cocoa/Classes/Keychain/**/*.{h,m}'
            end

            utils.subspec 'Notifications' do |ss|
                ss.source_files = 'Cocoa/Classes/Notifications/**/*.{h,m}'
                ss.dependency 'FishLamp/Cocoa/Core'
            end

            utils.subspec 'Authentication' do |ss|
                ss.dependency 'FishLamp/Cocoa/Core'
                ss.source_files = 'Cocoa/Classes/Authentication/**/*.{h,m}'
            end

            utils.subspec 'Compatibility' do |ss|
                ss.dependency 'FishLamp/Cocoa/Core'
                ss.source_files = 'Cocoa/Classes/Compatibility/**/*.{h,m}'
            end

            utils.subspec 'Services' do |ss|
                ss.source_files = 'Cocoa/Classes/Services/**/*.{h,m}'
                ss.dependency 'FishLamp/Cocoa/Core'
            end

            utils.subspec 'StringBuilder' do |ss|
                ss.dependency 'FishLamp/Cocoa/Core'
                ss.source_files = 'Cocoa/Classes/StringBuilder/**/*.{h,m}'
            end

            utils.subspec 'Timer' do |ss|
                ss.source_files = 'Cocoa/Classes/Timer/**/*.{h,m}'
            end

            utils.subspec 'Utils' do |ss|
                ss.source_files = 'Cocoa/Classes/Utils/**/*.{h,m}'
            end
        end

    # big features

        cocoa.subspec 'Features' do |feature|

            feature.subspec 'Encoding' do |ss|
                ss.dependency 'FishLamp/Cocoa/Core'
                ss.source_files = 'Cocoa/Classes/Encoding/**/*.{h,m,c}'
            end

            feature.subspec 'CommandLineProcessor' do |ss|
                ss.source_files = 'Cocoa/Classes/CommandLineProcessor/**/*.{h,m}'
            end

            feature.subspec 'Testables' do |ss|
                ss.source_files = 'Cocoa/Classes/Testables/**/*.{h,m}'
            end

            feature.subspec 'ModelObject' do |ss|
                ss.dependency 'FishLamp/Cocoa/Core'
                ss.source_files = 'Cocoa/Classes/ModelObject/**/*.{h,m}'
            end

            feature.subspec 'Async' do |ss|
                ss.dependency 'FishLamp/Cocoa/Core'
                ss.dependency 'FishLamp/Cocoa/Utils/Timer'
                ss.source_files = 'Cocoa/Classes/Async/**/*.{h,m}'
            end

            feature.subspec 'Storage' do |ss|
                ss.source_files = 'Cocoa/Classes/Storage/**/*.{h,m}'
                ss.library = 'sqlite3'
                ss.dependency 'FishLamp/Cocoa/Core'
            end

            feature.subspec 'Networking' do |networking|
                networking.source_files = 'Cocoa/Classes/Networking/**/*.{h,m}'

                networking.dependency 'FishLamp/Cocoa/Core'
                
                networking.dependency 'FishLamp/Cocoa/Utils/Authentication'
                networking.dependency 'FishLamp/Cocoa/Utils/BundleUtils'
                networking.dependency 'FishLamp/Cocoa/Utils/CodeBuilder'
                networking.dependency 'FishLamp/Cocoa/Utils/Services'
                networking.dependency 'FishLamp/Cocoa/Utils/StringBuilder'
                networking.dependency 'FishLamp/Cocoa/Utils/Timer'
        
                networking.dependency 'FishLamp/Cocoa/Features/Encoding'
                networking.dependency 'FishLamp/Cocoa/Features/Async'
                networking.dependency 'FishLamp/Cocoa/Features/ModelObject'

                networking.ios.frameworks = 'CFNetwork'
                networking.osx.frameworks = 'CFNetwork'
            end
        end
    end
end

