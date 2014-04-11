// --------------------------------------------------------------------------
//
//  Copyright 2014 Sam Deane, Elegant Chaos. All rights reserved.
//  This source code is distributed under the terms of Elegant Chaos's 
//  liberal license: http://www.elegantchaos.com/license/liberal
// --------------------------------------------------------------------------

#import "NSWorkspace+ECCore.h"
#import "NSAppleEventDescriptor+ECCore.h"
#import "ECRandom.h"
#import "NSAppleScript+ECCore.h"
#import "NSURL+ECCoreMac.h"

#import "NSFileManager+ECCore.h"

@interface NSWorkspace(ECCorePrivate)
@end

@implementation NSWorkspace(ECCorePrivate)

// --------------------------------------------------------------------------
//! Return our finder support script.
//! We only ever try to compile the applescript once.
//! If it's missing or doesn't compile, we'll return nil.
// --------------------------------------------------------------------------

- (NSAppleScript*)finderSupportScript
{
	static NSAppleScript* sScript = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		NSBundle* bundle = [NSBundle bundleForClass:[ECRandom class]];
		sScript = [NSAppleScript scriptNamed:@"finder support" fromBundle:bundle];
	});

    return sScript;
}

@end

@implementation NSWorkspace(ECCore)






// --------------------------------------------------------------------------
//! Select an item pointed to by a URL.
// --------------------------------------------------------------------------

- (BOOL)selectURL:(NSURL*)url inFileViewerRootedAtURL:(NSURL*)rootURL
{
	NSString* rootPath = rootURL ? [rootURL path] : @"";
	BOOL result = [self selectFile:[url path] inFileViewerRootedAtPath:rootPath];

	return result;
}

// --------------------------------------------------------------------------
//! Select a URL in the Finder. If it's on the desktop, we just hilight it
//! there, otherwise we open a Finder window for it's parent, and select it
//! in that.
// --------------------------------------------------------------------------

- (BOOL)selectURLIntelligently:(NSURL*)url
{
    BOOL result;
    NSURL* desktop = [[[NSFileManager defaultManager] URLForUserDesktop] URLByResolvingLinksAndAliases];
    NSURL* parent = [url URLByDeletingLastPathComponent];
    if ([parent isEqual:desktop])
    {
        result = [self selectURLOnDesktop:url];
    }
    else
    {
        result = [self selectURL:url inFileViewerRootedAtURL:nil];
    }
    
    return result;
}

// --------------------------------------------------------------------------
//! Select an item pointed to by a URL, on the desktop.
// --------------------------------------------------------------------------

- (BOOL)selectURLOnDesktop:(NSURL*)fullPath
{
    NSAppleScript* finderSupport = [self finderSupportScript];
    NSAppleEventDescriptor* result = [finderSupport callHandler:@"selectFile" withParameters:[fullPath path], nil];

    return result != nil;
}

// --------------------------------------------------------------------------
//! Return whether the URL points at a file package.
// --------------------------------------------------------------------------

- (BOOL)isFilePackageAtURL:(NSURL*)fullPath
{
	return [self isFilePackageAtPath:[fullPath path]];
}

// --------------------------------------------------------------------------
//! Return the icon to use for the item at a URL.
// --------------------------------------------------------------------------

- (NSImage*)	iconForURL:(NSURL*) fullPath
{
	return [self iconForFile: [fullPath path]];
}

// --------------------------------------------------------------------------
//! Return the path of the front Finder window.
//! Returns nil if no windows are open.
//! TODO - should move the script into the framework and not compile it every time
// --------------------------------------------------------------------------

- (NSURL*) urlOfFrontWindow
{
    NSAppleScript* finderSupport = [self finderSupportScript];
    NSURL* url = nil;
    if (finderSupport)
    {
        NSDictionary* error = nil;
        NSAppleEventDescriptor* result = [finderSupport callHandler:@"finderFrontWindow" withParameters:nil];
        if (result)
        {
            url = [NSURL fileURLWithPath: [result stringValue] isDirectory: YES];
        }
        else 
        {
            [ECErrorReporter reportError:nil message:@"failed to run script %@ with error %@", finderSupport, error];
        }
    }

    // attempt to fall back to the desktop directory
    NSFileManager* fm = [NSFileManager defaultManager];
    if (!url || ![fm fileExistsAtURL: url])
    {
        url = [fm URLForUserDesktop];
    }
    
	return url;
}


// --------------------------------------------------------------------------
//! Return the path to the selected item in the finder.
//! Returns nil if no windows are open.
//! TODO - should move the script into the framework and not compile it every time
// --------------------------------------------------------------------------

- (NSArray*) urlsOfSelection
{
    NSAppleScript* finderSupport = [self finderSupportScript];
	NSArray* urls = nil;
    if (finderSupport)
    {
        NSDictionary* error = nil;
        NSAppleEventDescriptor* result = [finderSupport callHandler:@"finderSelection" withParameters:nil];
        if (result)
        {
            urls = [result URLArrayValue];
        }
        else 
        {
            [ECErrorReporter reportError:nil message:@"failed to run script %@ with error %@", finderSupport, error];
        }
    }
	
	return urls;
}


- (void)enableLoginItemWithURL:(NSURL *)itemURL
{
	LSSharedFileListRef loginListRef = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
	
	if (loginListRef) {
		// Insert the item at the bottom of Login Items list.
		LSSharedFileListItemRef loginItemRef = LSSharedFileListInsertItemURL(loginListRef, 
																			 kLSSharedFileListItemLast, 
																			 NULL, 
																			 NULL,
																			 (__bridge CFURLRef)itemURL,
																			 NULL, 
																			 NULL);             
		if (loginItemRef) {
			CFRelease(loginItemRef);
		}
		CFRelease(loginListRef);
	}
}

@end
