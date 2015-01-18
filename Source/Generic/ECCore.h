// --------------------------------------------------------------------------
//  Copyright 2014 Sam Deane, Elegant Chaos. All rights reserved.
//  This source code is distributed under the terms of Elegant Chaos's 
//  liberal license: http://www.elegantchaos.com/license/liberal
// --------------------------------------------------------------------------

#import <ECLogging/ECLogging.h>

#import "CGGeometry+ECCore.h"

#import "ECClang.h"
#import "ECCoercion.h"
#import "ECKVO.h"
#import "ECKVOManager.h"
#import "ECLazyProperties.h"
#import "ECProperties.h"
#import "ECRandom.h"
#import "ECRuntime.h"
#import "ECSha1.h"
#import "ECSingleton.h"

#import "NSArray+ECCore.h"
#import "NSBundle+ECCore.h"
#import "NSDate+ECCore.h"
#import "NSData+ECCore.h"
#import "NSDictionary+ECCore.h"
#import "NSException+ECCore.h"
#import "NSFileManager+ECCore.h"
#import "NSIndexSet+ECCore.h"
#import "NSMutableAttributedString+ECCore.h"
#import "NSString+ECCore.h"
#import "NSURL+ECCore.h"

#if TARGET_OS_IPHONE

#import "UIFont+ECCore.h"
#import "UIApplication+ECCore.h"
#import "UIColor+ECCore.h"
#import "UIFont+ECCore.h"
#import "UIImage+ECCore.h"
#import "UIViewController+ECUtilities.h"
#import "ECDownloadOperation.h"

#elif TARGET_OS_MAC

#import "ECLaunchServices.h"
#import "ECMachine.h"
#import "NSAppleScript+ECCore.h"
#import "NSAppleEventDescriptor+ECCore.h"
#import "NSGeometry+ECCore.h"
#import "NSURL+ECCoreMac.h"

#else

#warning Unknown platform

#endif