// --------------------------------------------------------------------------
//
//  Created by Sam Deane on 14/06/2012.
//  Copyright 2014 Sam Deane, Elegant Chaos. All rights reserved.
//  This source code is distributed under the terms of Elegant Chaos's 
//  liberal license: http://www.elegantchaos.com/license/liberal
// --------------------------------------------------------------------------

#import <Foundation/Foundation.h>

//! Block which is called when the download completes or fails.

typedef void (^CompletionHandler)(NSURLResponse* response, NSData* data, NSError* error);

//! Block which is called as data comes in.

typedef void (^ProgressHandler)(NSURLResponse* response, NSData* data, double progress);

//! NSOperation subclass which performs a download asynchronously.
//! On completion it calls a block (which takes the same parameters as NSURLConnection sendAsynchronousRequest:queue:completionHandler:).
//! It also periodically calls a block as it receives data, allowing a user interface to monitor the download's progress.

@interface ECDownloadOperation : NSOperation<NSURLConnectionDelegate>

//! Is the operation executing?

@property (assign, atomic, getter=isExecuting) BOOL executing;

//! Has the operation finished?

@property (assign, atomic, getter=isFinished) BOOL finished;

//! The run loop for the NSURLConnection to use.
//! By default we use the main loop, which should be fine for most purposes.

@property (strong, nonatomic) NSRunLoop* runLoop;

//! Create a new operation and add it to a queue.
//! @param request The request we're going to perform.
//! @param queue The queue to add the operation to.
//! @param completion Block to call when we finish or fail.
//! @param progress Block to call periodically with progress.

+ (id)sendAsynchronousRequest:(NSURLRequest*)request queue:(NSOperationQueue*) queue completionHandler:(CompletionHandler)completion progressHandler:(ProgressHandler)progress;
+ (id)sendAsynchronousRequest:(NSURLRequest*)request queue:(NSOperationQueue*) queue completionHandler:(CompletionHandler)completion;

//! Create a new operation.
//! @param request The request we're going to perform.
//! @param completion Block to call when we finish or fail.
//! @param progress Block to call periodically with progress.

- (id)initWithRequest:(NSURLRequest*)request completionHandler:(CompletionHandler)completion progressHandler:(ProgressHandler)progress;

@end
