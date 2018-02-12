// --------------------------------------------------------------------------
//
//  Copyright 2014 Sam Deane, Elegant Chaos. All rights reserved.
//  This source code is distributed under the terms of Elegant Chaos's 
//  liberal license: http://www.elegantchaos.com/license/liberal
// --------------------------------------------------------------------------

#import "NSString+ECCore.h"

@implementation NSString(ECCore)


// --------------------------------------------------------------------------
//! Escape any standard XML entities
// --------------------------------------------------------------------------

- (NSString*)stringByEscapingEntities
{
	NSDictionary* entities = [[self class] entities];
	NSString* result = self;
	for (NSString* entity in entities)
	{
		NSString* character = [entities objectForKey:entity];
		result = [result stringByReplacingOccurrencesOfString:character withString:entity];
	}

	return result;
}

// --------------------------------------------------------------------------
//! Escape any standard XML entities
// --------------------------------------------------------------------------

- (NSString*)stringByUnescapingEntities
{
	NSDictionary* entities = [[self class] entities];
	NSString* result = self;
	for (NSString* entity in entities)
	{
		NSString* character = [entities objectForKey:entity];
		result = [result stringByReplacingOccurrencesOfString:entity withString:character];
	}
	
	return result;
}

@end
