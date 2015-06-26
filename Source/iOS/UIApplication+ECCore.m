// --------------------------------------------------------------------------
//
//  Copyright 2014 Sam Deane, Elegant Chaos. All rights reserved.
//  This source code is distributed under the terms of Elegant Chaos's 
//  liberal license: http://www.elegantchaos.com/license/liberal
// --------------------------------------------------------------------------

#import "UIApplication+ECCore.h"


@implementation UIApplication(ECCore)

// --------------------------------------------------------------------------
//! Return the name of the application, in a format appropriate for display in an about box.
// --------------------------------------------------------------------------

- (NSString*) aboutName
{
	NSBundle* bundle = [NSBundle mainBundle];
	NSDictionary* info = [bundle infoDictionary];
	NSString* result = [info objectForKey: @"CFBundleDisplayName"];
	
	return result;
}

// --------------------------------------------------------------------------
//! Return the copyright string of the application, in a format appropriate for display in an about box.
// --------------------------------------------------------------------------

- (NSString*) aboutCopyright
{
	NSBundle* bundle = [NSBundle mainBundle];
	NSDictionary* info = [bundle infoDictionary];
	NSString* result = [info objectForKey: @"NSHumanReadableCopyright"];

	return result;
}

// --------------------------------------------------------------------------
//! Return the version of the application, in a format appropriate for display in an about box.
// --------------------------------------------------------------------------

- (NSString*) aboutVersion
{
	NSString* date = nil;
	NSFileManager* fm = [NSFileManager defaultManager];
	NSBundle* bundle = [NSBundle mainBundle];
	NSDictionary* info = [bundle infoDictionary];
	NSDictionary* attrs = [fm attributesOfItemAtPath:[bundle executablePath] error:nil];
	if (attrs != nil) 
	{
		NSDate* modified = [attrs objectForKey: NSFileModificationDate];
		NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
		[formatter setDateStyle:NSDateFormatterShortStyle];
		[formatter setTimeStyle:NSDateFormatterShortStyle];
		date = [formatter stringFromDate: modified];
	}

	NSString* result = [NSString stringWithFormat: @"Version %@ (%@%@, %@)", [info objectForKey:@"CFBundleShortVersionString"], EC_CONFIGURATION_STRING_SHORT, [info objectForKey:@"CFBundleVersion"], date];
	
	return result;
}

// --------------------------------------------------------------------------
//! Return the short version of the application, in a format appropriate for display in an small label.
// --------------------------------------------------------------------------

- (NSString*) aboutShortVersion
{
	NSBundle* bundle = [NSBundle mainBundle];
	NSDictionary* info = [bundle infoDictionary];
	
	NSString* result = [NSString stringWithFormat: @"%@ (%@%@)", [info objectForKey:@"CFBundleShortVersionString"], EC_CONFIGURATION_STRING_SHORT, [info objectForKey:@"CFBundleVersion"]];
	
	return result;
}

// --------------------------------------------------------------------------
//! Are we running on iOS 5?
// --------------------------------------------------------------------------

+(BOOL)isIOS5OrLater
{
    return [UIAlertView instancesRespondToSelector:@selector(alertViewStyle)];
}

+ (BOOL)isIOS8OrLater
{
	return [NSString instancesRespondToSelector:@selector(localizedCaseInsensitiveContainsString:)];
}

static NSUInteger gNetworkOperationCount;

- (void)networkOperationStarted
{
	@synchronized(self)
	{
		++gNetworkOperationCount;
		self.networkActivityIndicatorVisible = YES;
	}
}

- (void)networkOperationEnded
{
	@synchronized(self)
	{
		if (--gNetworkOperationCount == 0)
		{
			self.networkActivityIndicatorVisible = NO;
		}
	}
}


@end
