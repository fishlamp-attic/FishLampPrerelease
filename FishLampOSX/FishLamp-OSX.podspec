#
# Be sure to run `pod spec lint NAME.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# To learn more about the attributes see http://docs.cocoapods.org/specification.html
#
Pod::Spec.new do |s|
    s.name         = "FishLamp-OSX"
    s.version      = "3.0.0"
    s.summary      = "This is the core functionality of the FishLamp Framework."
    s.homepage     = "http://fishlamp.com"
    s.license      = 'MIT'
    s.author       = { "Mike Fullerton" => "hello@fishlamp.com" }
    s.source       = { :git => "https://github.com/fishlamp/fishlamp-cocoa.git", :tag => s.version.to_s }

    s.osx.deployment_target = '10.6'
    s.requires_arc = false
    s.osx.frameworks = 'Cocoa'
	s.osx.resources = ['Resources/Images/*.png', 'Resources/xib/*']
    
    s.source_files = 'Classes/FishLamp-OSX.h'
    
	s.subspec 'BreadcrumbBarView' do |ss|
		ss.source_files = 'Classes/BreadcrumbBarView/**/*.{h,m}'
	end

	s.subspec 'CommandLineTool' do |ss|
		ss.source_files = 'Classes/CommandLineTool/**/*.{h,m}'
	end

	s.subspec 'Documents' do |ss|
		ss.source_files = 'Classes/Documents/**/*.{h,m}'
	end

	s.subspec 'Image' do |ss|
		ss.source_files = 'Classes/Image/**/*.{h,m}'
	end

	s.subspec 'Menus' do |ss|
		ss.source_files = 'Classes/Menus/**/*.{h,m}'
	end

	s.subspec 'Utils' do |ss|
		ss.source_files = 'Classes/Utils/**/*.{h,m}'
	end

	s.subspec 'ViewControllers' do |ss|
		ss.source_files = 'Classes/ViewControllers/**/*.{h,m}'
	end

	s.subspec 'Views' do |ss|
		ss.source_files = 'Classes/Views/**/*.{h,m}'
	end

	s.subspec 'Wizard' do |ss|
		ss.source_files = 'Classes/Wizard/**/*.{h,m}'
	end

end
