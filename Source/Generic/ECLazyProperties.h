// --------------------------------------------------------------------------
//
//  Copyright 2013 Sam Deane, Elegant Chaos. All rights reserved.
//  This source code is distributed under the terms of Elegant Chaos's 
//  liberal license: http://www.elegantchaos.com/license/liberal
// --------------------------------------------------------------------------

#import <Foundation/Foundation.h>

#define ECLazyGetter(property, initialisation) \
	- (id)property { if (!_##property) _##property = (initialisation); return _##property; }

//#define ECLazyGetter(property, initialisation) - (typeof(_##property))property { if (!_##property) _property = (initialisation); return _##property; }


@interface NSObject(ECLazyProperties)

+ (void)initializeLazyProperties;

#define lazy_synthesize(name,init) \
synthesize name; \
- (id)name##Init__ \
{ \
id value = [self name##Init__]; \
if (!value) \
{ \
    value = (init); \
    [self setValue:value forKey:@#name]; \
} \
return value; \
}

#define lazy_synthesize_method(name,method) lazy_synthesize(name,[self method])

@end

