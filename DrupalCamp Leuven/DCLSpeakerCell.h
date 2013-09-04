//
//  DCLSpeakerCell.h
//  DrupalCamp
//
//  Created by Tim Leytens on 27/08/13.
//  Copyright (c) 2013 Tim Leytens. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DCLSpeakerCell : UITableViewCell

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *userName;
@property (nonatomic, strong) UILabel *speakerName;
@property (nonatomic, strong) UILabel *company;
@property (nonatomic, strong) UIImageView *avatar;

@end
