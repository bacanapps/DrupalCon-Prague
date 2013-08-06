//
//  DCLRegularFont.m
//  DrupalCamp Leuven
//
//  Created by Tim Leytens on 24/07/13.
//  Copyright (c) 2013 Tim Leytens. All rights reserved.
//

#import "DCLRegularFont.h"

@implementation DCLRegularFont

+ (id)sharedInstance {
    static UIFont *__sharedInstance;

    if (__sharedInstance == nil) {
        __sharedInstance = [UIFont fontWithName:@"OpenSans" size:13.0];
    }

    return __sharedInstance;
}

@end
