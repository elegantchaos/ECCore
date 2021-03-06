// --------------------------------------------------------------------------
//
//! @file:
//! Unit tests for the NSDate+ECUtilitiesTests.h category.
//
//  Copyright 2013 Sam Deane, Elegant Chaos. All rights reserved.
//  This source code is distributed under the terms of Elegant Chaos's 
//  liberal license: http://www.elegantchaos.com/license/liberal
// --------------------------------------------------------------------------

#import <ECUnitTests/ECUnitTests.h>
#import <ECCore/ECCore.h>


@interface NSDateFormattingTests : ECTestCase
{
	NSDateFormatter*	mFormatter;
	NSDate*				mOrigin;
	NSDate*				mThirtySecondsLater;
	NSDate*				mFiveMinutesLater;
	NSDate*				mSevenHoursLater;
	NSDate*				mTwentyThreeHoursLater;
	NSDate*				mThreeDaysLater;
}

@end

@implementation NSDateFormattingTests

- (void) setUp
{
	mFormatter = [[NSDateFormatter alloc] init];
	[mFormatter setDateFormat:@"dd/MM/yyyy HH.mm.ss"];
	
	mOrigin					= [[mFormatter dateFromString: @"12/11/1969 12.00.00"] retain];
	mThirtySecondsLater		= [[mFormatter dateFromString: @"12/11/1969 12.00.30"] retain]; 
	mFiveMinutesLater		= [[mFormatter dateFromString: @"12/11/1969 12.05.30"] retain]; 
	mSevenHoursLater		= [[mFormatter dateFromString: @"12/11/1969 19.10.45"] retain];
	mTwentyThreeHoursLater	= [[mFormatter dateFromString: @"13/11/1969 11.59.30"] retain];
	mThreeDaysLater			= [[mFormatter dateFromString: @"15/11/1969 12.05.00"] retain];

}

- (void) tearDown
{
	[mFormatter release];
	[mOrigin release];
	[mThirtySecondsLater release];	
	[mFiveMinutesLater release];
	[mSevenHoursLater release];
	[mTwentyThreeHoursLater release];
	[mThreeDaysLater release];
}

- (void) testFormattedRelative
{
	NSString* formatted = [mOrigin formattedRelativeTo: mThirtySecondsLater];
	ECTestAssertStringIsEqual(formatted, @"Less than a minute ago");

	formatted = [mOrigin formattedRelativeTo: mFiveMinutesLater];
	ECTestAssertStringIsEqual(formatted, @"5 minutes ago");

	formatted = [mOrigin formattedRelativeTo: mSevenHoursLater];
	ECTestAssertStringIsEqual(formatted, @"7 hours ago");

	formatted = [mOrigin formattedRelativeTo: mTwentyThreeHoursLater];
	ECTestAssertNil(formatted);
}

- (void) testFormattedRelativeWithDay
{
	NSString* formatted = [mOrigin formattedRelativeWithDayTo: mThirtySecondsLater];
	ECTestAssertStringIsEqual(formatted, @"Less than a minute ago");
	
	formatted = [mOrigin formattedRelativeWithDayTo: mFiveMinutesLater];
	ECTestAssertStringIsEqual(formatted, @"5 minutes ago");
	
	formatted = [mOrigin formattedRelativeWithDayTo: mSevenHoursLater];
	ECTestAssertStringIsEqual(formatted, @"7 hours ago");

	formatted = [mOrigin formattedRelativeWithDayTo: mTwentyThreeHoursLater];
	ECTestAssertStringIsEqual(formatted, @"Yesterday");

	formatted = [mOrigin formattedRelativeWithDayTo: [mFormatter dateFromString: @"12/11/1969 23.59.45"]];
	ECTestAssertStringIsEqual(formatted, @"Today");

	formatted = [mOrigin formattedRelativeWithDayTo: mTwentyThreeHoursLater];
	ECTestAssertStringIsEqual(formatted, @"Yesterday");

	formatted = [mOrigin formattedRelativeWithDayTo: mThreeDaysLater];
	ECTestAssertStringIsEqual(formatted, @"3 days ago");

	formatted = [mOrigin formattedRelativeWithDayTo: [mFormatter dateFromString: @"12/01/1970 23.59.45"]];
	ECTestAssertStringIsEqual(formatted, @"November 12");

	formatted = [mOrigin formattedRelativeWithDayTo: [mFormatter dateFromString: @"12/01/1971 23.59.45"]];
	ECTestAssertStringIsEqual(formatted, @"1969");

}

- (void) testDayEdgeCases
{
	NSString* formatted = [mOrigin formattedRelativeWithDayTo: [mFormatter dateFromString: @"12/11/1969 23.59.59"]];
	ECTestAssertStringIsEqual(formatted, @"Today");

	formatted = [mOrigin formattedRelativeWithDayTo: [mFormatter dateFromString: @"13/11/1969 00.00.00"]];
	ECTestAssertStringIsEqual(formatted, @"Yesterday");

	formatted = [mOrigin formattedRelativeWithDayTo: [mFormatter dateFromString: @"13/11/1969 23.59.59"]];
	ECTestAssertStringIsEqual(formatted, @"Yesterday");

	formatted = [mOrigin formattedRelativeWithDayTo: [mFormatter dateFromString: @"14/11/1969 00.00.00"]];
	ECTestAssertStringIsEqual(formatted, @"2 days ago");
}
@end


@interface NSDateTests : ECTestCase
{
	NSDateFormatter*	mFormatter;
	NSDate*				mOrigin;
	NSDate*				mThirtySecondsLater;
	NSDate*				mFiveMinutesLater;
	NSDate*				mSevenHoursLater;
	NSDate*				mTwentyThreeHoursLater;
	NSDate*				mThreeDaysLater;
}

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
