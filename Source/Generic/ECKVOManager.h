//
//  ECKVOManager.h
//  ECCore
//
//  Created by Sam Deane on 26/04/2012.
//  Copyright (c) 2012 Elegant Chaos. All rights reserved.
//

#import <ECLogging/ECLogging.h>

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
