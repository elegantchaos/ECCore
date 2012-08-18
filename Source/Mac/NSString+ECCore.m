// --------------------------------------------------------------------------
//! @author Sam Deane
//! @date 21/04/2012
//
//  Copyright 2012 Sam Deane, Elegant Chaos. All rights reserved.
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
	NSString* result = (NSString*)CFXMLCreateStringByEscapingEntities(NULL, (CFStringRef)self, NULL);
	
	return [result autorelease];
}

// --------------------------------------------------------------------------
//! Escape any standard XML entities
// --------------------------------------------------------------------------

- (NSString*)stringByUnescapingEntities
{
	NSString* result = (NSString*)CFXMLCreateStringByUnescapingEntities(NULL, (CFStringRef)self, NULL);
	
	return [result autorelease];
}

@end
