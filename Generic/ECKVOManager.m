//
//  ECKVOManager.m
//  ECCore
//
//  Created by Sam Deane on 26/04/2012.
//  Copyright (c) 2012 Elegant Chaos. All rights reserved.
//

#import "ECKVOManager.h"
#import "ECKVO.h"
#import "ECLogging.h"

@implementation ECKVOManager

ECDefineDebugChannel(ECKVOChannel);

EC_SYNTHESIZE_SINGLETON(ECKVOManager);

@synthesize observers = _observers;

- (id)init
{
	if ((self = [super init]) != nil)
	{
		self.observers = [NSMutableArray array];
	}
	
	return self;
}

- (void)dealloc
{
	[_observers release];
	
	[super dealloc];
}

- (void)addObserver:(ECObserver*)observer
{
	@synchronized(self.observers)
	{
		[self.observers addObject:observer];
		ECDebug(ECKVOChannel, @"added observer %@", observer);
	}
}

- (void)removeObserver:(ECObserver*)observer
{
	@synchronized(self.observers)
	{
		[self.observers removeObject:observer];
		ECDebug(ECKVOChannel, @"removed observer %@", observer);
	}
}

- (NSString*)description
{
	NSMutableString* description = [NSMutableString stringWithString:@"Registered observers:\n"];
	for (ECObserver* observer in self.observers)
	{
		[description appendFormat:@"\t%@\n", observer];
	}
	
	return description;
}

- (void)dumpObservers
{
	ECDebug(ECKVOChannel, @"%@", [self description]);
}

@end