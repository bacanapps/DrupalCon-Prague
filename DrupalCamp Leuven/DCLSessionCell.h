//
//  DCLSessionCell.h
//  DrupalCamp Leuven
//
//  Created by Tim Leytens on 21/07/13.
//  Copyright (c) 2013 Tim Leytens. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DCLSessionCell : UITableViewCell

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) UILabel *sessionTitle;
@property (nonatomic, strong) UILabel *speakerName;
@property (nonatomic, strong) UILabel *timeSlot;

@end
