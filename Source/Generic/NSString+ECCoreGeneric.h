// --------------------------------------------------------------------------
//
//  Created by Sam Deane on 11/08/2010.
//  Copyright 2014 Sam Deane, Elegant Chaos. All rights reserved.
//  This source code is distributed under the terms of Elegant Chaos's 
//  liberal license: http://www.elegantchaos.com/license/liberal
// --------------------------------------------------------------------------

@interface NSString(ECCoreGeneric)

+ (NSDictionary*)entities;

- (BOOL)containsString:(NSString*)string;
- (BOOL)beginsWithString:(NSString*)string;
- (BOOL)endsWithString:(NSString*)string;

- (NSData*)splitWordsIntoInts;
- (NSData*)splitWordsIntoFloats;
- (NSData*)splitWordsIntoDoubles;

+ (NSString*)stringByFormattingCount:(NSUInteger)count singularFormat:(NSString*)singularFormat pluralFormat:(NSString*)pluralFormat;
+ (NSString*)stringWithMixedCapsFromWords:(NSArray*)words initialCap:(BOOL)initialCap;
+ (NSString*)stringWithUppercaseFromWords:(NSArray*)words separator:(NSString*)separator;
+ (NSString*)stringWithLowercaseFromWords:(NSArray*)words separator:(NSString*)separator;
+ (NSString*)stringWithNewUUID;

+ (NSString*)stringWithOrdinal:(NSInteger)ordinal;

- (NSString*)truncateToLength:(NSUInteger)length;

- (NSString*)stringWithInitialCapital;
- (NSString*)uppercaseUnderscoreStringFromMixedCase;
- (NSString*)lowercaseUnderscoreStringFromMixedCase;
- (NSString*)mixedcaseStringFromMixedCaseWithInitialCapital;
- (NSString*)mixedcaseStringInitialCapitalFromMixedCase;
- (NSString*)mixedcaseStringInitialCapitalFromWords;
- (NSString*)mixedcaseStringFromWords;
- (NSString*)lowercaseUnderscoreStringFromWords;
- (NSString*)uppercaseUnderscoreStringFromWords;

@end
