// --------------------------------------------------------------------------
//! @author Sam Deane
//! @date 14/07/2010
//
//! Elegant Chaos extensions to NSAppleEventDescriptor.
//
//  Copyright 2013 Sam Deane, Elegant Chaos. All rights reserved.
//  This source code is distributed under the terms of Elegant Chaos's 
//  liberal license: http://www.elegantchaos.com/license/liberal
// --------------------------------------------------------------------------

#import "NSAppleEventDescriptor+ECCore.h"

@implementation NSAppleEventDescriptor(ECCore)

// --------------------------------------------------------------------------
//! Return the value of the descriptor as a URL.
// --------------------------------------------------------------------------

- (NSURL*) URLValue
{
	NSURL* url = nil;

	// if we've been given a file type, try to coerce it into a typeFileURL, then extract the URL directly
	OSType type = self.typeCodeValue;
	switch (type)
	{
		case typeFileURL:
		case typeFSRef:
		case typeAlias:
		case 'elif':
		{
			NSAppleEventDescriptor* coercedDescriptor = [self coerceToDescriptorType:typeFileURL];
			NSString* coercedString = [[NSString alloc] initWithData:[coercedDescriptor data] encoding:NSUTF8StringEncoding];
			if (coercedString)
			{
				url = [NSURL URLWithString:coercedString];
				[coercedString release];
			}
			break;
		}

		default:
			break;
	}

	// if it wasn't a file, or we couldn't coerce it to be a file url, try treating it as a URL in string form
	if (!url)
	{
		url = [NSURL URLWithString:[self stringValue]];
	}

	// if we made it into a URL but there didn't appear to be a scheme, try
	// turning it into a string and treating that as a file path
	if (!url || [url.scheme length] == 0)
	{
		url = [NSURL fileURLWithPath:[self stringValue]];
	}

	return url;
}

// --------------------------------------------------------------------------
//! Return the value of the descriptor as an array of strings.
// --------------------------------------------------------------------------

- (NSArray*) stringArrayValue
{
	NSMutableArray* strings = [[[NSMutableArray alloc] init] autorelease];
	
	NSInteger count = [self numberOfItems];
	for (NSInteger index = 1; index <= count; ++index)
	{
		NSAppleEventDescriptor* descriptor = [self descriptorAtIndex: index];
		NSString* string = [[descriptor stringValue] copy];
		[strings addObject: string];
		[string release];
	}
	
	return strings;
}

// --------------------------------------------------------------------------
//! Return the value of the descriptor as an array of URLs.
// --------------------------------------------------------------------------

- (NSArray*) URLArrayValue
{
	NSMutableArray* urls = [[[NSMutableArray alloc] init] autorelease];
	
	NSInteger count = [self numberOfItems];
	for (NSInteger index = 1; index <= count; ++index)
	{
		NSAppleEventDescriptor* descriptor = [self descriptorAtIndex:index];
		[urls addObject: [descriptor URLValue]];
	}
	
	return urls;
}

// --------------------------------------------------------------------------
//! Return the value of the descriptor as a sorted array of strings.
// --------------------------------------------------------------------------

- (NSArray*) stringArraySortedValue
{
    NSArray* strings = [self stringArrayValue];
    NSArray* sorted = [strings sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    
    return sorted;
}


@end
