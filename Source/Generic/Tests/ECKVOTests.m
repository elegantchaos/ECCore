// --------------------------------------------------------------------------
//
//  Copyright 2014 Sam Deane, Elegant Chaos. All rights reserved.
//  This source code is distributed under the terms of Elegant Chaos's 
//  liberal license: http://www.elegantchaos.com/license/liberal
// --------------------------------------------------------------------------

#import <ECUnitTests/ECUnitTests.h>
#import <ECCore/ECCore.h>


@interface KVOTestClass : NSObject

@property (strong, nonatomic) NSString* name;

@end

@implementation KVOTestClass

@end

@interface ECKVOTests : ECTestCase

@end

@implementation ECKVOTests

- (void)testKVO
{
	KVOTestClass* test = [[KVOTestClass alloc] init];
	test.name = @"fred";
	__block BOOL blockRan = NO;
	
	ECObserver* observer = [test addObserverForKeyPath:@"name" options:0 action:^(NSDictionary *change) {
		blockRan = YES;
	}];
	
	test.name = @"jim";
	
	ECTestAssertTrue(blockRan);
	
	[test removeObserver:observer];
}

- (void)testAutoRemove
{
	@autoreleasepool 
	{
		KVOTestClass* test = [[KVOTestClass alloc] init];
		test.name = @"fred";
		__block BOOL blockRan = NO;
		
		[test addObserverForKeyPath:@"name" options:0 action:^(NSDictionary *change) {
			blockRan = YES;
		}];
		
		test.name = @"jim";
		
		ECTestAssertTrue(blockRan);
	}
	
	NSUInteger registeredObservers = [[ECKVOManager sharedInstance] observerCount];
	ECTestAssertIntegerIsEqual(registeredObservers, 0);
}

@end
