// --------------------------------------------------------------------------
//
//  Created by Sam Deane on 11/08/2010.
//  Copyright 2013 Sam Deane, Elegant Chaos. All rights reserved.
//  This source code is distributed under the terms of Elegant Chaos's 
//  liberal license: http://www.elegantchaos.com/license/liberal
// --------------------------------------------------------------------------

#import "NSString+ECCoreGeneric.h"

@interface NSString(ECCore)

- (NSString*)stringByEscapingEntities;
- (NSString*)stringByUnescapingEntities;

@end
