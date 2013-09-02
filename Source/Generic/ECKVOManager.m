// --------------------------------------------------------------------------
//  Copyright 2013 Sam Deane, Elegant Chaos. All rights reserved.
//  This source code is distributed under the terms of Elegant Chaos's
//  liberal license: http://www.elegantchaos.com/license/liberal
// --------------------------------------------------------------------------

#import "ECKVOManager.h"
#import "ECKVO.h"

#import <CoreFoundation/CoreFoundation.h>

@interface ECKVOManager()

@property (strong, nonatomic) NSMutableArray* observers;

@end

@implementation ECKVOManager

ECDefineDebugChannel(ECKVOChannel);

EC_SYNTHESIZE_SINGLETON(ECKVOManager);

- (id)init
{
	if ((self = [super init]) != nil)
	{
		self.observers = (__bridge_transfer NSMutableArray*) CFArrayCreateMutable(nil, 0, nil);
	}
	
	return self;
}

- (void)addObserver:(ECObserver*)observer
{
	@synchronized(self)
	{
		[self.observers addObject:observer];
		ECDebug(ECKVOChannel, @"added observer %@", observer);
	}
}

- (void)removeObserver:(ECObserver*)observer
{
	@synchronized(self)
	{
		[self.observers removeObject:observer];

		ECDebug(ECKVOChannel, @"removed observer %@", observer);
	}
}

- (NSString*)description
{
	NSMutableString* description = [NSMutableString stringWithString:@"Registered observers:\n"];
	for (id item in self.observers)
	{
		[description appendFormat:@"\t%@\n", item];
	}
	
	return description;
}

- (void)dumpObservers
{
	ECDebug(ECKVOChannel, @"%@", [self description]);
}

- (NSUInteger)observerCount
{
	return [self.observers count];
}

- (ECObserver*)observerAtIndex:(NSUInteger)index
{
	return [self.observers objectAtIndex:index];
}

@end
