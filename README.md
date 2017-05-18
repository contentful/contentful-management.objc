# contentful-management.objc

## Important note

While the ContentfulManagementAPI SDK is still being maintained, the source code and documentation has been moved to a new Github repository. Please visit [contentful.objc](https://github.com/contentful/contentful.objc) to keep up to date with changes to the project.

In order to continue using the ContentfulManagementAPI pod, please ensure your Podfile only has the following line.

```ruby
pod 'ContentfulManagementAPI'
```

ContentfulManagementAPI's depedency on pod 'ContentfulDeliveryAPI' has been removed as the code is now inlined in the Management project. Adding a redundant line `pod 'ContentfulDeliveryAPI'` is likely to result in duplicate symbol errors during linking.

Copyright (c) 2014-2017 Contentful GmbH. See LICENSE for further details.

