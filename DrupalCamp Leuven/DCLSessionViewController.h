//
//  DCLSessionViewController.h
//  DrupalCamp
//
//  Created by Tim Leytens on 15/08/13.
//  Copyright (c) 2013 Tim Leytens. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DCLUIViewController.h"
#import "Session.h"

@interface DCLSessionViewController : DCLUIViewController

@property(nonatomic, strong) Session *session;

@property (nonatomic, strong) NSManagedObjectContext *moc;

@property (nonatomic) BOOL calledFromSpeakerViewController;

@property (nonatomic) BOOL calledInModalViewController;

-(CGFloat)getHeightForString:(NSString *)string forWidth:(float)width withFont:(UIFont *)font;

@end
