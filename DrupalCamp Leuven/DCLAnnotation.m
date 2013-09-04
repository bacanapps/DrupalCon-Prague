//
//  DCLAnnotation.m
//  DrupalCamp
//
//  Created by Tim Leytens on 30/08/13.
//  Copyright (c) 2013 Tim Leytens. All rights reserved.
//

#import "DCLAnnotation.h"

@implementation DCLAnnotation

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}


- (CLLocationCoordinate2D)coordinate {
    return CLLocationCoordinate2DMake(_lat, _lon);
}

@end
