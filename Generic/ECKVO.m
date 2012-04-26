//
//  ECKVO.m
//  ECCore
//
//  Created by Sam Deane on 26/04/2012.
//  Copyright (c) 2012 Elegant Chaos. All rights reserved.
//

#import "ECKVO.h"
#import "ECAssertion.h"
#import "ECSingleton.h"
#import "ECKVOManager.h"

#import <objc/runtime.h>


void* ECObservationContext = &ECObservationContext;
void* ECObserversAssociatedObjectsKey = &ECObserversAssociatedObjectsKey;

@interface ECObserver : NSObject 

@property (copy) ECObserverAction action;
@property (copy) NSString* path;
@property (retain) NSOperationQueue* queue;
@property (assign) id observed;

@end

@implementation ECObserver

@synthesize action = _action;
@synthesize path = _path;
@synthesize queue = _queue;
@synthesize observed = _observed;

- (void)dealloc
{
	[[ECKVOManager sharedInstance] removeObserver:self];

    [_path release];
    [_queue release];
    [_action release];
    
    [super dealloc];
}

- (void)observeValueForKeyPath:(NSString *)path ofObject:(id)object change:(NSDictionary *)change context:(void *)context 
{
	// if something else is observing this private object, then some weird shit is going on
    ECAssert(context == &ECObservationContext);
	
	ECDebug(ECKVOChannel, @"path %@ on %@ changed: %@", path, object, change);
	
	if (self.queue == nil) 
	{
		self.action(change);
	}
	
	else
	{
		NSDictionary* copiedChange = [change copy];
		[self.queue addOperationWithBlock: 
		 ^{
			 self.action(copiedChange);
		 }
		 ];
		
		[copiedChange release];
	}
}

- (NSString*)description
{
	return [NSString stringWithFormat:@"<ECObserver %p for %@ on %@", self, self.path, self.observed];
}

@end

@implementation NSObject(ECKVO)

- (NSMutableArray*)registeredObservers
{
    @synchronized (self)
	{
		NSMutableArray* observers = objc_getAssociatedObject(self, ECObserversAssociatedObjectsKey);
		
        if (!observers)
		{
            observers = [NSMutableArray array];
            objc_setAssociatedObject(self, ECObserversAssociatedObjectsKey, observers, OBJC_ASSOCIATION_RETAIN);
        }
        
        return observers;
    }
}

- (ECObserver*)addObserverForKeyPath:(NSString*)path options:(NSKeyValueObservingOptions)options action:(ECObserverAction)action
{
	return [self addObserverForKeyPath:path options:options queue:nil action:action];
}

- (ECObserver*)addObserverForKeyPath:(NSString*)path options:(NSKeyValueObservingOptions)options queue:(NSOperationQueue*)queue action:(ECObserverAction)action
{
	ECAssertNonNil(path);
	ECAssertNonNil(action);
    
	ECObserver* observer = [[ECObserver alloc] init];
	observer.action = action;
	observer.path = path;
	observer.queue = queue;
	observer.observed = self;

	[self addObserver:observer forKeyPath:path options:options context:&ECObservationContext];

	NSMutableArray* observers = [self registeredObservers];
	@synchronized(observers)
	{
		[observers addObject:observer];
		[[ECKVOManager sharedInstance] addObserver:observer];
	}
    
	[observer release];
	
    return observer;
}

- (void)removeObserver:(ECObserver *)observer
{
    [self removeObserver:observer forKeyPath:observer.path];

	NSMutableArray* observers = [self registeredObservers];
	@synchronized(observers)
	{
		[observers removeObject:observer];
	}
}

@end