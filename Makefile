.PHONY: test

test:
	set -o pipefail && xcodebuild -workspace ManagementSDK.xcworkspace \
		-scheme 'ManagementSDK' -sdk iphonesimulator10.0 \
		-destination name\=iPhone\ 5 test #| xcpretty -c
