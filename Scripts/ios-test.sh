echo Testing IOS

base=`dirname $0`
common="$base/../../ECUnitTests/Scripts/"
source "$common/test-common.sh"

xcodebuild -workspace "ECCore.xcworkspace" -scheme "ECCoreIOS" -configuration "$testConfig" -sdk "$testSDKiOS" test | "$common/$testConvertOutput"


