//
//  ECKVOManager.m
//  ECCore
//
//  Created by Sam Deane on 26/04/2012.
//  Copyright (c) 2012 Elegant Chaos. All rights reserved.
//

#import "ECKVOManager.h"
#import "ECKVO.h"

#import <CoreFoundation/CoreFoundation.h>

@interface ECKVOManager()

@property (strong, nonatomic) NSMutableArray* observers;

@end

@implementation ECKVOManager

ECDefineDebugChannel(ECKVOChannel);

EC_SYNTHESIZE_SINGLETON(ECKVOManager);

@synthesize observers = _observers;

- (id)init
{
	if ((self = [super init]) != nil)
	{
		self.observers = [(__bridge NSMutableArray*) CFArrayCreateMutable(nil, 0, nil) autorelease];
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
	@synchronized(self)
	{
		CFMutableArrayRef array = (__bridge CFMutableArrayRef) self.observers;
		CFArrayAppendValue(array, observer);
		ECDebug(ECKVOChannel, @"added observer %@", observer);
	}
}

- (void)removeObserver:(ECObserver*)observer
{
	@synchronized(self)
	{
		CFMutableArrayRef array = (__bridge CFMutableArrayRef) self.observers;
		CFRange range = CFRangeMake(0, CFArrayGetCount(array));
		CFIndex index = CFArrayGetFirstIndexOfValue(array, range, observer);
		CFArrayRemoveValueAtIndex(array, index);

		ECDebug(ECKVOChannel, @"removed observer %@", observer);
	}
}

- (NSString*)description
{
	NSMutableString* description = [NSMutableString stringWithString:@"Registered observers:\n"];
	CFMutableArrayRef array = (__bridge CFMutableArrayRef) self.observers;
	CFIndex count = CFArrayGetCount(array);
	for (CFIndex n = 0; n < count; ++n)
	{
		[description appendFormat:@"\t%@\n", CFArrayGetValueAtIndex(array, n)];
	}
	
	return description;
}

- (void)dumpObservers
{
	ECDebug(ECKVOChannel, @"%@", [self description]);
}

- (NSUInteger)observerCount
{
	return CFArrayGetCount((__bridge CFMutableArrayRef) self.observers);
}

- (ECObserver*)observerAtIndex:(NSUInteger)index
{
	return CFArrayGetValueAtIndex((__bridge CFMutableArrayRef) self.observers, index);
}

@end
