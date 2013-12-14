#
# Be sure to run `pod spec lint NAME.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# To learn more about the attributes see http://docs.cocoapods.org/specification.html
#
Pod::Spec.new do |s|
    s.name         = "FishLampUI"
    s.version      = "3.0.0"
    s.summary      = "This is the core functionality of the FishLamp Framework."
    s.homepage     = "http://fishlamp.com"
    s.license      = 'MIT'
    s.author       = { "Mike Fullerton" => "hello@fishlamp.com" }
    s.source       = { :git => "https://github.com/fishlamp/fishlamp-cocoa.git", :tag => s.version.to_s }

    s.osx.deployment_target = '10.6'
    s.requires_arc = false
    
	s.subspec 'Animate' do |ss|
		ss.source_files = 'Classes/Animate/**/*.{h,m}'
	end

	s.subspec 'Draw' do |ss|
		ss.source_files = 'Classes/Draw/**/*.{h,m}'
	end

	s.subspec 'View' do |ss|
		ss.source_files = 'Classes/View/**/*.{h,m}'
	end


end
