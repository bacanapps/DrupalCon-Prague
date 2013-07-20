//
//  DCLTabBar.m
//  DrupalCamp Leuven
//
//  Created by Tim Leytens on 20/07/13.
//  Copyright (c) 2013 Tim Leytens. All rights reserved.
//

#import "DCLTabBar.h"

@implementation DCLTabBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self customize];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self customize];
    }
    return self;
}

- (void)customize {
    UIImage *tabbarBg = [UIImage imageNamed:@"tabbar-background.png"];
    //UIImage *tabBarSelected = [UIImage imageNamed:@"tabbar-background-pressed.png"];
    [self setBackgroundImage:tabbarBg];
    //[self setSelectionIndicatorImage:tabBarSelected];
    [self setShadowImage:[UIImage imageNamed:@"transparant.png"]];
}

/*
- (void)drawRect:(CGRect)rect {
    UIColor *color = [UIColor whiteColor];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColor(context, CGColorGetComponents( [color CGColor]));
    CGContextFillRect(context, rect);
}
*/
@end
