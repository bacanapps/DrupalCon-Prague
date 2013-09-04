//
//  DCLSpeakerViewController.h
//  DrupalCamp
//
//  Created by Tim Leytens on 3/09/13.
//  Copyright (c) 2013 Tim Leytens. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCLUIViewController.h"
#import "Speaker.h"
@interface DCLSpeakerViewController : DCLUIViewController

@property(nonatomic, strong) Speaker *speaker;

@property (nonatomic) BOOL calledFromSessionViewController;

@end
