// --------------------------------------------------------------------------
//
//  Copyright 2013 Sam Deane, Elegant Chaos. All rights reserved.
//  This source code is distributed under the terms of Elegant Chaos's 
//  liberal license: http://www.elegantchaos.com/license/liberal
// --------------------------------------------------------------------------

#import <ECUnitTests/ECUnitTests.h>

#import "ECLaunchServices.h"

@interface ECLaunchServicesTests : ECTestCase

@end

@implementation ECLaunchServicesTests

- (void)testOpenAtLogin
{
	NSURL* url = [self exampleBundleURL];
	ECTestAssertFalse([ECLaunchServices willOpenAtLogin:url]);

	[ECLaunchServices setOpenAtLogin:url enabled:YES];
	ECTestAssertTrue([ECLaunchServices willOpenAtLogin:url]);

	[ECLaunchServices setOpenAtLogin:url enabled:NO];
	ECTestAssertFalse([ECLaunchServices willOpenAtLogin:url]);
}

@end
