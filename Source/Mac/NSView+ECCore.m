//
//  NSView+ECCore.m
//  ECCore
//
//  Created by Sam Deane on 17/01/2014.
//  Copyright (c) 2014 Elegant Chaos. All rights reserved.
//

#import "NSView+ECCore.h"

@implementation NSView (ECCore)

- (NSView*)firstViewWithIdentifier:(NSString*)identifier
{
	NSView* result;
	if ([self.identifier isEqualTo:identifier])
	{
		result = self;
	}
	else
	{
		result = nil;
		for (NSView* view in self.subviews)
		{
			result = [view firstViewWithIdentifier:identifier];
			if (result)
				break;
		}
	}
	
	return result;
}

@end
