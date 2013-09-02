// --------------------------------------------------------------------------
//
//  Copyright 2013 Sam Deane, Elegant Chaos. All rights reserved.
//  This source code is distributed under the terms of Elegant Chaos's 
//  liberal license: http://www.elegantchaos.com/license/liberal
// --------------------------------------------------------------------------

#import "NSString+ECCore.h"

#import <CoreFoundation/CoreFoundation.h>

@implementation NSString(ECCore)

// --------------------------------------------------------------------------
//! Escape any standard XML entities
// --------------------------------------------------------------------------

- (NSString*)stringByEscapingEntities
{
	NSString* result = (__bridge_transfer NSString*)CFXMLCreateStringByEscapingEntities(NULL, (__bridge CFStringRef)self, NULL);
	
	return result;
}

// --------------------------------------------------------------------------
//! Escape any standard XML entities
// --------------------------------------------------------------------------

- (NSString*)stringByUnescapingEntities
{
	NSString* result = (__bridge_transfer NSString*)CFXMLCreateStringByUnescapingEntities(NULL, (__bridge CFStringRef)self, NULL);
	
	return result;
}

@end
