//
//  ECKVO.h
//  ECCore
//
//  Created by Sam Deane on 26/04/2012.
//  Copyright (c) 2012 Elegant Chaos. All rights reserved.
//
// Inspired by DGKVO and various other KVO-with-blocks related talks/discussions/blog articles.

#import <Foundation/Foundation.h>

typedef void (^ECObserverAction)(NSDictionary *change);

@class ECObserver;

@interface NSObject (ECKVO)

- (ECObserver*)addObserverForKeyPath:(NSString*)keyPath options:(NSKeyValueObservingOptions)options action:(ECObserverAction)action;
- (ECObserver*)addObserverForKeyPath:(NSString*)keyPath options:(NSKeyValueObservingOptions)options queue:(NSOperationQueue*)queue action:(ECObserverAction)action;
- (void)removeObserver:(ECObserver*)observer;

@end

