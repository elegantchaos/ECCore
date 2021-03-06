// --------------------------------------------------------------------------
//
//  Copyright 2013 Sam Deane, Elegant Chaos. All rights reserved.
//  This source code is distributed under the terms of Elegant Chaos's 
//  liberal license: http://www.elegantchaos.com/license/liberal
// --------------------------------------------------------------------------

#import "NSURL+ECCore.h"
#import "NSString+ECCore.h"
#import "NSData+ECCore.h"


@implementation NSURL(ECCore)

ECDefineDebugChannel(NSURLChannel);

// --------------------------------------------------------------------------
//! Get a URL that points at a resource file.
// --------------------------------------------------------------------------

+ (NSURL*) URLWithResourceNamed: (NSString*) name ofType: (NSString*) type
{
	NSURL* url = [[NSURL alloc] initWithResourceNamed: name ofType: type];
	return [url autorelease];
}

// --------------------------------------------------------------------------
//! Initialise a URL to point at a resource file.
// --------------------------------------------------------------------------

- (id) initWithResourceNamed: (NSString*) name ofType: (NSString*) type
{
	NSBundle* bundle = [NSBundle mainBundle];
	NSString* path = [bundle pathForResource: name ofType: type];
	if (path)
	{
		self = [self initFileURLWithPath: path isDirectory: NO];
	}
	else
	{
		[self release];
		self = nil;
	}
	
	return self;
}


// --------------------------------------------------------------------------
//! Get a unique name to use for a file in a folder, using the default
//! file manager.
// --------------------------------------------------------------------------

- (NSURL*) getUniqueFileWithName:(NSString*)name andExtension:(NSString*)extension
{
	return [self getUniqueFileWithName: name andExtension: extension usingManager: [NSFileManager defaultManager]];
}

// --------------------------------------------------------------------------
//! Get a unique name to use for a file in a folder.
//! If the file "name.extension" doesn't exist, we just use it. Otherwise
//! we try "name 1.extension", "name 2.extension" and so on, until we find
//! one that doesn't exist.
// --------------------------------------------------------------------------

- (NSURL*) getUniqueFileWithName:(NSString*)name andExtension:(NSString*)extension usingManager:(NSFileManager*)fileManager
{
    BOOL useExension = [extension length] > 0;
	NSInteger iteration = 0;
	NSURL* result;
	NSString* newName = name;
	do
	{
        result = [self URLByAppendingPathComponent:newName];
        if (useExension)
        {
            result = [result URLByAppendingPathExtension: extension];
        }
		newName = [NSString stringWithFormat: @"%@ %ld", name, (long) ++iteration];
	} while ([fileManager fileExistsAtPath: [result path]]);
	
	ECDebug(NSURLChannel, @"got unique filename %@ for file %@", result, name);
	return result;
}

@end

