
xcodeproj 'XcodeProject/FishLampCocoa.xcodeproj'

pod 'ObjectiveSugar', '~> 0.9'

target :"FishLampCocoa-iOS" do
    platform :ios, '6.1'
end

target :"FishLampCocoa-OSX-Universal" do
    platform :osx, '10.7'
end

target :"FishLampCocoa-OSX" do
    platform :osx, '10.8'
end

post_install do |installer|
  installer.project.targets.each do |target|
    puts "#{target.name}"
  end
end