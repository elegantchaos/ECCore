// --------------------------------------------------------------------------
//
//! @file:
//! Unit tests for the NSDate+ECUtilitiesTests.h category.
//
//  Copyright 2013 Sam Deane, Elegant Chaos. All rights reserved.
//  This source code is distributed under the terms of Elegant Chaos's 
//  liberal license: http://www.elegantchaos.com/license/liberal
// --------------------------------------------------------------------------

#import <ECUnitTests/ECUnitTests.h>
#import <ECCore/ECCore.h>

@interface NSExceptionTests : ECTestCase

@end

@implementation NSExceptionTests


- (void) testCallstack
{
	@try 
	{
		@throw [NSException exceptionWithName:@"name" reason:@"reason" userInfo:nil];
	}
	@catch (NSException *exception) 
	{
		NSString* stack = [exception stringFromCallstack];
		ECTestLog(@"%@", stack);
		ECTestAssertStringBeginsWith(stack, @"-[NSExceptionTests testCallstack]");
		ECTestAssertStringContains(stack, @"-[NSInvocation invoke]");
	}
}

- (void) testCompactCallstack
{
	@try 
	{
		@throw [NSException exceptionWithName:@"name" reason:@"reason" userInfo:nil];
	}
	@catch (NSException *exception) 
	{
		NSString* stack = [exception stringFromCompactCallstack];

		// not a lot we can test here, other than it returns something
		ECTestAssertNotEmpty(stack);
		
	}
}


@end
