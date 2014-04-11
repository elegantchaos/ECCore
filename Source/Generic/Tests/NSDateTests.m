// --------------------------------------------------------------------------
//
//! @file:
//! Unit tests for the NSDate+ECUtilitiesTests.h category.
//
//  Copyright 2014 Sam Deane, Elegant Chaos. All rights reserved.
//  This source code is distributed under the terms of Elegant Chaos's
//  liberal license: http://www.elegantchaos.com/license/liberal
// --------------------------------------------------------------------------

#import <ECUnitTests/ECUnitTests.h>
#import <ECCore/ECCore.h>


@interface NSDateFormattingTests : ECTestCase

@property (strong, nonatomic) NSDateFormatter*	formatter;
@property (strong, nonatomic) NSDate*				origin;
@property (strong, nonatomic) NSDate*				thirtySecondsLater;
@property (strong, nonatomic) NSDate*				fiveMinutesLater;
@property (strong, nonatomic) NSDate*				sevenHoursLater;
@property (strong, nonatomic) NSDate*				twentyThreeHoursLater;
@property (strong, nonatomic) NSDate*				threeDaysLater;

@end

@implementation NSDateFormattingTests

- (void) setUp
{
	self.formatter = [[NSDateFormatter alloc] init];
	[self.formatter setDateFormat:@"dd/MM/yyyy HH.mm.ss"];

	self.origin					= [self.formatter dateFromString: @"12/11/1969 12.00.00"];
	self.thirtySecondsLater		= [self.formatter dateFromString: @"12/11/1969 12.00.30"];
	self.fiveMinutesLater		= [self.formatter dateFromString: @"12/11/1969 12.05.30"];
	self.sevenHoursLater		= [self.formatter dateFromString: @"12/11/1969 19.10.45"];
	self.twentyThreeHoursLater	= [self.formatter dateFromString: @"13/11/1969 11.59.30"];
	self.threeDaysLater			= [self.formatter dateFromString: @"15/11/1969 12.05.00"];

}

- (void) testFormattedRelative
{
	NSString* formatted = [self.origin formattedRelativeTo: self.thirtySecondsLater];
	ECTestAssertStringIsEqual(formatted, @"Less than a minute ago");

	formatted = [self.origin formattedRelativeTo: self.fiveMinutesLater];
	ECTestAssertStringIsEqual(formatted, @"5 minutes ago");

	formatted = [self.origin formattedRelativeTo: self.sevenHoursLater];
	ECTestAssertStringIsEqual(formatted, @"7 hours ago");

	formatted = [self.origin formattedRelativeTo: self.twentyThreeHoursLater];
	ECTestAssertNil(formatted);
}

- (void) testFormattedRelativeWithDay
{
	NSString* formatted = [self.origin formattedRelativeWithDayTo: self.thirtySecondsLater];
	ECTestAssertStringIsEqual(formatted, @"Less than a minute ago");

	formatted = [self.origin formattedRelativeWithDayTo: self.fiveMinutesLater];
	ECTestAssertStringIsEqual(formatted, @"5 minutes ago");

	formatted = [self.origin formattedRelativeWithDayTo: self.sevenHoursLater];
	ECTestAssertStringIsEqual(formatted, @"7 hours ago");

	formatted = [self.origin formattedRelativeWithDayTo: self.twentyThreeHoursLater];
	ECTestAssertStringIsEqual(formatted, @"Yesterday");

	formatted = [self.origin formattedRelativeWithDayTo: [self.formatter dateFromString: @"12/11/1969 23.59.45"]];
	ECTestAssertStringIsEqual(formatted, @"Today");

	formatted = [self.origin formattedRelativeWithDayTo: self.twentyThreeHoursLater];
	ECTestAssertStringIsEqual(formatted, @"Yesterday");

	formatted = [self.origin formattedRelativeWithDayTo: self.threeDaysLater];
	ECTestAssertStringIsEqual(formatted, @"3 days ago");

	formatted = [self.origin formattedRelativeWithDayTo: [self.formatter dateFromString: @"12/01/1970 23.59.45"]];
	ECTestAssertStringIsEqual(formatted, @"November 12");

	formatted = [self.origin formattedRelativeWithDayTo: [self.formatter dateFromString: @"12/01/1971 23.59.45"]];
	ECTestAssertStringIsEqual(formatted, @"1969");

}

- (void) testDayEdgeCases
{
	NSString* formatted = [self.origin formattedRelativeWithDayTo: [self.formatter dateFromString: @"12/11/1969 23.59.59"]];
	ECTestAssertStringIsEqual(formatted, @"Today");

	formatted = [self.origin formattedRelativeWithDayTo: [self.formatter dateFromString: @"13/11/1969 00.00.00"]];
	ECTestAssertStringIsEqual(formatted, @"Yesterday");

	formatted = [self.origin formattedRelativeWithDayTo: [self.formatter dateFromString: @"13/11/1969 23.59.59"]];
	ECTestAssertStringIsEqual(formatted, @"Yesterday");

	formatted = [self.origin formattedRelativeWithDayTo: [self.formatter dateFromString: @"14/11/1969 00.00.00"]];
	ECTestAssertStringIsEqual(formatted, @"2 days ago");
}
@end


@interface NSDateTests : ECTestCase

@end

@implementation NSDateTests

static const NSTimeInterval kDayInterval = 60 * 60 * 24;
- (void)testDays
{
	NSDate* now = [NSDate date];
	NSDate* tomorrow = [now dateByAddingTimeInterval:kDayInterval];
	NSDate* yesterday = [now dateByAddingTimeInterval:-kDayInterval];

	ECTestAssertTrue([now isEarlierDayThan:tomorrow]);
	ECTestAssertTrue([now isLaterDayThan:yesterday]);
	ECTestAssertTrue([now isSameDayAs:now]);
	ECTestAssertTrue([now isToday]);
	ECTestAssertFalse([yesterday isToday]);
	ECTestAssertFalse([tomorrow isToday]);

	ECTestAssertTrue([now dayOffsetFrom:yesterday] == LaterDay);
	ECTestAssertTrue([now dayOffsetFrom:tomorrow] == EarlierDay);
	ECTestAssertTrue([now dayOffsetFrom:now] == SameDay);
}

- (void)testStartOfDay
{
	NSDate* now = [NSDate date];
	NSDate* tomorrow = [now dateByAddingTimeInterval:kDayInterval];

	NSDate* nowStart = [now startOfDay];
	NSDate* tomorrowStart = [tomorrow startOfDay];

	ECTestAssertTrue([tomorrowStart timeIntervalSinceDate:nowStart] == kDayInterval);
	ECTestAssertRealIsEqual([now timeIntervalSinceStartOfDay], [now timeIntervalSinceDate:nowStart]);
}

@end
