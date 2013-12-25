#
# Be sure to run `pod spec lint NAME.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# To learn more about the attributes see http://docs.cocoapods.org/specification.html
#
Pod::Spec.new do |fishlamp|
   
    fishlamp.name         = "FishLampPrerelease"
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
	fishlamp.default_subspec = 'Core'

    fishlamp.subspec 'Core' do |core|
        core.source_files = 'FishLampCore/Classes/FishLampCore.h'

        core.subspec 'Required' do |ss|
            ss.source_files = 'FishLampCore/Classes/Required/**/*.{h,m}'
        end

        core.subspec 'Strings' do |ss|
            ss.source_files = 'FishLampCore/Classes/Strings/**/*.{h,m}'
        end

        core.subspec 'Errors' do |ss|
            ss.dependency 'FishLampPrerelease/Core/Required'
            ss.dependency 'FishLampPrerelease/Core/Strings'
            ss.source_files = 'FishLampCore/Classes/Errors/**/*.{h,m}'
        end

        core.subspec 'Assertions' do |ss|
            ss.source_files = 'FishLampCore/Classes/Assertions/**/*.{h,m}'
            ss.dependency 'FishLampPrerelease/Core/Strings'
            ss.dependency 'FishLampPrerelease/Core/Errors'
        end

        # TODO (MWF): move this out of core into cocoa
        core.subspec 'SimpleLogger' do |ss|
            ss.dependency 'FishLampPrerelease/Core/Required'
            ss.dependency 'FishLampPrerelease/Core/Strings'
            ss.dependency 'FishLampPrerelease/Core/Errors'
            ss.dependency 'FishLampPrerelease/Core/Assertions'
            ss.source_files = 'FishLampCore/Classes/SimpleLogger/**/*.{h,m}'
        end
    end

    fishlamp.subspec 'Cocoa' do |cocoa|

        cocoa.subspec 'Utils' do |ss|
            ss.dependency 'FishLampPrerelease/Core'
            ss.source_files = 'FishLampCocoa/Classes/Utils/**/*.{h,m}'
        end

        cocoa.subspec 'Proxies' do |ss|
            ss.dependency 'FishLampPrerelease/Core'
            ss.source_files = 'FishLampCocoa/Classes/Proxies/**/*.{h,m}'
        end

        cocoa.subspec 'BundleUtils' do |ss|
            ss.dependency 'FishLampPrerelease/Core'
            ss.source_files = 'FishLampCocoa/Classes/BundleUtils/**/*.{h,m}'
        end

        cocoa.subspec 'Containers' do |ss|
            ss.dependency 'FishLampPrerelease/Core'
            ss.source_files = 'FishLampCocoa/Classes/Containers/**/*.{h,m}'
        end

        cocoa.subspec 'ByteBuffer' do |ss|
            ss.dependency 'FishLampPrerelease/Core'
            ss.source_files = 'FishLampCocoa/Classes/ByteBuffer/**/*.{h,m}'
        end

        cocoa.subspec 'Events' do |ss|
            ss.dependency 'FishLampPrerelease/Core'
            ss.dependency 'FishLampPrerelease/Cocoa/Proxies'
            ss.source_files = 'FishLampCocoa/Classes/Events/**/*.{h,m}'
        end

        cocoa.subspec 'Files' do |ss|
            ss.dependency 'FishLampPrerelease/Core'
            ss.source_files = 'FishLampCocoa/Classes/Files/**/*.{h,m}'
        end

        cocoa.subspec 'Geometry' do |ss|
            ss.dependency 'FishLampPrerelease/Core'
            ss.source_files = 'FishLampCocoa/Classes/Geometry/**/*.{h,m}'
        end

        cocoa.subspec 'Keychain' do |ss|
            ss.dependency 'FishLampPrerelease/Core'
            ss.source_files = 'FishLampCocoa/Classes/Keychain/**/*.{h,m}'
        end

        cocoa.subspec 'Notifications' do |ss|
            ss.source_files = 'FishLampCocoa/Classes/Notifications/**/*.{h,m}'
            ss.dependency 'FishLampPrerelease/Core'
        end

        cocoa.subspec 'Authentication' do |ss|
            ss.dependency 'FishLampPrerelease/Core'
            ss.dependency 'FishLampPrerelease/Cocoa/Keychain'

            ss.source_files = 'FishLampCocoa/Classes/Authentication/**/*.{h,m}'
        end

        cocoa.subspec 'UserPreferences' do |ss|
            ss.dependency 'FishLampPrerelease/Core'
            ss.source_files = 'FishLampCocoa/Classes/UserPreferences/**/*.{h,m}'
        end

        cocoa.subspec 'Services' do |ss|
            ss.dependency 'FishLampPrerelease/Core'
            ss.source_files = 'FishLampCocoa/Classes/Services/**/*.{h,m}'
        end

        cocoa.subspec 'Strings' do |ss|
            ss.dependency 'FishLampPrerelease/Core'
            ss.source_files = 'FishLampCocoa/Classes/Strings/**/*.{h,m}'
        end

        cocoa.subspec 'CodeBuilder' do |ss|
            ss.dependency 'FishLampPrerelease/Core'
            ss.dependency 'FishLampPrerelease/Cocoa/Strings'
            ss.source_files = 'FishLampCocoa/Classes/CodeBuilder/**/*.{h,m}'
        end

        cocoa.subspec 'ObjcRuntime' do |ss|
            ss.dependency 'FishLampPrerelease/Core'
            ss.source_files = 'FishLampCocoa/Classes/ObjcRuntime/**/*.{h,m}'
        end

        cocoa.subspec 'Encoding' do |encoding|
            encoding.dependency 'FishLampPrerelease/Core'
            encoding.dependency 'FishLampPrerelease/Cocoa/Strings'
            encoding.dependency 'FishLampPrerelease/Cocoa/CodeBuilder'

            encoding.subspec 'Xml' do |ss|
                ss.source_files = 'FishLampCocoa/Classes/Encoding/Xml/**/*.{h,m}'
            end

            encoding.subspec 'Json' do |ss|
                ss.source_files = 'FishLampCocoa/Classes/Encoding/Json/**/*.{h,m}'
            end

            encoding.subspec 'Url' do |ss|
                ss.source_files = 'FishLampCocoa/Classes/Encoding/URL/**/*.{h,m}'
            end

            encoding.subspec 'Soap' do |ss|
                ss.source_files = 'FishLampCocoa/Classes/Encoding/Soap/**/*.{h,m}'
            end

            encoding.subspec 'Html' do |ss|
                ss.source_files = 'FishLampCocoa/Classes/Encoding/Html/**/*.{h,m}'
            end

            encoding.subspec 'Base64' do |ss|
                ss.source_files = 'FishLampCocoa/Classes/Encoding/Base64/**/*.{h,m,c}'
            end
        end

        cocoa.subspec 'ModelObject' do |ss|
            ss.dependency 'FishLampPrerelease/Core'
            ss.dependency 'FishLampPrerelease/Cocoa/ObjcRuntime'

            ss.source_files = 'FishLampCocoa/Classes/ModelObject/**/*.{h,m}'
        end

        cocoa.subspec 'CommandLineProcessor' do |ss|
            ss.dependency 'FishLampPrerelease/Core'
            ss.source_files = 'FishLampCocoa/Classes/CommandLineProcessor/**/*.{h,m}'
        end

        cocoa.subspec 'Testables' do |ss|
            ss.dependency 'FishLampPrerelease/Core'
            ss.source_files = 'FishLampCocoa/Classes/Testables/**/*.{h,m}'
        end

        cocoa.subspec 'RetryHandler' do |ss|
            ss.dependency 'FishLampPrerelease/Core'
            ss.source_files = 'FishLampCocoa/Classes/RetryHandler/**/*.{h,m}'
        end

        cocoa.subspec 'Timer' do |ss|
            ss.dependency 'FishLampPrerelease/Core'
            ss.source_files = 'FishLampCocoa/Classes/Timer/**/*.{h,m}'
        end

        cocoa.subspec 'Async' do |ss|
            ss.dependency 'FishLampPrerelease/Core'
            ss.dependency 'FishLampPrerelease/Cocoa/Timer'
            ss.dependency 'FishLampPrerelease/Cocoa/Events'

            ss.source_files = 'FishLampCocoa/Classes/Async/**/*.{h,m}'
        end

        cocoa.subspec 'Storage' do |ss|
            ss.dependency 'FishLampPrerelease/Core'
            ss.dependency 'FishLampPrerelease/Cocoa/Files'
            ss.source_files = 'FishLampCocoa/Classes/Storage/**/*.{h,m}'
        end

        cocoa.subspec 'Database' do |ss|
            ss.dependency 'FishLampPrerelease/Core'
            ss.dependency 'FishLampPrerelease/Cocoa/ModelObject'
            ss.dependency 'FishLampPrerelease/Cocoa/ObjcRuntime'

            ss.source_files = 'FishLampCocoa/Classes/Database/**/*.{h,m}'
            ss.library = 'sqlite3'
        end

        cocoa.subspec 'ObjectDatabase' do |ss|
            ss.dependency 'FishLampPrerelease/Cocoa/Database'
            ss.dependency 'FishLampPrerelease/Cocoa/Storage'
            ss.dependency 'FishLampPrerelease/Cocoa/ModelObject'
            ss.dependency 'FishLampPrerelease/Cocoa/Services'
            ss.dependency 'FishLampPrerelease/Cocoa/Async'

            ss.source_files = 'FishLampCocoa/Classes/ObjectDatabase/**/*.{h,m}'
        end

        cocoa.subspec 'Networking' do |network|

            network.dependency 'FishLampPrerelease/Core'

            network.subspec 'Activity' do |ss|
                ss.dependency 'FishLampPrerelease/Cocoa/Events'
                ss.source_files = 'FishLampCocoa/Classes/Networking/Activity/**/*.{h,m}'
            end
            
            network.subspec 'Errors' do |ss|
                ss.source_files = 'FishLampCocoa/Classes/Networking/Errors/**/*.{h,m}'
            end

            network.subspec 'Reachability' do |ss|
                ss.ios.frameworks = 'SystemConfiguration'
                ss.osx.frameworks = 'SystemConfiguration'

                ss.source_files = 'FishLampCocoa/Classes/Networking/Reachability/**/*.{h,m}'
            end

            network.subspec 'Sinks' do |ss|
                ss.source_files = 'FishLampCocoa/Classes/Networking/Sinks/**/*.{h,m}'
            end

            network.subspec 'Streams' do |ss|
                ss.dependency 'FishLampPrerelease/Cocoa/Events'
                ss.dependency 'FishLampPrerelease/Cocoa/Timer'
                ss.dependency 'FishLampPrerelease/Cocoa/Async'
                ss.dependency 'FishLampPrerelease/Cocoa/Networking/Sinks'

                ss.ios.frameworks = 'CFNetwork'
                ss.osx.frameworks = 'CFNetwork'

                ss.source_files = 'FishLampCocoa/Classes/Networking/Streams/**/*.{h,m}'
            end

            network.subspec 'ProtocolSupport' do |ss|
                ss.dependency 'FishLampPrerelease/Cocoa/Async'
                ss.dependency 'FishLampPrerelease/Cocoa/RetryHandler'
                ss.dependency 'FishLampPrerelease/Cocoa/BundleUtils'
                ss.dependency 'FishLampPrerelease/Cocoa/CodeBuilder'
                ss.dependency 'FishLampPrerelease/Cocoa/Encoding'
                ss.dependency 'FishLampPrerelease/Cocoa/ModelObject'
                ss.dependency 'FishLampPrerelease/Cocoa/Authentication'
                ss.dependency 'FishLampPrerelease/Cocoa/Services'
                ss.dependency 'FishLampPrerelease/Cocoa/Strings'
                ss.dependency 'FishLampPrerelease/Cocoa/Events'
                ss.dependency 'FishLampPrerelease/Cocoa/Timer'

                ss.dependency 'FishLampPrerelease/Cocoa/Networking/Activity'
                ss.dependency 'FishLampPrerelease/Cocoa/Networking/Streams'
                ss.dependency 'FishLampPrerelease/Cocoa/Networking/Sinks'
                ss.dependency 'FishLampPrerelease/Cocoa/Networking/Reachability'
                ss.dependency 'FishLampPrerelease/Cocoa/Networking/Errors'
            end

            network.subspec 'DNS' do |ss|
                ss.dependency 'FishLampPrerelease/Cocoa/Networking/ProtocolSupport'
                ss.source_files = 'FishLampCocoa/Classes/Networking/Protocols/DNS/**/*.{h,m}'
            end

            network.subspec 'HTTP' do |ss|
                ss.dependency 'FishLampPrerelease/Cocoa/Networking/ProtocolSupport'
                ss.source_files = 'FishLampCocoa/Classes/Networking/Protocols/HTTP/**/*.{h,m}'
            end

            network.subspec 'Json' do |ss|
                ss.dependency 'FishLampPrerelease/Cocoa/Networking/HTTP'
                ss.source_files = 'FishLampCocoa/Classes/Networking/Protocols/Json/**/*.{h,m}'
            end

            network.subspec 'Soap' do |ss|
                ss.dependency 'FishLampPrerelease/Cocoa/Networking/HTTP'
                ss.source_files = 'FishLampCocoa/Classes/Networking/Protocols/Soap/**/*.{h,m}'
            end

            network.subspec 'Oauth' do |ss|
                ss.dependency 'FishLampPrerelease/Cocoa/Networking/HTTP'
                ss.source_files = 'FishLampCocoa/Classes/Networking/Protocols/Oauth/**/*.{h,m}'
            end

            network.subspec 'Tcp' do |ss|
                ss.dependency 'FishLampPrerelease/Cocoa/Networking/ProtocolSupport'
                ss.source_files = 'FishLampCocoa/Classes/Networking/Protocols/Tcp/**/*.{h,m}'
            end

            network.subspec 'XmlRpc' do |ss|
                ss.dependency 'FishLampPrerelease/Cocoa/Networking/ProtocolSupport'
                ss.source_files = 'FishLampCocoa/Classes/Networking/Protocols/XmlRpc/**/*.{h,m}'
            end

        end

        cocoa.subspec 'CodeGenerator' do |ss|
            ss.dependency 'FishLampPrerelease/Core'
            ss.dependency 'FishLampPrerelease/Cocoa/ModelObject'
            ss.dependency 'FishLampPrerelease/Cocoa/CodeBuilder'
            ss.dependency 'FishLampPrerelease/Cocoa/Strings'
            ss.dependency 'FishLampPrerelease/Cocoa/Events'		
            ss.dependency 'FishLampPrerelease/Cocoa/Files'		
            ss.dependency 'FishLampPrerelease/Cocoa/Containers'		
            ss.dependency 'FishLampPrerelease/Cocoa/ObjcRuntime'
            ss.dependency 'FishLampPrerelease/Cocoa/BundleUtils'

            ss.source_files = 'FishLampCocoa/Classes/CodeGenerator/**/*.{h,m}'
        end

        cocoa.subspec 'Compatibility' do |ss|
            ss.dependency 'FishLampPrerelease/Core'
            ss.source_files = 'FishLampCocoa/Classes/Compatibility/**/*.{h,m}'
        end
        
        cocoa.subspec 'ColorUtils' do |ss|
            ss.dependency 'FishLampPrerelease/Core'
            ss.dependency 'FishLampPrerelease/Cocoa/Compatibility'

            ss.source_files = 'FishLampCocoa/Classes/ColorUtils/**/*.{h,m}'
        end

        cocoa.subspec 'Animation' do |ss|
            ss.dependency 'FishLampPrerelease/Core'
            ss.dependency 'FishLampPrerelease/Cocoa/Geometry'
            ss.dependency 'FishLampPrerelease/Cocoa/Compatibility'

            ss.source_files = 'FishLampCocoa/Classes/Animation/**/*.{h,m}'
        end

        cocoa.subspec 'CoreTextUtils' do |ss|
            ss.dependency 'FishLampPrerelease/Core'

            ss.source_files = 'FishLampCocoa/Classes/CoreTextUtils/**/*.{h,m}'
        end

        cocoa.subspec 'Drawables' do |ss|
            ss.dependency 'FishLampPrerelease/Core'
            ss.dependency 'FishLampPrerelease/Cocoa/Geometry'
            ss.dependency 'FishLampPrerelease/Cocoa/Compatibility'
            ss.dependency 'FishLampPrerelease/Cocoa/CoreTextUtils'

            ss.source_files = 'FishLampCocoa/Classes/Drawables/**/*.{h,m}'
        end

        cocoa.subspec 'Widgets' do |ss|
            ss.dependency 'FishLampPrerelease/Cocoa/Drawables'
            ss.dependency 'FishLampPrerelease/Cocoa/Compatibility'

            ss.source_files = 'FishLampCocoa/Classes/Widgets/**/*.{h,m}'
        end

        cocoa.subspec 'ActivityLog' do |ss|
            ss.dependency 'FishLampPrerelease/Core'
            ss.dependency 'FishLampPrerelease/Cocoa/ColorUtils'

            ss.source_files = 'FishLampCocoa/Classes/ActivityLog/**/*.{h,m}'
        end

    end

  	fishlamp.subspec 'OSX' do |osx|
        osx.dependency 'FishLampPrerelease/Core'
        osx.dependency 'FishLampPrerelease/Cocoa/Compatibility'
        osx.dependency 'FishLampPrerelease/Cocoa/Geometry'
        osx.dependency 'FishLampPrerelease/Cocoa/ColorUtils'

	    osx.osx.frameworks = 'Cocoa'
		osx.osx.resources = ['FishLampOSX/Resources/Images/*.png', 'FishLampOSX/Resources/xib/*']
        
        osx.subspec 'Core' do |ss|
            ss.source_files = 'FishLampOSX/Classes/FishLampOSX.h'
        end

		osx.subspec 'CommandLineTool' do |ss|
			ss.dependency 'FishLampPrerelease/OSX/Core'
			ss.dependency 'FishLampPrerelease/Cocoa/CommandLineProcessor'
            ss.dependency 'FishLampPrerelease/Cocoa/BundleUtils'

			ss.source_files = 'FishLampOSX/Classes/CommandLineTool/**/*.{h,m}'
		end

		osx.subspec 'ModelObjectDocument' do |ss|
			ss.dependency 'FishLampPrerelease/OSX/Core'		
			ss.source_files = 'FishLampOSX/Classes/ModelObjectDocument/**/*.{h,m}'
		end

		osx.subspec 'Image' do |ss|
			ss.dependency 'FishLampPrerelease/OSX/Core'		
			ss.source_files = 'FishLampOSX/Classes/Image/**/*.{h,m}'
		end

		osx.subspec 'GlobalMenu' do |ss|
			ss.dependency 'FishLampPrerelease/OSX/Core'		
			ss.source_files = 'FishLampOSX/Classes/GlobalMenu/**/*.{h,m}'
		end

		osx.subspec 'Utils' do |ss|
			ss.dependency 'FishLampPrerelease/OSX/Core'		
            ss.dependency 'FishLampPrerelease/Cocoa/Notifications'

			ss.source_files = 'FishLampOSX/Classes/Utils/**/*.{h,m}'
		end
	
        # views

        osx.subspec 'AnimatedImageView' do |ss|
			ss.dependency 'FishLampPrerelease/OSX/Core'		
            ss.dependency 'FishLampPrerelease/Cocoa/Animation'

            ss.source_files = 'FishLampOSX/Classes/Views/FLAnimatedImageView*.{h,m}'
        end
        
        osx.subspec 'ButtonCell' do |ss|
			ss.dependency 'FishLampPrerelease/OSX/Core'		
            ss.source_files = 'FishLampOSX/Classes/Views/FLButtonCell*.{h,m}'
        end

        osx.subspec 'ClickableImageView' do |ss|
			ss.dependency 'FishLampPrerelease/OSX/Core'		
            ss.source_files = 'FishLampOSX/Classes/Views/FLClickableImageView*.{h,m}'
        end

        osx.subspec 'CustomButton' do |ss|
			ss.dependency 'FishLampPrerelease/OSX/Core'		
            ss.source_files = 'FishLampOSX/Classes/Views/FLCustomButton*.{h,m}'
        end

        osx.subspec 'FramedView' do |ss|
			ss.dependency 'FishLampPrerelease/OSX/Core'		
            ss.source_files = 'FishLampOSX/Classes/Views/FLFramedView*.{h,m}'
        end

        osx.subspec 'ImagePlaceholderView' do |ss|
			ss.dependency 'FishLampPrerelease/OSX/Core'		
            ss.source_files = 'FishLampOSX/Classes/Views/FLImagePlaceholderView*.{h,m}'
        end

        osx.subspec 'LinkTextField' do |ss|
			ss.dependency 'FishLampPrerelease/OSX/Core'		
            ss.source_files = 'FishLampOSX/Classes/Views/FLLinkTextField*.{h,m}'
        end

        osx.subspec 'MouseTrackingView' do |ss|
			ss.dependency 'FishLampPrerelease/OSX/Core'		
            ss.source_files = 'FishLampOSX/Classes/Views/FLMouseTrackingView*.{h,m}'
        end

        osx.subspec 'SpinningProgressView' do |ss|
			ss.dependency 'FishLampPrerelease/OSX/Core'		
            ss.source_files = 'FishLampOSX/Classes/Views/FLSpinningProgressView*.{h,m}'
        end

        osx.subspec 'TextFieldCell' do |ss|
            ss.source_files = 'FishLampOSX/Classes/Views/FLTextFieldCell*.{h,m}'
			ss.dependency 'FishLampPrerelease/OSX/Core'		
        end

        osx.subspec 'ViewAdditions' do |ss|
			ss.dependency 'FishLampPrerelease/OSX/Core'		
            ss.source_files = 'FishLampOSX/Classes/Views/NSTextView+*.{h,m}', 'FishLampOSX/Classes/Views/NSView+*.{h,m}'
        end

        # view controllers

        osx.subspec 'ActivityLogViewController' do |ss|
			ss.dependency 'FishLampPrerelease/OSX/Core'		
            ss.dependency 'FishLampPrerelease/Cocoa/ActivityLog'

            ss.source_files = 'FishLampOSX/Classes/ViewControllers/FLActivityLogViewController*.{h,m}'
        end


        osx.subspec 'ErrorWindowController' do |ss|
			ss.dependency 'FishLampPrerelease/OSX/Core'		
            ss.dependency 'FishLampPrerelease/OSX/Utils'

            ss.source_files = 'FishLampOSX/Classes/ErrorWindowController/**/*.{h,m}'
            ss.osx.resources = ['FishLampOSX/Classes/ErrorWindowController/**/*.{png,xib}']
        end

        osx.subspec 'FileDropTableViewController' do |ss|
			ss.dependency 'FishLampPrerelease/OSX/Core'		
            ss.source_files = 'FishLampOSX/Classes/ViewControllers/FLFileDropTableViewController*.{h,m}'
        end

        osx.subspec 'TextViewController' do |ss|
			ss.dependency 'FishLampPrerelease/OSX/Core'		
            ss.dependency 'FishLampPrerelease/OSX/ViewAdditions'

            ss.source_files = 'FishLampOSX/Classes/ViewControllers/FLTextViewController*.{h,m}'
        end

        osx.subspec 'TextViewLogger' do |ss|
			ss.dependency 'FishLampPrerelease/OSX/Core'		
            ss.dependency 'FishLampPrerelease/OSX/ViewAdditions'

            ss.source_files = 'FishLampOSX/Classes/ViewControllers/FLTextViewLogger*.{h,m}'
        end

		osx.subspec 'BreadcrumbBarViewController' do |ss|
			ss.dependency 'FishLampPrerelease/OSX/Core'		
            ss.dependency 'FishLampPrerelease/Cocoa/CoreTextUtils'

			ss.source_files = 'FishLampOSX/Classes/ViewControllers/BreadcrumbBarViewController/**/*.{h,m}'
		end

		osx.subspec 'Wizard' do |ss|
			ss.dependency 'FishLampPrerelease/OSX/Core'		
			ss.dependency 'FishLampPrerelease/Cocoa/Animation'


            # TODO (MWF): decouple this
            ss.dependency 'FishLampPrerelease/Cocoa/Networking/Activity'

            # TODO (MWF): break panels out of here.
            ss.dependency 'FishLampPrerelease/Cocoa/Authentication'
            ss.dependency 'FishLampPrerelease/Cocoa/Keychain'

            ss.dependency 'FishLampPrerelease/OSX/ViewAdditions'
			ss.dependency 'FishLampPrerelease/OSX/FramedView'
			ss.dependency 'FishLampPrerelease/OSX/BreadcrumbBarViewController'

			ss.source_files = 'FishLampOSX/Classes/Wizard/**/*.{h,m}'
            ss.osx.resources = ['FishLampOSX/Classes/Wizard/**/*.{png,xib}']
		end

	end
    
end


