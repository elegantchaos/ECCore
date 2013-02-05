//
//  NSBundle+ECCore.m
//  ECFoundation
//
//  Created by Sam Deane on 13/03/2011.
//  Copyright 2012, Sam Deane Elegant Chaos. All rights reserved.
//

#import "NSBundle+ECCore.h"


@implementation NSBundle(ECCore)


// --------------------------------------------------------------------------
//! Return the bundle name of the bundle.
// --------------------------------------------------------------------------

- (NSString*) bundleName
{
    NSDictionary* info = [self infoDictionary];
    NSString* result = info[@"CFBundleName"];
    
    return result;
}

// --------------------------------------------------------------------------
//! Return the user readable bundle version (e.g. 1.2).
// --------------------------------------------------------------------------

- (NSString*) bundleVersion
{
    NSDictionary* info = [self infoDictionary];
    NSString* result = info[@"CFBundleShortVersionString"];
    
    return result;
}

// --------------------------------------------------------------------------
//! Return the real bundle version (typically a build number, like 1535).
// --------------------------------------------------------------------------

- (NSString*) bundleBuild
{
    NSDictionary* info = [self infoDictionary];
    NSString* result = info[@"CFBundleVersion"];
    
    return result;
}

// --------------------------------------------------------------------------
//! Return a string showing the bundle version, with the build number,
//! eg "Version 1.0b2 (343)"
// --------------------------------------------------------------------------

- (NSString*) bundleFullVersion
{
    NSDictionary* info = [self infoDictionary];
    NSString *mainString = [info valueForKey:@"CFBundleShortVersionString"];
    NSString *subString = [info valueForKey:@"CFBundleVersion"];
    NSString* result = [NSString stringWithFormat:@"Version %@ (%@)", mainString, subString];
    
    return result;
}

// --------------------------------------------------------------------------
//! Return the user readable copyright notice for the bundle.
// --------------------------------------------------------------------------

- (NSString*) bundleCopyright
{
    NSDictionary* info = [self infoDictionary];
    NSString* result = info[@"NSHumanReadableCopyright"];
    
    return result;
}

@end
