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
            core.source_files = 'FishLampCocoa/Classes/FishLampCore.h'

            core.subspec 'Required' do |ss|
                ss.source_files = 'FishLampCocoa/Classes/Required/**/*.{h,m}'
            end

            core.subspec 'Strings' do |ss|
                ss.source_files = 'FishLampCocoa/Classes/Strings/**/*.{h,m}'
            end

            core.subspec 'Errors' do |ss|
                ss.dependency 'FishLamp/Cocoa/Core/Required'
                ss.dependency 'FishLamp/Cocoa/Core/Strings'
                ss.source_files = 'FishLampCocoa/Classes/Errors/**/*.{h,m}'
            end

            core.subspec 'Assertions' do |ss|
                ss.source_files = 'FishLampCocoa/Classes/Assertions/**/*.{h,m}'
                ss.dependency 'FishLamp/Cocoa/Core/Strings'
                ss.dependency 'FishLamp/Cocoa/Core/Errors'
            end

            core.subspec 'SimpleLogger' do |ss|
                ss.dependency 'FishLamp/Cocoa/Core/Required'
                ss.dependency 'FishLamp/Cocoa/Core/Strings'
                ss.dependency 'FishLamp/Cocoa/Core/Errors'
                ss.dependency 'FishLamp/Cocoa/Core/Assertions'
                ss.source_files = 'FishLampCocoa/Classes/SimpleLogger/**/*.{h,m}'
            end
        end

