//
//  NSDictionary+ObjectForKeyOrNil.m
//  Gentse Feesten 2013
//
//  Created by Tim Leytens on 1/06/13.
//  Copyright (c) 2013 Tim Leytens. All rights reserved.
//

#import "NSDictionary+ObjectForKeyOrNil.h"

@implementation NSDictionary (ObjectForKeyOrNil)

- (id)objectForKeyOrNil:(id)key {
    id val = [self objectForKey:key];
    if ([val isEqual:[NSNull null]]) {
        return nil;
    }

    return val;
}

@end
