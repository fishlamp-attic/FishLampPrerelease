
xcodeproj 'XcodeProject/FishLamp.xcodeproj'

#    fishlamp.ios.frameworks = 'Security', 'MobileCoreServices', 'SystemConfiguration'
#    fishlamp.osx.frameworks = 'CoreServices', 'Security', 'SystemConfiguration', 'ApplicationServices', 'Quartz', 'QuartzCore', 'CoreFoundation',  'Foundation'

pod 'ObjectiveSugar', '~> 1.0.0'

target :"FishLamp-iOS" do
    platform :ios, '6.1'
end

target :"FishLampOSX-Universal" do
    platform :osx, '10.6'
end

target :"FishLampOSX" do
    platform :osx, '10.7'
end

# post_install do |installer|
#  installer.project.targets.each do |target|
#    puts "#{target.name}"
#  end
# end