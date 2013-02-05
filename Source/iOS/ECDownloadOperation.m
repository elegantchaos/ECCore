// --------------------------------------------------------------------------
//
//  Created by Sam Deane on 14/06/2012.
//  Copyright 2013 Sam Deane, Elegant Chaos. All rights reserved.
//  This source code is distributed under the terms of Elegant Chaos's 
//  liberal license: http://www.elegantchaos.com/license/liberal
// --------------------------------------------------------------------------

#import "ECDownloadOperation.h"
#import "UIApplication+ECCore.h"

@interface ECDownloadOperation()

#pragma mark - Private Properties

@property (copy, nonatomic) CompletionHandler completion;           //!< The handler we'll call when the download finishes or fails.
@property (strong, nonatomic) NSURLConnection* connection;          //!< The download connection.
@property (strong, nonatomic) NSMutableData* data;                  //!< The data we've downloaded.
@property (assign, nonatomic) double length;                        //!< Expected length of the data.
@property (copy, nonatomic) ProgressHandler progress;               //!< The handler we'll call to report progress.
@property (strong, nonatomic) NSURLRequest* request;				//!< The request for the download.
@property (strong, nonatomic) NSURLResponse* response;              //!< The HTTP response we got back from the server.

@end

@implementation ECDownloadOperation

#pragma mark - Synthesized Properties

@synthesize completion = _completion;
@synthesize connection = _connection;
@synthesize data = _data;
@synthesize executing = _executing;
@synthesize finished = _finished;
@synthesize length = _length;
@synthesize progress = _progress;
@synthesize response = _response;
@synthesize request = _request;
@synthesize runLoop = _runLoop;

#pragma mark - Object Lifecycle

//! Utility to create a download task and add it to a queue.
//! @return The task we created.

+ (id)sendAsynchronousRequest:(NSURLRequest*)request queue:(NSOperationQueue*) queue completionHandler:(CompletionHandler)completion
{
	return [[self class] sendAsynchronousRequest:request queue:queue completionHandler:completion progressHandler:nil];
}

+ (id)sendAsynchronousRequest:(NSURLRequest*)request queue:(NSOperationQueue*) queue completionHandler:(CompletionHandler)completion progressHandler:(ProgressHandler)progress
{
    ECDownloadOperation* operation = [[ECDownloadOperation alloc] initWithRequest:request completionHandler:completion progressHandler:progress];
    
    [queue addOperation:operation];
    
    return [operation autorelease];
}

//! Create a download task for the given request.
//! @return the new task

- (id)initWithRequest:(NSURLRequest*)request completionHandler:(CompletionHandler)completion progressHandler:(ProgressHandler)progress
{
    if ((self = [super init]) != nil)
    {
        self.request = request;
        self.completion = completion;
        self.progress = progress;
        self.runLoop = [NSRunLoop mainRunLoop];
    }
    
    return self;
}

//! Clean up.

- (void)dealloc 
{
    [_completion release];
    [_connection release];
    [_data release];
    [_progress release];
    [_request release];
    [_response release];
    [_runLoop release];
    
    [super dealloc];
}

#pragma mark - NSOperation 

//! Is this a concurrent operation?

- (BOOL)isConcurrent
{
    return YES;
}

//! Start the connection.
//! We do this on the main thread to ensure that it's scheduled on the main run loop.

- (void)start
{
	// Always check for cancellation before launching the task.
	if ([self isCancelled])
	{
		// Must move the operation to the finished state if it is canceled.
		[self willChangeValueForKey:@"isFinished"];
		self.finished = YES;
		[self didChangeValueForKey:@"isFinished"];
	}
	else
	{
		[self willChangeValueForKey:@"isExecuting"];
		self.executing = YES;
		[self didChangeValueForKey:@"isExecuting"];

		dispatch_async(dispatch_get_main_queue(), ^{
			[[UIApplication sharedApplication] networkOperationStarted];
			self.connection = [NSURLConnection connectionWithRequest:self.request delegate:self];
			[self.connection start];
			
		});
	}
}

//! Stop executing the task, ensuring that we spit out the relevant KVO notifications
- (void)finish
{
	[self willChangeValueForKey:@"isFinished"];
	[self willChangeValueForKey:@"isExecuting"];
	
	self.executing = NO;
	self.finished = YES;
	
	[self didChangeValueForKey:@"isExecuting"];
	[self didChangeValueForKey:@"isFinished"];
	
	[[UIApplication sharedApplication] networkOperationEnded];
}

//! Cancel a download. We cancel the connection, then wait for the relevant callbacks to occur
//! before cleaning up.

- (void)cancel
{
    [self.connection cancel];
    [super cancel];
}

#pragma mark - Utilities

//! Check if something has cancelled our NSOperation.
//! If it has, we cancel our connection, and wait for the relevant callbacks to occur before cleaning up.

- (void)checkForCancellation
{
    if ([self isCancelled])
    {
        [self.connection cancel];
    }
}

#pragma mark - NSURLConnection Delegate

//! Handle a response from the server.
//! If possible we record the length of the expected data.
//! Then we make a new data object to record the data in.

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)response
{
    self.response = response;
    long long length = response.expectedContentLength;
    if (length == -1)
    {
        length = [[[response allHeaderFields] objectForKey:@"Content-Length"] intValue];
        if (!length)
        {
            length = INT_MAX;
        }
    }
    self.length = length;
    self.data = [NSMutableData data];
	if (self.progress)
	{
		self.progress(self.response, self.data, 0.0);
	}
    [self checkForCancellation];
}

//! Record the data we received, and update the progress.

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.data appendData:data];
	if (self.progress)
	{
		double lengthSoFar = [self.data length];
		double progress = lengthSoFar / self.length;
		self.progress(self.response, self.data, progress);
	}
    [self checkForCancellation];
}

//! Report an error.

- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
    self.completion(self.response, self.data, error);
	[self finish];
    self.connection = nil;
    self.response = nil;
}

//! The connection succeeded. Report this, then clean up.

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	if (self.progress)
	{
		self.progress(self.response, self.data, 1.0);
	}
    self.completion(self.response, self.data, nil);
	[self finish];
    self.connection = nil;
    self.response = nil;
}

@end
