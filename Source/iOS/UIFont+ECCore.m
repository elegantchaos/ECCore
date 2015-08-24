// --------------------------------------------------------------------------
//
//  Copyright 2014 Sam Deane, Elegant Chaos. All rights reserved.
//  This source code is distributed under the terms of Elegant Chaos's 
//  liberal license: http://www.elegantchaos.com/license/liberal
// --------------------------------------------------------------------------

#import "UIFont+ECCore.h"

@implementation UIFont(ECCore)


ECDefineDebugChannel(FontChannel);

NSString *const ECFontNameKey = @"name";
NSString *const ECFontSizeKey = @"size";

+ (UIFont*)fontFromDictionary:(NSDictionary*)dictionary
{
    NSString* name = [dictionary objectForKey:ECFontNameKey];
    CGFloat size = [[dictionary objectForKey:ECFontSizeKey] floatValue];
    if (size != 0)
    {
        size = [UIFont labelFontSize];
    }
    
    UIFont* font;
    if (!name)
    {
        font = [UIFont systemFontOfSize:size];
    }
    else 
    {
        font = [UIFont fontWithName:name size:size];
    }
    
    return font;
}

- (UIFont*)fontFromDictionary:(NSDictionary*)dictionary
{
    NSString* name = [dictionary objectForKey:ECFontNameKey];
    CGFloat size = [[dictionary objectForKey:ECFontSizeKey] floatValue];
    if (size != 0)
    {
        size = self.pointSize;
    }
    if (size != 0)
    {
        size = [UIFont labelFontSize];
    }
    
    UIFont* font;
    if (!name)
    {
        font = [self fontWithSize:size];
    }
    else 
    {
        font = [UIFont fontWithName:name size:size];
    }
    
    return font;
}

- (NSDictionary*)asDictionary
{
	NSDictionary* result = [NSDictionary dictionaryWithObjectsAndKeys:
							self.fontName, ECFontNameKey, @(self.pointSize), ECFontSizeKey,
							nil];
	
	return result;
}

- (UIFont*)boldVariant
{
    UIFont* result = self;
    NSArray* styles = [UIFont fontNamesForFamilyName:self.familyName];
    
    ECDebug(FontChannel, @"available styles for %@: %@", self, styles);
    
    for (NSString* name in styles)
    {
        if ([name rangeOfString:@"bold" options:NSCaseInsensitiveSearch].location != NSNotFound)
        {
            if (([name rangeOfString:@"italic" options:NSCaseInsensitiveSearch].location == NSNotFound)
                && ([name rangeOfString:@"oblique" options:NSCaseInsensitiveSearch].location == NSNotFound))
            {
                result = [UIFont fontWithName:name size:self.pointSize];
                break;
            }
        }
    }

    return result;
}

- (UIFont*)italicVariant
{
    UIFont* result = self;
    NSArray* styles = [UIFont fontNamesForFamilyName:self.familyName];
    
    ECDebug(FontChannel, @"available styles for %@: %@", self, styles);
    
    for (NSString* name in styles)
    {
        if (([name rangeOfString:@"italic" options:NSCaseInsensitiveSearch].location != NSNotFound) || ([name rangeOfString:@"oblique" options:NSCaseInsensitiveSearch].location != NSNotFound))
        {
            if ([name rangeOfString:@"bold" options:NSCaseInsensitiveSearch].location == NSNotFound)
            {
                result = [UIFont fontWithName:name size:self.pointSize];
                break;
            }
        }
    }
	
    return result;
}

@end
