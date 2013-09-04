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
    [self setBackgroundImage:[UIImage imageNamed:@"navBackground.png"] forBarMetrics:UIBarMetricsDefault];
    [self setShadowImage:[[UIImage alloc] init]];

    [self setTitleTextAttributes: @{
                                UITextAttributeTextColor: UIColorFromRGB(0x444444),
                          UITextAttributeTextShadowColor: [UIColor clearColor],
                         UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0.0f, 0.0f)],
                                     UITextAttributeFont: [DCLLightFont sharedInstance]
    }];

}

@end
