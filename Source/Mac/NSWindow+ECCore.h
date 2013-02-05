// --------------------------------------------------------------------------
//! @date 02/04/2011
//
//! @file Additional methods for the NSWindow class.
//
//  Copyright 2013 Sam Deane, Elegant Chaos. All rights reserved.
//  This source code is distributed under the terms of Elegant Chaos's 
//  liberal license: http://www.elegantchaos.com/license/liberal
// --------------------------------------------------------------------------

#import <Foundation/Foundation.h>

@interface NSWindow(ECCore)

- (NSRect)frameCentredOnCurrentScreen;
- (NSRect)frameCentredOnMainScreen;

- (NSRect)centreOnCurrentScreen;
- (NSRect)centreOnMainScreen;

- (CGFloat)toolbarHeight;

@end
