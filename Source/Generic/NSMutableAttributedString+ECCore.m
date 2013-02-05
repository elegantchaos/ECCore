// --------------------------------------------------------------------------
//
//  Copyright 2013 Sam Deane, Elegant Chaos. All rights reserved.
//  This source code is distributed under the terms of Elegant Chaos's 
//  liberal license: http://www.elegantchaos.com/license/liberal
// --------------------------------------------------------------------------

#import "NSMutableAttributedString+ECCore.h"
#import "NSData+ECCore.h"
#import "NSString+ECCore.h"

@implementation NSMutableAttributedString(ECCore)

- (void)escapeEntities
{
	NSDictionary* entities = [NSString entities];
	for (NSString* entity in entities)
	{
		NSString* character = [entities objectForKey:entity];
		NSRange range;
		while ((range = [[self string] rangeOfString:character]).location != NSNotFound)
		{
			[self replaceCharactersInRange:range withString:entity];
		}
	}
}

- (void)unescapeEntities
{
	NSDictionary* entities = [NSString entities];
	for (NSString* entity in entities)
	{
		NSString* character = [entities objectForKey:entity];
		NSRange range;
		while ((range = [[self string] rangeOfString:entity]).location != NSNotFound)
		{
			[self replaceCharactersInRange:range withString:character];
		}
	}
}

- (void)matchExpression:(NSRegularExpression*)expression options:(NSRegularExpressionOptions)options reversed:(BOOL)reversed action:(MatchAction)block
{
    NSAttributedString* original = [self copy];
    
    NSRange range = NSMakeRange(0, [self length]);
    NSArray* matches = [expression matchesInString:[self string] options:options range:range];
    NSUInteger count = [matches count];
    if (reversed)
    {
        while (count--)
        {
            block(original, self, [matches objectAtIndex:count]);
        }
    }
    else
    {
		NSUInteger n = 0;
        for (NSTextCheckingResult* match in matches)
        {
            block(original, self, [matches objectAtIndex:n++]);
        }
    }
    
    [original release];
}

- (void)replaceExpression:(NSRegularExpression*)expression options:(NSRegularExpressionOptions)options atIndex:(NSUInteger)atIndex withIndex:(NSUInteger)withIndex attributes:(NSDictionary *)attributes
{
	[self matchExpression:expression options:options reversed:YES action:
     ^(NSAttributedString* original, NSMutableAttributedString* current, NSTextCheckingResult* match)
     {
		 [current replaceMatch:match atIndex:atIndex withIndex:withIndex attributes:attributes];
     }
     ];

}

- (void)replaceMatch:(NSTextCheckingResult*)match atIndex:(NSUInteger)atIndex withIndex:(NSUInteger)withIndex attributes:(NSDictionary*)attributes
{
    NSMutableDictionary* attributesCopy = [NSMutableDictionary dictionaryWithDictionary:attributes];
    for (NSString* key in attributes)
    {
        id value = [attributes objectForKey:key];
        if ([value isKindOfClass:[NSString class]])
        {
            NSString* string = value;
            if (([string length] > 0) && [string characterAtIndex:0] == '^')
            {
                NSUInteger matchNo = [[string substringFromIndex:1] intValue];
                NSRange matchRange = [match rangeAtIndex:matchNo];
                NSString* matchValue = [[self string] substringWithRange:matchRange];
                [attributesCopy setObject:matchValue forKey:key];
            }
        }
    }

	NSRange whole = [match rangeAtIndex:atIndex];
	NSRange range = [match rangeAtIndex:withIndex];
	NSMutableAttributedString* boldText = [[self attributedSubstringFromRange:range] mutableCopy];
	[boldText addAttributes:attributesCopy range:NSMakeRange(0, [boldText length])];
	[self replaceCharactersInRange:whole withAttributedString:boldText];
	[boldText release];
}

@end
