target 'ManagementSDK', :exclusive => true do
  pod "ContentfulDeliveryAPI", :head
  pod "ContentfulManagementAPI", :path => "."
end

target 'Tests', :exclusive => true do
  pod "ContentfulManagementAPI", :path => "."

  pod 'Specta', '~> 0.2.1'
  pod 'Expecta'
end