# small util pods

        cocoa.subspec 'Utils' do |utils|

            utils.subspec 'Proxies' do |ss|
                ss.dependency 'FishLamp/Cocoa/Core'
                ss.source_files = 'FishLampCocoa/Classes/Proxies/**/*.{h,m}'
            end

            utils.subspec 'ActivityLog' do |ss|
                ss.dependency 'FishLamp/Cocoa/Core'
                ss.source_files = 'FishLampCocoa/Classes/ActivityLog/**/*.{h,m}'
            end

            utils.subspec 'ObjcRuntime' do |ss|
                ss.source_files = 'FishLampCocoa/Classes/ObjcRuntime/**/*.{h,m}'
            end

            utils.subspec 'BundleUtils' do |ss|
                ss.dependency 'FishLamp/Cocoa/Core'
                ss.source_files = 'FishLampCocoa/Classes/BundleUtils/**/*.{h,m}'
            end

            utils.subspec 'CodeBuilder' do |ss|
                ss.dependency 'FishLamp/Cocoa/Core'
                ss.source_files = 'FishLampCocoa/Classes/CodeBuilder/**/*.{h,m}'
            end

            utils.subspec 'ColorUtils' do |ss|
                ss.dependency 'FishLamp/Cocoa/Core'
                ss.source_files = 'FishLampCocoa/Classes/ColorUtils/**/*.{h,m}'
            end

            utils.subspec 'Containers' do |ss|
                ss.dependency 'FishLamp/Cocoa/Core'
                ss.source_files = 'FishLampCocoa/Classes/Containers/**/*.{h,m}'
            end

            utils.subspec 'Events' do |ss|
                ss.dependency 'FishLamp/Cocoa/Core'
                ss.source_files = 'FishLampCocoa/Classes/Events/**/*.{h,m}'
            end

            utils.subspec 'Files' do |ss|
                ss.dependency 'FishLamp/Cocoa/Core'
                ss.source_files = 'FishLampCocoa/Classes/Files/**/*.{h,m}'
            end

            utils.subspec 'Geometry' do |ss|
                ss.dependency 'FishLamp/Cocoa/Core'
                ss.source_files = 'FishLampCocoa/Classes/Geometry/**/*.{h,m}'
            end

            utils.subspec 'Keychain' do |ss|
                ss.dependency 'FishLamp/Cocoa/Core'
                ss.source_files = 'FishLampCocoa/Classes/Keychain/**/*.{h,m}'
            end

            utils.subspec 'Notifications' do |ss|
                ss.source_files = 'FishLampCocoa/Classes/Notifications/**/*.{h,m}'
                ss.dependency 'FishLamp/Cocoa/Core'
            end

            utils.subspec 'Authentication' do |ss|
                ss.dependency 'FishLamp/Cocoa/Core'
                ss.source_files = 'FishLampCocoa/Classes/Authentication/**/*.{h,m}'
            end

            utils.subspec 'Compatibility' do |ss|
                ss.dependency 'FishLamp/Cocoa/Core'
                ss.source_files = 'FishLampCocoa/Classes/Compatibility/**/*.{h,m}'
            end

            utils.subspec 'Services' do |ss|
                ss.source_files = 'FishLampCocoa/Classes/Services/**/*.{h,m}'
                ss.dependency 'FishLamp/Cocoa/Core'
            end

            utils.subspec 'StringBuilder' do |ss|
                ss.dependency 'FishLamp/Cocoa/Core'
                ss.source_files = 'FishLampCocoa/Classes/StringBuilder/**/*.{h,m}'
            end

            utils.subspec 'Timer' do |ss|
                ss.source_files = 'FishLampCocoa/Classes/Timer/**/*.{h,m}'
            end

            utils.subspec 'Utils' do |ss|
                ss.source_files = 'FishLampCocoa/Classes/Utils/**/*.{h,m}'
            end
        end

    # big features

        cocoa.subspec 'Features' do |feature|

            feature.subspec 'Encoding' do |ss|
                ss.dependency 'FishLamp/Cocoa/Core'
                ss.source_files = 'FishLampCocoa/Classes/Encoding/**/*.{h,m,c}'
            end

            feature.subspec 'CommandLineProcessor' do |ss|
                ss.source_files = 'FishLampCocoa/Classes/CommandLineProcessor/**/*.{h,m}'
            end

            feature.subspec 'Testables' do |ss|
                ss.source_files = 'FishLampCocoa/Classes/Testables/**/*.{h,m}'
            end

            feature.subspec 'ModelObject' do |ss|
                ss.dependency 'FishLamp/Cocoa/Core'
                ss.source_files = 'FishLampCocoa/Classes/ModelObject/**/*.{h,m}'
            end

            feature.subspec 'Async' do |ss|
                ss.dependency 'FishLamp/Cocoa/Core'
                ss.dependency 'FishLamp/Cocoa/Utils/Timer'
                ss.source_files = 'FishLampCocoa/Classes/Async/**/*.{h,m}'
            end

            feature.subspec 'Storage' do |ss|
                ss.dependency 'FishLamp/Cocoa/Core'
                ss.source_files = 'FishLampCocoa/Classes/Storage/**/*.{h,m}'
                ss.library = 'sqlite3'
            end

            feature.subspec 'Networking' do |networking|

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

                networking.source_files = 'FishLampCocoa/Classes/Networking/**/*.{h,m}'
            end
        end
    end

  	fishlamp.subspec 'CodeGenerator' do |code_generator|
  #      code_generator.dependency 'FishLamp/Cocoa/Core'
		code_generator.source_files = 'FishLampCodeGenerator/Classes/**/*.{h,m}'

		code_generator.subspec 'Core' do |ss|
			ss.source_files = 'FishLampCodeGenerator/Core/**/*.{h,m}'
		end

		code_generator.subspec 'Objc' do |ss|
			ss.source_files = 'FishLampCodeGenerator/Objc/**/*.{h,m}'
		end
    end
    
  	fishlamp.subspec 'UI' do |ui|
        ui.dependency 'FishLamp/Cocoa/Core'

		ui.subspec 'Animate' do |ss|
			ss.source_files = 'FishLampUI/Classes/Animate/**/*.{h,m}'
		end

		ui.subspec 'Draw' do |ss|
			ss.source_files = 'FishLampUI/Classes/Draw/**/*.{h,m}'
		end

		ui.subspec 'View' do |ss|
			ss.source_files = 'FishLampUI/Classes/View/**/*.{h,m}'
		end
	end
    
    
  	fishlamp.subspec 'OSX' do |osx|
        osx.dependency 'FishLamp/Cocoa/Core'
        osx.dependency 'FishLamp/UI'

	    osx.osx.frameworks = 'Cocoa'
		osx.osx.resources = ['FishLampOSX/Resources/Images/*.png', 'FishLampOSX/Resources/xib/*']
    
    	osx.source_files = 'FishLampOSX/Classes/FishLamp-OSX.h'
    
		osx.subspec 'BreadcrumbBarView' do |ss|
			ss.source_files = 'FishLampOSX/Classes/BreadcrumbBarView/**/*.{h,m}'
		end

		osx.subspec 'CommandLineTool' do |ss|
			ss.source_files = 'FishLampOSX/Classes/CommandLineTool/**/*.{h,m}'
		end

		osx.subspec 'Documents' do |ss|
			ss.source_files = 'FishLampOSX/Classes/Documents/**/*.{h,m}'
		end

		osx.subspec 'Image' do |ss|
			ss.source_files = 'FishLampOSX/Classes/Image/**/*.{h,m}'
		end

		osx.subspec 'Menus' do |ss|
			ss.source_files = 'FishLampOSX/Classes/Menus/**/*.{h,m}'
		end

		osx.subspec 'Utils' do |ss|
			ss.source_files = 'FishLampOSX/Classes/Utils/**/*.{h,m}'
		end

		osx.subspec 'ViewControllers' do |ss|
			ss.source_files = 'FishLampOSX/Classes/ViewControllers/**/*.{h,m}'
		end

		osx.subspec 'Views' do |ss|
			ss.source_files = 'FishLampOSX/Classes/Views/**/*.{h,m}'
		end

		osx.subspec 'Wizard' do |ss|
			ss.source_files = 'FishLampOSX/Classes/Wizard/**/*.{h,m}'
		end

	end
    
end

