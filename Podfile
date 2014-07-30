target 'ManagementSDK', :exclusive => true do
  pod "ContentfulDeliveryAPI", :git => 'https://github.com/contentful/contentful.objc.git'
  pod "ContentfulManagementAPI", :path => "."
end

target 'Tests', :exclusive => true do
  pod "ContentfulManagementAPI", :path => "."

  pod 'Specta', '~> 0.2.1'
  pod 'Expecta'
  pod 'CCLRequestReplay', :git => 'https://github.com/neonichu/CCLRequestReplay.git'
end
