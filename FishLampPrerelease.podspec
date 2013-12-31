#
# Be sure to run `pod spec lint NAME.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# To learn more about the attributes see http://docs.cocoapods.org/specification.html
#
Pod::Spec.new do |s|
   
    s.name         = "FishLampPrerelease"
    s.version      = "0.1.0"
    s.summary      = "This is the core functionality of the FishLamp Framework."
    s.homepage     = "http://s.com"
    s.license      = 'MIT'
    s.author       = { "Mike Fullerton" => "hello@fishlamp.com" }
    s.source       = { :git => "https://github.com/fishlamp/FishLampPrerelease.git", :tag => s.version.to_s }

    s.ios.deployment_target = '6.1'
    s.osx.deployment_target = '10.6'
    s.requires_arc = false
    
    s.ios.frameworks = 'Security', 'MobileCoreServices', 'SystemConfiguration'
    s.osx.frameworks = 'CoreServices', 'Security', 'SystemConfiguration', 'ApplicationServices', 'Quartz', 'QuartzCore', 'CoreFoundation',  'Foundation'

	s.dependency 'FishLampCore'

	s.subspec 'Utils' do |ss|
		ss.source_files = 'Classes/Utils/**/*.{h,m}'
	end

	s.subspec 'Proxies' do |ss|
		ss.source_files = 'Classes/Proxies/**/*.{h,m}'
	end

	s.subspec 'BundleUtils' do |ss|
		ss.source_files = 'Classes/BundleUtils/**/*.{h,m}'
	end

	s.subspec 'Containers' do |ss|
		ss.source_files = 'Classes/Containers/**/*.{h,m}'
	end

	s.subspec 'ByteBuffer' do |ss|
		ss.source_files = 'Classes/ByteBuffer/**/*.{h,m}'
	end

	s.subspec 'Events' do |ss|
		ss.dependency 'FishLampPrerelease/Proxies'
		ss.source_files = 'Classes/Events/**/*.{h,m}'
	end

	s.subspec 'Files' do |ss|
		ss.source_files = 'Classes/Files/**/*.{h,m}'
	end

	s.subspec 'Geometry' do |ss|
		ss.source_files = 'Classes/Geometry/**/*.{h,m}'
	end

	s.subspec 'Keychain' do |ss|
		ss.source_files = 'Classes/Keychain/**/*.{h,m}'
	end

	s.subspec 'Notifications' do |ss|
		ss.source_files = 'Classes/Notifications/**/*.{h,m}'
	end

	s.subspec 'Authentication' do |ss|
		ss.dependency 'FishLampPrerelease/Keychain'
		ss.source_files = 'Classes/Authentication/**/*.{h,m}'
	end

	s.subspec 'UserPreferences' do |ss|
		ss.source_files = 'Classes/UserPreferences/**/*.{h,m}'
	end
        
	s.subspec 'Services' do |ss|
		ss.source_files = 'Classes/Services/**/*.{h,m}'
	end

	s.subspec 'MoreStrings' do |ss|
		ss.source_files = 'Classes/Strings/**/*.{h,m}'
	end

	s.subspec 'ObjcRuntime' do |ss|
		ss.source_files = 'Classes/ObjcRuntime/**/*.{h,m}'
	end

	s.subspec 'CodeBuilder' do |ss|
		ss.dependency 'FishLampStrings'
		ss.dependency 'FishLampPrerelease/MoreStrings'
		ss.source_files = 'Classes/CodeBuilder/**/*.{h,m}'
	end

	s.subspec 'Encoding' do |encoding|
		encoding.dependency 'FishLampPrerelease/CodeBuilder'

		encoding.subspec 'Xml' do |ss|
			ss.source_files = 'Classes/Encoding/Xml/**/*.{h,m}'
		end

		encoding.subspec 'Json' do |ss|
			ss.source_files = 'Classes/Encoding/Json/**/*.{h,m}'
		end

		encoding.subspec 'Url' do |ss|
			ss.source_files = 'Classes/Encoding/URL/**/*.{h,m}'
		end

		encoding.subspec 'Soap' do |ss|
			ss.source_files = 'Classes/Encoding/Soap/**/*.{h,m}'
		end

		encoding.subspec 'Html' do |ss|
			ss.source_files = 'Classes/Encoding/Html/**/*.{h,m}'
		end

		encoding.subspec 'Base64' do |ss|
			ss.source_files = 'Classes/Encoding/Base64/**/*.{h,m,c}'
		end
	end

	s.subspec 'ModelObject' do |ss|
		ss.dependency 'FishLampPrerelease/ObjcRuntime'
		ss.source_files = 'Classes/ModelObject/**/*.{h,m}'
	end

	s.subspec 'CommandLineProcessor' do |ss|
		ss.source_files = 'Classes/CommandLineProcessor/**/*.{h,m}'
	end

	s.subspec 'Testables' do |ss|
		ss.source_files = 'Classes/Testables/**/*.{h,m}'
	end

	s.subspec 'RetryHandler' do |ss|
		ss.source_files = 'Classes/RetryHandler/**/*.{h,m}'
	end

	s.subspec 'Timer' do |ss|
		ss.source_files = 'Classes/Timer/**/*.{h,m}'
	end

	s.subspec 'Async' do |ss|
		ss.dependency 'FishLampPrerelease/Timer'
		ss.dependency 'FishLampPrerelease/Events'
		ss.source_files = 'Classes/Async/**/*.{h,m}'
	end

	s.subspec 'Storage' do |ss|
		ss.dependency 'FishLampPrerelease/Files'
		ss.source_files = 'Classes/Storage/**/*.{h,m}'
	end

	s.subspec 'Database' do |ss|
		ss.dependency 'FishLampPrerelease/ModelObject'
		ss.dependency 'FishLampPrerelease/ObjcRuntime'
		ss.source_files = 'Classes/Database/**/*.{h,m}'
		ss.library = 'sqlite3'
	end

	s.subspec 'ObjectDatabase' do |ss|
		ss.dependency 'FishLampPrerelease/Database'
		ss.dependency 'FishLampPrerelease/Storage'
		ss.dependency 'FishLampPrerelease/ModelObject'
		ss.dependency 'FishLampPrerelease/Services'
		ss.dependency 'FishLampPrerelease/Async'

		ss.source_files = 'Classes/ObjectDatabase/**/*.{h,m}'
	end

	s.subspec 'Networking' do |network|

		network.subspec 'Activity' do |ss|
			ss.dependency 'FishLampPrerelease/Events'
			ss.source_files = 'Classes/Networking/Activity/**/*.{h,m}'
		end
		
		network.subspec 'Errors' do |ss|
			ss.source_files = 'Classes/Networking/Errors/**/*.{h,m}'
		end

		network.subspec 'Reachability' do |ss|
			ss.ios.frameworks = 'SystemConfiguration'
			ss.osx.frameworks = 'SystemConfiguration'

			ss.source_files = 'Classes/Networking/Reachability/**/*.{h,m}'
		end

		network.subspec 'Sinks' do |ss|
			ss.source_files = 'Classes/Networking/Sinks/**/*.{h,m}'
		end

		network.subspec 'Streams' do |ss|
			ss.dependency 'FishLampPrerelease/Events'
			ss.dependency 'FishLampPrerelease/Timer'
			ss.dependency 'FishLampPrerelease/Async'
			ss.dependency 'FishLampPrerelease/Networking/Sinks'

			ss.ios.frameworks = 'CFNetwork'
			ss.osx.frameworks = 'CFNetwork'

			ss.source_files = 'Classes/Networking/Streams/**/*.{h,m}'
		end

		network.subspec 'ProtocolSupport' do |ss|
			ss.dependency 'FishLampStrings'
			ss.dependency 'FishLampPrerelease/Async'
			ss.dependency 'FishLampPrerelease/RetryHandler'
			ss.dependency 'FishLampPrerelease/BundleUtils'
			ss.dependency 'FishLampPrerelease/CodeBuilder'
			ss.dependency 'FishLampPrerelease/Encoding'
			ss.dependency 'FishLampPrerelease/ModelObject'
			ss.dependency 'FishLampPrerelease/Authentication'
			ss.dependency 'FishLampPrerelease/Services'
			ss.dependency 'FishLampPrerelease/Events'
			ss.dependency 'FishLampPrerelease/Timer'

			ss.dependency 'FishLampPrerelease/Networking/Activity'
			ss.dependency 'FishLampPrerelease/Networking/Streams'
			ss.dependency 'FishLampPrerelease/Networking/Sinks'
			ss.dependency 'FishLampPrerelease/Networking/Reachability'
			ss.dependency 'FishLampPrerelease/Networking/Errors'
		end

		network.subspec 'DNS' do |ss|
			ss.dependency 'FishLampPrerelease/Networking/ProtocolSupport'
			ss.source_files = 'Classes/Networking/Protocols/DNS/**/*.{h,m}'
		end

		network.subspec 'HTTP' do |ss|
			ss.dependency 'FishLampPrerelease/Networking/ProtocolSupport'
			ss.source_files = 'Classes/Networking/Protocols/HTTP/**/*.{h,m}'
		end

		network.subspec 'Json' do |ss|
			ss.dependency 'FishLampPrerelease/Networking/HTTP'
			ss.source_files = 'Classes/Networking/Protocols/Json/**/*.{h,m}'
		end

		network.subspec 'Soap' do |ss|
			ss.dependency 'FishLampPrerelease/Networking/HTTP'
			ss.source_files = 'Classes/Networking/Protocols/Soap/**/*.{h,m}'
		end

		network.subspec 'Oauth' do |ss|
			ss.dependency 'FishLampPrerelease/Networking/HTTP'
			ss.source_files = 'Classes/Networking/Protocols/Oauth/**/*.{h,m}'
		end

		network.subspec 'Tcp' do |ss|
			ss.dependency 'FishLampPrerelease/Networking/ProtocolSupport'
			ss.source_files = 'Classes/Networking/Protocols/Tcp/**/*.{h,m}'
		end

		network.subspec 'XmlRpc' do |ss|
			ss.dependency 'FishLampPrerelease/Networking/ProtocolSupport'
			ss.source_files = 'Classes/Networking/Protocols/XmlRpc/**/*.{h,m}'
		end

	end

	s.subspec 'Compatibility' do |ss|
		ss.source_files = 'Classes/Compatibility/**/*.{h,m}'
	end
	
	s.subspec 'ColorUtils' do |ss|
		ss.dependency 'FishLampPrerelease/Compatibility'
		ss.source_files = 'Classes/ColorUtils/**/*.{h,m}'
	end

	s.subspec 'Animation' do |ss|
		ss.dependency 'FishLampPrerelease/Geometry'
		ss.dependency 'FishLampPrerelease/Compatibility'
		ss.source_files = 'Classes/Animation/**/*.{h,m}'
	end

	s.subspec 'CoreTextUtils' do |ss|
		ss.source_files = 'Classes/CoreTextUtils/**/*.{h,m}'
	end

	s.subspec 'Drawables' do |ss|
		ss.dependency 'FishLampPrerelease/Geometry'
		ss.dependency 'FishLampPrerelease/Compatibility'
		ss.dependency 'FishLampPrerelease/CoreTextUtils'
		ss.source_files = 'Classes/Drawables/**/*.{h,m}'
	end

	s.subspec 'Widgets' do |ss|
		ss.dependency 'FishLampPrerelease/Drawables'
		ss.dependency 'FishLampPrerelease/Compatibility'
		ss.source_files = 'Classes/Widgets/**/*.{h,m}'
	end

	s.subspec 'ActivityLog' do |ss|
		ss.dependency 'FishLampPrerelease/ColorUtils'
		ss.source_files = 'Classes/ActivityLog/**/*.{h,m}'
	end

	s.subspec 'CodeGenerator' do |ss|
		ss.dependency 'FishLampStrings'
		ss.dependency 'FishLampPrerelease/ModelObject'
		ss.dependency 'FishLampPrerelease/CodeBuilder'
		ss.dependency 'FishLampPrerelease/Events'		
		ss.dependency 'FishLampPrerelease/Files'		
		ss.dependency 'FishLampPrerelease/Containers'		
		ss.dependency 'FishLampPrerelease/ObjcRuntime'
		ss.dependency 'FishLampPrerelease/BundleUtils'

		ss.source_files = 'Classes/CodeGenerator/**/*.{h,m}'
	end

end


