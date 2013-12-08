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
    
    s.ios.frameworks = 'CFNetwork', 'Security', 'MobileCoreServices', 'SystemConfiguration'
    s.osx.frameworks = 'CoreServices', 'Security', 'SystemConfiguration', 'ApplicationServices', 'Cocoa', 'Quartz', 'QuartzCore', 'CoreFoundation',  'Foundation'

#   	s.default_subspec = 'Pod/Cocoa'


# 	s.library 
  
#   	s.subspec 'Cocoa' do |ss|
# 		ss.source_files = 'Pieces/Release/**/*.{h,m}'
# 	end 
  
	s.subspec 'Core' do |ss|
		ss.source_files = 'Pieces/Release/Core/Core/**/*.{h,m}'
	end

	s.subspec 'ActivityLog' do |ss|
		ss.source_files = 'Pieces/Release/ActivityLog/ActivityLog/**/*.{h,m}'
	end

	s.subspec 'Async' do |ss|
		ss.source_files = 'Pieces/Release/Async/Async/**/*.{h,m}'
	end

	s.subspec 'Authentication' do |ss|
		ss.source_files = 'Pieces/Release/Authentication/Authentication/**/*.{h,m}'
	end

	s.subspec 'BundleUtils' do |ss|
		ss.source_files = 'Pieces/Release/BundleUtils/BundleUtils/**/*.{h,m}'
	end

	s.subspec 'CodeBuilder' do |ss|
		ss.source_files = 'Pieces/Release/CodeBuilder/CodeBuilder/**/*.{h,m}'
	end

	s.subspec 'ColorUtils' do |ss|
		ss.source_files = 'Pieces/Release/ColorUtils/ColorUtils/**/*.{h,m}'
	end

	s.subspec 'Compatibility' do |ss|
		ss.source_files = 'Pieces/Release/Compatibility/Compatibility/**/*.{h,m}'
	end

	s.subspec 'Containers' do |ss|
		ss.source_files = 'Pieces/Release/Containers/Containers/**/*.{h,m}'
	end

	s.subspec 'Encoding' do |ss|
		ss.source_files = 'Pieces/Release/Encoding/Encoding/**/*.{h,m,c}'
	end

	s.subspec 'Files' do |ss|
		ss.source_files = 'Pieces/Release/Files/Files/**/*.{h,m}'
	end

	s.subspec 'Geometry' do |ss|
		ss.source_files = 'Pieces/Release/Geometry/Geometry/**/*.{h,m}'
	end

	s.subspec 'Keychain' do |ss|
		ss.source_files = 'Pieces/Release/Keychain/Keychain/**/*.{h,m}'
	end

	s.subspec 'ModelObject' do |ss|
		ss.source_files = 'Pieces/Release/ModelObject/ModelObject/**/*.{h,m}'
	end

	s.subspec 'Networking' do |ss|
		ss.source_files = 'Pieces/Release/Networking/Networking/**/*.{h,m}'
	end

	s.subspec 'Notifications' do |ss|
		ss.source_files = 'Pieces/Release/Networking/Notifications/**/*.{h,m}'
	end

	s.subspec 'Services' do |ss|
		ss.source_files = 'Pieces/Release/Services/Services/**/*.{h,m}'
	end

	s.subspec 'Storage' do |ss|
		ss.source_files = 'Pieces/Release/Storage/Storage/**/*.{h,m}'
        ss.library = 'sqlite3.0'
	end

	s.subspec 'Strings' do |ss|
		ss.source_files = 'Pieces/Release/Strings/Strings/**/*.{h,m}'
	end

	s.subspec 'Testables' do |ss|
		ss.source_files = 'Pieces/Release/Testables/Testables/**/*.{h,m}'
	end

	s.subspec 'Timer' do |ss|
		ss.source_files = 'Pieces/Release/Timer/Timer/**/*.{h,m}'
	end

	s.subspec 'Utils' do |ss|
		ss.source_files = 'Pieces/Release/Utils/Utils/**/*.{h,m}'
	end

end
