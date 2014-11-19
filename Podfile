source 'https://github.com/CocoaPods/Specs.git'

target 'ManagementSDK', :exclusive => true do
  pod "ContentfulDeliveryAPI", :head
  pod "ContentfulManagementAPI", :path => "."
end

target 'Tests', :exclusive => true do
  pod 'Specta', :git => 'https://github.com/specta/specta.git'
  pod 'Expecta'
  pod 'CCLRequestReplay', :git => 'https://github.com/neonichu/CCLRequestReplay.git'
end

post_install do |installer|
  installer.project.targets.each do |target|
    target.build_configurations.each do |config|
    	if not config.build_settings['FRAMEWORK_SEARCH_PATHS']
    		config.build_settings['FRAMEWORK_SEARCH_PATHS'] = ['$(inherited)']
      end

      config.build_settings['FRAMEWORK_SEARCH_PATHS'] << '"$(PLATFORM_DIR)/Developer/Library/Frameworks"'
    end
  end
end
