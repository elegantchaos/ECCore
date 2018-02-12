// --------------------------------------------------------------------------
//
//  Created by Sam Deane on 11/08/2010.
//  Copyright 2014 Sam Deane, Elegant Chaos. All rights reserved.
//  This source code is distributed under the terms of Elegant Chaos's 
//  liberal license: http://www.elegantchaos.com/license/liberal
// --------------------------------------------------------------------------

#import "NSString+ECCoreGeneric.h"
#import "NSData+ECCore.h"

@implementation NSString(ECCoreGeneric)

+ (NSDictionary*)entities
{
	NSDictionary* entities = [NSDictionary dictionaryWithObjectsAndKeys:
							  @"&", @"&amp;",
							  @"<", @"&lt;",
							  @">", @"&gt;",
							  @"\"", @"&quot;",
							  @"'", @"&apos;",
							  @"–", @"&mdash;",
							  nil];
	
	return entities;
}

+ (NSString*)stringWithOrdinal:(NSInteger)ordinal
{
    NSString* suffix;
	NSInteger mod = ordinal % 10;
    if (((mod >= 4) && (mod <= 20)) || (mod == 0))
    {
        suffix = @"th";
    }
    else
    {
		mod = ordinal % 100;
		if ((mod >= 11) && (mod <= 14))
		{
			suffix = @"th";
		}
		else
		{
			NSString* suffixes[] = { @"st", @"nd", @"rd" };
			suffix = suffixes[(ordinal % 10) - 1];
		}
    }
    
    NSString* result = [NSString stringWithFormat:@"%ld%@", (long)ordinal, suffix];
    return result;
}

- (NSData*) splitWordsIntoInts
{
	NSArray* numbers = [self componentsSeparatedByString: @" "];
	NSUInteger count = [numbers count];
	NSMutableData* data = [[NSMutableData alloc] initWithLength: sizeof(int) * count];
	int* buffer = [data mutableBytes];
	for (NSString* index in numbers)
	{
		*buffer++ = [index intValue];
	}
	
	return data;
}

- (NSData*) splitWordsIntoFloats
{
	NSArray* numbers = [self componentsSeparatedByString: @" "];
	NSUInteger count = [numbers count];
	NSMutableData* data = [[NSMutableData alloc] initWithLength: sizeof(float) * count];
	float* buffer = [data mutableBytes];
	for (NSString* index in numbers)
	{
		*buffer++ = [index floatValue];
	}

	return data;
}

- (NSData*) splitWordsIntoDoubles
{
	NSArray* numbers = [self componentsSeparatedByString: @" "];
	NSUInteger count = [numbers count];
	NSMutableData* data = [[NSMutableData alloc] initWithLength: sizeof(double) * count];
	double* buffer = [data mutableBytes];
	for (NSString* index in numbers)
	{
		*buffer++ = [index doubleValue];
	}
	
	return data;
}


+ (NSString*)stringWithMixedCapsFromWords:(NSArray*)words initialCap:(BOOL)initialCap
{
	NSMutableString* result = [[NSMutableString alloc] init];
	for (NSString* word in words)
	{
		if (initialCap)
		{
			[result appendString:[word capitalizedString]];
		}
		else
		{
			[result appendString:[word lowercaseString]];
			initialCap = YES;
		}
	}
	
	return result;
}

+ (NSString*)stringWithUppercaseFromWords:(NSArray*)words separator:(NSString*)separator
{
	NSMutableString* result = [[NSMutableString alloc] init];
	for (NSString* word in words)
	{
		[result appendString:[word uppercaseString]];
		[result appendString:separator];
	}
	
	NSUInteger separatorLength = [separator length];
	[result deleteCharactersInRange:NSMakeRange([result length] - separatorLength, separatorLength)];
	
	return result;
}

+ (NSString*)stringWithLowercaseFromWords:(NSArray*)words separator:(NSString*)separator
{
	NSMutableString* result = [[NSMutableString alloc] init];
	for (NSString* word in words)
	{
		[result appendString:[word lowercaseString]];
		[result appendString:separator];
	}
	
	NSUInteger separatorLength = [separator length];
	[result deleteCharactersInRange:NSMakeRange([result length] - separatorLength, separatorLength)];
	
	return result;
}

