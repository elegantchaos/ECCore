// --------------------------------------------------------------------------
//  Copyright 2013 Sam Deane, Elegant Chaos. All rights reserved.
//  This source code is distributed under the terms of Elegant Chaos's
//  liberal license: http://www.elegantchaos.com/license/liberal
// --------------------------------------------------------------------------

#import <Foundation/Foundation.h>

@interface ECCoercion : NSObject

+ (Class)asClass:(id)classOrClassName;
+ (NSString*)asClassName:(id)classOrClassName;
+ (NSArray*)asArray:(id)arrayOrObject;

+ (NSDictionary*)loadDictionary:(id)dictionaryOrPlistName;
+ (NSArray*)loadArray:(id)arrayOrPlistName;

@end
