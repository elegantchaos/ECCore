// --------------------------------------------------------------------------
//
//  Copyright 2013 Sam Deane, Elegant Chaos. All rights reserved.
//  This source code is distributed under the terms of Elegant Chaos's 
//  liberal license: http://www.elegantchaos.com/license/liberal
// --------------------------------------------------------------------------

#import <ECUnitTests/ECUnitTests.h>
#import <ECCore/ECCore.h>


@interface NSBundleTests : ECTestCase

@end

@implementation NSBundleTests

- (void)testBundleInfo
{
	NSBundle* bundle = [self exampleBundle];
	
	ECTestAssertStringIsEqual([bundle bundleName],@"Test Name");
	ECTestAssertStringIsEqual([bundle bundleVersion],@"1.0");
	ECTestAssertStringIsEqual([bundle bundleBuild],@"1");
	ECTestAssertStringIsEqual([bundle bundleFullVersion],@"Version 1.0 (1)");
	ECTestAssertStringIsEqual([bundle bundleCopyright],@"Test Copyright");
}

@end