+ (NSString*)stringWithNewUUID
{
    CFUUIDRef uuidObj = CFUUIDCreate(nil);
    NSString *newUUID = (__bridge_transfer NSString*)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
    return newUUID;
}

+ (NSString*)stringByFormattingCount:(NSUInteger)count singularFormat:(NSString*)singularFormat pluralFormat:(NSString*)pluralFormat
{
    NSString* format = (count == 1) ? singularFormat : pluralFormat;
    NSString* result = [NSString stringWithFormat:format, count];

    return result;
}

- (NSString*)truncateToLength:(NSUInteger)length
{
	NSString* result;
	
	if (length == 0)
	{
		result = @"";
	}
	else
	{
		NSUInteger actualLength = [self length];
		if (actualLength <= length)
		{
			result = self;
		}
		else
		{
			result = [NSString stringWithFormat:@"%@…", [self substringToIndex: length - 1]];
		}
	}
	
	return result;
}

// --------------------------------------------------------------------------
//! Does this string begin with another string?
//! Returns NO when passed the empty string.
// --------------------------------------------------------------------------

- (BOOL)beginsWithString:(NSString *)string
{
	NSRange range = [self rangeOfString:string];
	
	return range.location == 0;
}

// --------------------------------------------------------------------------
//! Does this string end with another string.
//! Returns NO when passed the empty string.
// --------------------------------------------------------------------------

- (BOOL)endsWithString:(NSString *)string
{
	NSUInteger length = [string length];
	BOOL result = length > 0;
	if (result)
	{
		NSUInteger ourLength = [self length];
		result = (length <= ourLength);
		if (result)
		{
			NSString* substring = [self substringFromIndex:ourLength - length];
			result = [string isEqualToString:substring];
		}
	}

	return result;
}

// --------------------------------------------------------------------------
//! Does this string contain another string?
//! Returns NO when passed the empty string.
// --------------------------------------------------------------------------

- (BOOL)containsString:(NSString *)string
{
	NSRange range = [self rangeOfString:string];
	
	return range.location != NSNotFound;
}

- (NSString*)stringWithInitialCapital
{
	NSString* result;
	if ([self length] < 2)
		result = [self uppercaseString];
	else
		result = [[[self substringToIndex:1] uppercaseString] stringByAppendingString:[self substringFromIndex:1]];
	return result;
}

- (NSString*)uppercaseUnderscoreStringFromMixedCase
{
    NSArray* words = [self componentsSeparatedByMixedCaps];
    NSString* result = [NSString stringWithUppercaseFromWords:words separator:@"_"];

    return result;
}

- (NSString*)lowercaseUnderscoreStringFromMixedCase
{
    NSArray* words = [self componentsSeparatedByMixedCaps];
    NSString* result = [NSString stringWithLowercaseFromWords:words separator:@"_"];

    return result;
}

- (NSString*)mixedcaseStringFromMixedCaseWithInitialCapital
{
    NSArray* words = [self componentsSeparatedByMixedCaps];
    NSString* result = [NSString stringWithMixedCapsFromWords:words initialCap:NO];

    return result;
}

- (NSString*)mixedcaseStringInitialCapitalFromMixedCase
{
    NSArray* words = [self componentsSeparatedByMixedCaps];
    NSString* result = [NSString stringWithMixedCapsFromWords:words initialCap:YES];

    return result;
}

- (NSString*)mixedcaseStringInitialCapitalFromWords
{
    NSArray* words = [self componentsSeparatedByString:@" "];
    NSString* result = [NSString stringWithMixedCapsFromWords:words initialCap:YES];

    return result;
}

- (NSString*)mixedcaseStringFromWords
{
    NSArray* words = [self componentsSeparatedByString:@" "];
    NSString* result = [NSString stringWithMixedCapsFromWords:words initialCap:NO];

    return result;
}

- (NSString*)lowercaseUnderscoreStringFromWords
{
    NSArray* words = [self componentsSeparatedByString:@" "];
    NSString* result = [NSString stringWithLowercaseFromWords:words separator:@"_"];

    return result;
}

- (NSString*)uppercaseUnderscoreStringFromWords
{
    NSArray* words = [self componentsSeparatedByString:@" "];
    NSString* result = [NSString stringWithUppercaseFromWords:words separator:@"_"];

    return result;
}

@end
