Pod::Spec.new do |s|
  s.name             = "ContentfulManagementAPI"
  s.version          = "0.1.0"
  s.summary          = "Objective-C SDK for Contentful's Content Management API."
  s.homepage         = "https://github.com/contentful/contentful-management.objc"
  s.author           = { "Boris Bügling" => "boris@buegling.com" }
  s.source           = { :git => "https://github.com/contentful/contentful-management.objc.git",
                         :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/contentfulapp'

  s.license = {
    :type => 'MIT',
    :file => 'LICENSE'
  }

  s.ios.deployment_target     = '6.0'
  s.osx.deployment_target     = '10.8'
  s.requires_arc = true

  s.source_files = 'Pod/Code'

  s.dependency 'ContentfulDeliveryAPI'
end
