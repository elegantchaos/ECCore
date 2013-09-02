// --------------------------------------------------------------------------
//
//  Copyright 2013 Sam Deane, Elegant Chaos. All rights reserved.
//  This source code is distributed under the terms of Elegant Chaos's 
//  liberal license: http://www.elegantchaos.com/license/liberal
// --------------------------------------------------------------------------

#import "NSURL+ECCoreMac.h"

#import <CoreFoundation/CoreFoundation.h>

@implementation NSURL(ECCoreMac)

// --------------------------------------------------------------------------
//! Make an FSRef representing this URL
//! Just a convenience wrapper for a CFURL routine.
// --------------------------------------------------------------------------

- (BOOL)asFSRef:(FSRef*)ref
{
    ECAssert([self isFileURL]);

    BOOL result = CFURLGetFSRef((CFURLRef) self, ref) != false;
    return result;
}

// --------------------------------------------------------------------------
//! Return an NSURL for the file represented by an FSRef.
//! Just a convenience wrapper for a CFURL routine.
// --------------------------------------------------------------------------

+ (NSURL*)URLWithFSRef:(FSRef*)ref
{
    NSURL* result = (__bridge_transfer NSURL*) CFURLCreateFromFSRef(kCFAllocatorDefault, ref);
    return result;
}

@end

@implementation NSURL(ECCorePlatform)

// --------------------------------------------------------------------------
//! Return a representation of this URL with any symbolic links and Finder
//! aliases fully resolved.
// --------------------------------------------------------------------------

- (NSURL*)URLByResolvingLinksAndAliases
{
    NSURL* result = [self URLByResolvingSymlinksInPath];
    
    ECDebugIf(![result isEqualTo:self], NSURLChannel, @"resolved symbolic link %@ as %@", self, result);

    FSRef ref;
    if ([result asFSRef:&ref])
    {
        Boolean isAlias, isFolder;
        OSStatus status = FSResolveAliasFileWithMountFlags(&ref, true, &isFolder, &isAlias, kResolveAliasFileNoUI);
        if ([ECErrorReporter checkStatus:status] && isAlias)
        {
            NSURL* resolved = [NSURL URLWithFSRef:&ref];
            if (resolved)
            {
                ECDebug(NSURLChannel, @"resolved finder alias %@ as %@", result, resolved);
                result = resolved;
            }
        }
    }

    return result;
}

@end
