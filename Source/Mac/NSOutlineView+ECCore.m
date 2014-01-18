//
//  NSOutlineView+ECCore.m
//  ECCore
//
//  Created by Sam Deane on 18/01/2014.
//  Copyright (c) 2014 Elegant Chaos. All rights reserved.
//

#import "NSOutlineView+ECCore.h"

@implementation NSOutlineView (ECCore)

static NSString *const ExpandedStateKey = @"-ExpandedState";

- (id)simpleExpandedState
{
	NSMutableArray *state = [NSMutableArray array];
	NSInteger count = [self numberOfRows];
	for (NSInteger row = 0; row < count; row++) {
		id item = [self itemAtRow:row];
		if ([self isItemExpanded:item])
			[state addObject:@(row)];
	}
	return state;
}

- (void)setSimpleExpandedState:(id)state
{
	if ([state isKindOfClass:[NSArray class]] == NO) return;
	[self collapseItem:nil collapseChildren:YES];
	for (NSNumber *expandedRow in state)
	{
		NSUInteger row = [expandedRow unsignedIntegerValue];
		id item = [self itemAtRow:row];
		[self expandItem:item];
	}
}

- (void)saveSimpleExpandedState
{
	NSString* expandedStateKey = [self.autosaveName stringByAppendingString:ExpandedStateKey];
	if (expandedStateKey)
	{
		id expandedState = [self simpleExpandedState];
		NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
		[defaults setObject:expandedState forKey:expandedStateKey];
		[defaults synchronize];
	}
}

- (void)restoreSimpleExpandedState
{
	NSString* expandedStateKey = [self.autosaveName stringByAppendingString:ExpandedStateKey];
	if (expandedStateKey)
	{
		id expandedState = [[NSUserDefaults standardUserDefaults] objectForKey:expandedStateKey];
		if (expandedState)
			[self setSimpleExpandedState:expandedState];
	}
}

@end
