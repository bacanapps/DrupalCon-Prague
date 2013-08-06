//
//  DCLLightFont.m
//  DrupalCamp Leuven
//
//  Created by Tim Leytens on 23/07/13.
//  Copyright (c) 2013 Tim Leytens. All rights reserved.
//

#import "DCLLightFont.h"

@implementation DCLLightFont

+ (id)sharedInstance {
    static UIFont *__sharedInstance;

    if (__sharedInstance == nil) {
        __sharedInstance = [UIFont fontWithName:@"OpenSans-Light" size:19.0];
    }

    return __sharedInstance;
}

@end
