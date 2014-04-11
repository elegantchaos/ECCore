// --------------------------------------------------------------------------
//
//  Copyright 2014 Sam Deane, Elegant Chaos. All rights reserved.
//  This source code is distributed under the terms of Elegant Chaos's 
//  liberal license: http://www.elegantchaos.com/license/liberal
// --------------------------------------------------------------------------

#import <ECUnitTests/ECUnitTests.h>

#import "NSAppleEventDescriptor+ECCore.h"

@interface NSAppleEventDescriptorTests : ECTestCase

@end

@implementation NSAppleEventDescriptorTests

static NSString *const TestFilePath = @"/Applications/Preview.app";
static const char* TestFileURL = "file://localhost/Applications/Preview.app";

// --------------------------------------------------------------------------
//! Test coercing descriptor into a url.
// --------------------------------------------------------------------------

- (void) testURLValues
{
	NSAppleEventDescriptor* path = [NSAppleEventDescriptor descriptorWithString:TestFilePath];
	ECTestAssertNotNil(path);
	
	NSURL* url = [path URLValue];
	ECTestAssertStringIsEqual([url path], TestFilePath);
	
	NSAppleEventDescriptor* fullURL = [NSAppleEventDescriptor descriptorWithString: @"http://www.elegantchaos.com"];
	ECTestAssertNotNil(fullURL);
	
	url = [fullURL URLValue];
	ECTestAssertStringIsEqual([url absoluteString], @"http://www.elegantchaos.com");
	
	NSAppleEventDescriptor* fileURL = [NSAppleEventDescriptor descriptorWithDescriptorType:typeFileURL bytes:TestFileURL length:strlen(TestFileURL)];

	url = [fileURL URLValue];
	ECTestAssertStringIsEqual([url path], TestFilePath);
}

// --------------------------------------------------------------------------
//! Test coercing a descriptor into an NSArray of NSStrings.
// --------------------------------------------------------------------------

- (void) testStringArrayValue
{
	NSAppleEventDescriptor* desc = [NSAppleEventDescriptor listDescriptor];
	ECTestAssertNotNil(desc);
	[desc insertDescriptor: [NSAppleEventDescriptor descriptorWithString: @"/Test/1.txt"] atIndex: 1];
	[desc insertDescriptor: [NSAppleEventDescriptor descriptorWithString: @"/Test/2.txt"] atIndex: 2];
	ECTestAssertIntegerIsEqual([desc numberOfItems], 2);
	
	NSArray* array = [desc stringArrayValue];
	ECTestAssertIntegerIsEqual([array count], 2);
	ECTestAssertStringIsEqual([array objectAtIndex: 0], @"/Test/1.txt");
	ECTestAssertStringIsEqual([array objectAtIndex: 1], @"/Test/2.txt");
}

// --------------------------------------------------------------------------
//! Test coercing a descriptor into an NSArray of NSURLs.
// --------------------------------------------------------------------------

- (void) testURLArrayValue
{
	NSAppleEventDescriptor* desc = [NSAppleEventDescriptor listDescriptor];
	ECTestAssertNotNil(desc);
	[desc insertDescriptor: [NSAppleEventDescriptor descriptorWithString: @"/Test/1.txt"] atIndex: 1];
	[desc insertDescriptor: [NSAppleEventDescriptor descriptorWithString: @"/Test/2.txt"] atIndex: 2];
	ECTestAssertIntegerIsEqual([desc numberOfItems], 2);
	
	NSArray* array = [desc URLArrayValue];
	ECTestAssertIntegerIsEqual([array count], 2);
	ECTestAssertStringIsEqual([[array objectAtIndex: 0] path], @"/Test/1.txt");
	ECTestAssertStringIsEqual([[array objectAtIndex: 1] path], @"/Test/2.txt");
}

@end
