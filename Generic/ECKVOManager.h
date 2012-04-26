//
//  ECKVOManager.h
//  ECCore
//
//  Created by Sam Deane on 26/04/2012.
//  Copyright (c) 2012 Elegant Chaos. All rights reserved.
//

#import "ECSingleton.h"
#import "ECLogging.h"

@class ECObserver;
@interface ECKVOManager : NSObject

ECDeclareDebugChannel(ECKVOChannel);

EC_SINGLETON(ECKVOManager);

@property (strong, nonatomic) NSMutableArray* observers;

- (void)addObserver:(ECObserver*)observer;
- (void)removeObserver:(ECObserver*)observer;
- (void)dumpObservers;

@end
