#
# Be sure to run `pod spec lint NAME.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# To learn more about the attributes see http://docs.cocoapods.org/specification.html
#
Pod::Spec.new do |s|
    s.name         = "FishLampCocoa"
    s.version      = "0.0.3"
    s.summary      = "This is the core functionality of the FishLamp Framework."
    s.homepage     = "http://fishlamp.com"
    s.license      = 'MIT'
    s.author       = { "Mike Fullerton" => "hello@fishlamp.com" }
    s.source       = { :git => "https://github.com/fishlamp/fishlamp-cocoa.git", :tag => s.version.to_s }

    s.ios.deployment_target = '6.1'
    s.osx.deployment_target = '10.6'
    s.requires_arc = false
    
    s.ios.frameworks = 'Security', 'MobileCoreServices', 'SystemConfiguration'
    s.osx.frameworks = 'CoreServices', 'Security', 'SystemConfiguration', 'ApplicationServices', 'Quartz', 'QuartzCore', 'CoreFoundation',  'Foundation'
    
	s.subspec 'Core' do |ss|
		ss.source_files = 'Classes/Core/Core/**/*.{h,m}'
	end

	s.subspec 'ActivityLog' do |ss|
		ss.source_files = 'Classes/ActivityLog/ActivityLog/**/*.{h,m}'
	end

	s.subspec 'Async' do |ss|
		ss.source_files = 'Classes/Async/Async/**/*.{h,m}'
	end

	s.subspec 'Authentication' do |ss|
		ss.source_files = 'Classes/Authentication/Authentication/**/*.{h,m}'
	end

	s.subspec 'BundleUtils' do |ss|
		ss.source_files = 'Classes/BundleUtils/BundleUtils/**/*.{h,m}'
	end

	s.subspec 'CodeBuilder' do |ss|
		ss.source_files = 'Classes/CodeBuilder/CodeBuilder/**/*.{h,m}'
	end

	s.subspec 'ColorUtils' do |ss|
		ss.source_files = 'Classes/ColorUtils/ColorUtils/**/*.{h,m}'
	end

	s.subspec 'Compatibility' do |ss|
		ss.source_files = 'Classes/Compatibility/Compatibility/**/*.{h,m}'
	end

	s.subspec 'Containers' do |ss|
		ss.source_files = 'Classes/Containers/Containers/**/*.{h,m}'
	end

	s.subspec 'Encoding' do |ss|
		ss.source_files = 'Classes/Encoding/Encoding/**/*.{h,m,c}'
	end

	s.subspec 'Files' do |ss|
		ss.source_files = 'Classes/Files/Files/**/*.{h,m}'
	end

	s.subspec 'Geometry' do |ss|
		ss.source_files = 'Classes/Geometry/Geometry/**/*.{h,m}'
	end

	s.subspec 'Keychain' do |ss|
		ss.source_files = 'Classes/Keychain/Keychain/**/*.{h,m}'
	end

	s.subspec 'ModelObject' do |ss|
		ss.source_files = 'Classes/ModelObject/ModelObject/**/*.{h,m}'
	end

	s.subspec 'Networking' do |ss|
		ss.source_files = 'Classes/Networking/Networking/**/*.{h,m}'
	    ss.ios.frameworks = 'CFNetwork'
	    ss.osx.frameworks = 'CFNetwork'
	end

	s.subspec 'Notifications' do |ss|
		ss.source_files = 'Classes/Notifications/Notifications/**/*.{h,m}'
	end

	s.subspec 'Services' do |ss|
		ss.source_files = 'Classes/Services/Services/**/*.{h,m}'
	end

	s.subspec 'Storage' do |ss|
		ss.source_files = 'Classes/Storage/Storage/**/*.{h,m}'
	    ss.library = 'sqlite3'
	end

	s.subspec 'Strings' do |ss|
		ss.source_files = 'Classes/Strings/Strings/**/*.{h,m}'
	end

	s.subspec 'Testables' do |ss|
		ss.source_files = 'Classes/Testables/Testables/**/*.{h,m}'
	end

	s.subspec 'Timer' do |ss|
		ss.source_files = 'Classes/Timer/Timer/**/*.{h,m}'
	end

	s.subspec 'Utils' do |ss|
		ss.source_files = 'Classes/Utils/Utils/**/*.{h,m}'
	end

	s.subspec 'CommandLineProcessor' do |ss|
		ss.source_files = 'Classes/CommandLineProcessor/CommandLineProcessor/**/*.{h,m}'
	end


end

