//
//  ECKVOManager.m
//  ECCore
//
//  Created by Sam Deane on 26/04/2012.
//  Copyright (c) 2012 Elegant Chaos. All rights reserved.
//

#import "ECKVOManager.h"

@implementation ECKVOManager

ECSYNTHESIZE_SINGLETON(ECKVOManager);

@synthesize observers = _observers;

- (id)init
{
	if ((self = [super init]) != nil)
	{
		self.observers = [NSMutableArray array];
	}
}

- (void)dealloc
{
	[_observers release];
	
	[super dealloc];
}

- (void)addObserver:(ECObserver*)observer
{
	@synchronized(self.observer)
	{
		[self.observer addObject:observer];
	}
}

- (void)removeObserver:(ECObserver*)observer
{
	@synchronized(self.observer)
	{
		[self.observer removeObject:observer];
	}
}

@end