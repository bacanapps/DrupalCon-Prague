//
//  DCLAboutViewController.m
//  DrupalCamp Leuven
//
//  Created by Tim Leytens on 20/07/13.
//  Copyright (c) 2013 Tim Leytens. All rights reserved.
//

#import "DCLAboutViewController.h"
#import "DCLRegularFont.h"
#import "DCLBoldFont.h"

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface DCLAboutViewController ()

@end

@implementation DCLAboutViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {

        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil
                                                        image:nil
                                                          tag:0];

        [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"aboutButton.png"]
                      withFinishedUnselectedImage:[UIImage imageNamed:@"aboutButton.png"]];

        self.tabBarItem.imageInsets = UIEdgeInsetsMake(4, 0, -4, 0);

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTweetNotification:) name:IFTweetLabelURLNotification object:nil];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = @"ABOUT";
    _infoLabel.font = [DCLRegularFont sharedInstance];
    _infoLabel.textColor = UIColorFromRGB(0x4b4745);

    _infoLabel.frame = CGRectMake(20, 20, 280, [self getHeightForString:_infoLabel.text forWidth:280 withFont:[DCLRegularFont sharedInstance]]);

    _proudly.font = [DCLBoldFont sharedInstance];
    _proudly.textColor = UIColorFromRGB(0x4b4745);

    _proudly.frame = CGRectMake(20, _infoLabel.frame.size.height + _infoLabel.frame.origin.y + 20, 280, [self getHeightForString:_proudly.text forWidth:280 withFont:[DCLBoldFont sharedInstance]]);

    _namesLabel.font = [DCLRegularFont sharedInstance];
    _namesLabel.textColor = UIColorFromRGB(0x4b4745);

    _namesLabel = [[IFTweetLabel alloc] initWithFrame:CGRectMake(20, 135, 280, 60)];
    _namesLabel.backgroundColor = [UIColor clearColor];

    _namesLabel.text = @"@TimLeytens\n@Swentel\n@LeenVS";
    _namesLabel.font = [DCLRegularFont sharedInstance];
    _namesLabel.textColor = UIColorFromRGB(0x3a92c2);
    _namesLabel.numberOfLines = 0;

    _namesLabel.highlightColor = UIColorFromRGB(0x3a92c2);
    _namesLabel.normalColor = [UIColor clearColor];
    _namesLabel.highlightImage = [UIImage imageNamed:@"transparant.png"];
    _namesLabel.normalImage = [UIImage imageNamed:@"transparant.png"];

    _namesLabel.frame = CGRectMake(20, _proudly.frame.size.height + _proudly.frame.origin.y + 10, 280, [self getHeightForString:_namesLabel.text forWidth:280 withFont:[DCLRegularFont sharedInstance]]);

    [_namesLabel setLinksEnabled:YES];
   
    
    [self.view addSubview:_namesLabel];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleTweetNotification:(NSNotification *)notification
{
    if([[notification.object substringToIndex:1] isEqualToString:@"@"])
    {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter://"]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"twitter://user?screen_name=%@", [notification.object stringByReplacingOccurrencesOfString:@"@" withString:@""]]]];
        }
        else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://twitter.com/%@", [notification.object stringByReplacingOccurrencesOfString:@"@" withString:@""]]]];
        }

    }

    if([[notification.object substringToIndex:4] isEqualToString:@"http"])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:notification.object]];

    }
}

-(CGFloat)getHeightForString:(NSString *)string forWidth:(float)width withFont:(UIFont *)font {
    NSString *text = string;
    CGSize constraint = CGSizeMake(width, 20000.0f);
    CGSize size = [text sizeWithFont:font constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    return size.height;
}

@end
