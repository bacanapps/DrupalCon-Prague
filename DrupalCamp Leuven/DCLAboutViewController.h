//
//  DCLAboutViewController.h
//  DrupalCamp Leuven
//
//  Created by Tim Leytens on 20/07/13.
//  Copyright (c) 2013 Tim Leytens. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DCLUIViewController.h"
#import "IFTweetLabel.h"

@interface DCLAboutViewController : DCLUIViewController

@property (strong, nonatomic) IBOutlet UILabel *infoLabel;
@property (strong, nonatomic) IBOutlet UILabel *proudly;
@property (strong, nonatomic) IBOutlet UIView *seperator;
@property (strong, nonatomic) IBOutlet UIView *seperator2;
@property (strong, nonatomic) IFTweetLabel *namesLabel;
@property (strong, nonatomic) IFTweetLabel *codeLabel;
@property (strong, nonatomic) IBOutlet UILabel *bronCode;

@end
