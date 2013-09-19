//
//  DCLNavigationBar.m
//  DrupalCamp Leuven
//
//  Created by Tim Leytens on 20/07/13.
//  Copyright (c) 2013 Tim Leytens. All rights reserved.
//

#import "DCLNavigationBar.h"

#import "DCLLightFont.h"

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@implementation DCLNavigationBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self customize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self customize];
    }
    return self;
}


-(void)customize
{

    [self setBackgroundColor:[UIColor whiteColor]];
    [self setBackgroundImage:[UIImage imageNamed:@"navbar.png"] forBarMetrics:UIBarMetricsDefault];

    [self setTitleTextAttributes: @{
                                UITextAttributeTextColor: UIColorFromRGB(0xFFFFFF),
                          UITextAttributeTextShadowColor: [UIColor darkGrayColor],
                         UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(1.0f, 1.0f)],
                                     UITextAttributeFont: [UIFont fontWithName:@"PT Sans Narrow" size:22.0]
    }];

}

@end
