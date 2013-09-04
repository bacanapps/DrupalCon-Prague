//
//  DCLSpeakerCell.m
//  DrupalCamp
//
//  Created by Tim Leytens on 27/08/13.
//  Copyright (c) 2013 Tim Leytens. All rights reserved.
//

#import "DCLSpeakerCell.h"
#import "DCLBoldFont.h"
#import "DCLRegularFont.h"

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation DCLSpeakerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.backgroundColor = [UIColor clearColor];

        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 81)];
        _containerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background-cell-speakers.png"]];
        [self.contentView addSubview:_containerView];

        _avatar = [[UIImageView alloc] initWithFrame:CGRectMake(2.0f, 2.0f, 77.0f, 77.0f)];
        [self.contentView addSubview:_avatar];


        _speakerName = [[UILabel alloc] initWithFrame:CGRectMake(85, 12, 205, 20)];
        _speakerName.backgroundColor = [UIColor whiteColor];
        _speakerName.font = [DCLBoldFont sharedInstance];
        _speakerName.textColor = UIColorFromRGB(0x4b4745);
        [self.contentView addSubview:_speakerName];

        _userName = [[UILabel alloc] initWithFrame:CGRectMake(85, 32, 205, 20)];
        _userName.backgroundColor = [UIColor whiteColor];
        _userName.font = [DCLRegularFont sharedInstance];
        _userName.textColor = UIColorFromRGB(0x85817f);
        [self.contentView addSubview:_userName];

        _company = [[UILabel alloc] initWithFrame:CGRectMake(85, 52, 205, 20)];
        _company.backgroundColor = [UIColor whiteColor];
        _company.font = [DCLRegularFont sharedInstance];
        _company.textColor = UIColorFromRGB(0x85817f);
        [self.contentView addSubview:_company];

        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
