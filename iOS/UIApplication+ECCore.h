// --------------------------------------------------------------------------
//! @author Sam Deane
//! @date 12/04/2011
//
//  Copyright 2012 Sam Deane, Elegant Chaos. All rights reserved.
//  This source code is distributed under the terms of Elegant Chaos's 
//  liberal license: http://www.elegantchaos.com/license/liberal
// --------------------------------------------------------------------------

@interface UIApplication(ECCore)

- (NSString*)aboutName;
- (NSString*)aboutCopyright;
- (NSString*)aboutVersion;
- (NSString*) aboutShortVersion;

+ (BOOL)isIOS5OrLater;

@end
