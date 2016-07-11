.PHONY: test pod

test:
	set -o pipefail && xcodebuild -workspace ManagementSDK.xcworkspace \
		-scheme 'ManagementSDK' -sdk iphonesimulator10.0 \
		-destination name\=iPhone\ 5 test #| xcpretty -c

pod:
	bundle exec pod install --no-repo-update
