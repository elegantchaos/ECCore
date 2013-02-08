// --------------------------------------------------------------------------
//  Copyright 2013 Sam Deane, Elegant Chaos. All rights reserved.
//  This source code is distributed under the terms of Elegant Chaos's
//  liberal license: http://www.elegantchaos.com/license/liberal
// --------------------------------------------------------------------------

#import "ECSingleton.h"

@class ECObserver;
@interface ECKVOManager : NSObject

ECDeclareDebugChannel(ECKVOChannel);

EC_SINGLETON(ECKVOManager);

- (void)addObserver:(ECObserver*)observer;
- (void)removeObserver:(ECObserver*)observer;
- (void)dumpObservers;
- (NSUInteger)observerCount;
- (ECObserver*)observerAtIndex:(NSUInteger)index;

@end
