// --------------------------------------------------------------------------
//  Copyright 2014 Sam Deane, Elegant Chaos. All rights reserved.
//  This source code is distributed under the terms of Elegant Chaos's
//  liberal license: http://www.elegantchaos.com/license/liberal
//
// Inspired by DGKVO and various other KVO-with-blocks related talks/discussions/blog articles.
// --------------------------------------------------------------------------

#import <Foundation/Foundation.h>

typedef void (^ECObserverAction)(NSDictionary *change);

@class ECObserver;

@interface NSObject (ECKVO)

- (ECObserver*)addObserverForKeyPath:(NSString*)keyPath options:(NSKeyValueObservingOptions)options action:(ECObserverAction)action;
- (ECObserver*)addObserverForKeyPath:(NSString*)keyPath options:(NSKeyValueObservingOptions)options queue:(NSOperationQueue*)queue action:(ECObserverAction)action;
- (void)removeObserver:(ECObserver*)observer;

@end

