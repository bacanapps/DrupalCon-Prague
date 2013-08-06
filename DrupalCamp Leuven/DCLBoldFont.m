//
//  DCLBoldFont.m
//  DrupalCamp Leuven
//
//  Created by Tim Leytens on 24/07/13.
//  Copyright (c) 2013 Tim Leytens. All rights reserved.
//

#import "DCLBoldFont.h"

@implementation DCLBoldFont

+ (id)sharedInstance {
    static UIFont *__sharedInstance;

    if (__sharedInstance == nil) {
        __sharedInstance = [UIFont fontWithName:@"OpenSans-Bold" size:14.0];
    }

    return __sharedInstance;
}

@end
