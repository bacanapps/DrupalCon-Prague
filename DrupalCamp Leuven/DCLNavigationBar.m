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

- (void)drawRect:(CGRect)rect {
    UIColor *color = UIColorFromRGB(0xFFFFFF);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColor(context, CGColorGetComponents([color CGColor]));
    CGContextFillRect(context, rect);
}


-(void)customize
{

    [self setTitleTextAttributes: @{
                                UITextAttributeTextColor: UIColorFromRGB(0x444444),
                          UITextAttributeTextShadowColor: [UIColor clearColor],
                         UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0.0f, 0.0f)],
                                     UITextAttributeFont: [DCLLightFont sharedInstance]
    }];

    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 1)];
    backgroundView.backgroundColor = UIColorFromRGB(0xdcdcdc);
    [self insertSubview:backgroundView atIndex:0];

}

@end
