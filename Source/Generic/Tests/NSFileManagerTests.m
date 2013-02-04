// --------------------------------------------------------------------------
//! @author Sam Deane
//! @date 09/12/2011
//
//  Copyright 2013 Sam Deane, Elegant Chaos. All rights reserved.
//  This source code is distributed under the terms of Elegant Chaos's 
//  liberal license: http://www.elegantchaos.com/license/liberal
// --------------------------------------------------------------------------

#import <ECUnitTests/ECUnitTests.h>
#import <ECCore/ECCore.h>

@interface NSFileManagerTests : ECTestCase

@property (nonatomic, assign) NSFileManager* fm;

@end

@implementation NSFileManagerTests

@synthesize fm;

- (void)setUp
{
	self.fm = [NSFileManager defaultManager];
}

- (void)testFileExistsURL
{
	NSURL* url = [self exampleBundleURL];
	ECTestAssertTrue([self.fm fileExistsAtURL:url]);
	
	BOOL isDirectory = NO;
	ECTestAssertTrue([self.fm fileExistsAtURL:url isDirectory:&isDirectory]);
	ECTestAssertTrue(isDirectory);
}

- (void)testURLStuff
{
	// can't really test the actual path - the best we can do is test that it's non zero, and that it exists
	// NB not sure if this will always be true, so this unit test may need changing at some point
	NSString* path = [[self.fm URLForApplication] path];
	ECTestAssertIntegerIsGreater([path length], 0);
	ECTestAssertTrue([fm fileExistsAtPath:path]);
	
	// NB not sure if this test will pass for non-English language systems
	path = [[self.fm URLForUserDesktop] path];
	ECTestAssertStringEndsWith(path, @"/Desktop");

	path = [[self.fm URLForApplicationDataPath:@"test app data"] path];
	ECTestAssertStringEndsWith(path, @"/test app data");

	path = [[self.fm URLForCachedDataPath:@"test cached data"] path];
	ECTestAssertStringEndsWith(path, @"test cached data");

	ECTestAssertNotEmpty([self.fm URLsForApplicationDataPath:@"test app data" inDomains:NSAllDomainsMask mode:IncludeMissingItems]);
	ECTestAssertNotEmpty([self.fm URLsForCachedDataPath:@"test app data" inDomains:NSAllDomainsMask mode:IncludeMissingItems]);
}

- (void)testCreateDirectory
{
	NSURL* temp = [self.fm URLForTemporaryDirectory];
	NSURL* intermediate = [temp URLByAppendingPathComponent:@"folder"];
	NSURL* url = [intermediate URLByAppendingPathComponent:@"test"];
	
	// make a test folder hierarchy
	NSError* error = nil;
	BOOL ok = [self.fm createDirectoryAtURL:url withIntermediateDirectories:YES attributes:nil error:&error];
	ECTestAssertNil(error);
	ECTestAssertTrue(ok);
	if (ok)
	{
		ECTestAssertTrue([self.fm fileExistsAtURL:intermediate]);
		ECTestAssertTrue([self.fm fileExistsAtURL:url]);

		// try to clean up if things went ok
		ok = [self.fm removeItemAtURL:url error:&error];
		ECTestAssertNil(error);
		ECTestAssertTrue(ok);
		
		if (ok)
		{
			// try to clean up intermediate folder too
			ok = [self.fm removeItemAtURL:intermediate error:&error];
			ECTestAssertNil(error);
			ECTestAssertTrue(ok);
		}
	}
}

@end
