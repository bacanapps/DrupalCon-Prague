//
//  DCLSessionCell.m
//  DrupalCamp Leuven
//
//  Created by Tim Leytens on 21/07/13.
//  Copyright (c) 2013 Tim Leytens. All rights reserved.
//

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#import "DCLSessionCell.h"
#import "DCLBoldFont.h"
#import "DCLRegularFont.h"

@implementation DCLSessionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.backgroundColor = [UIColor clearColor];

        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 94)];
        _containerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background-cell.png"]];
        [self.contentView addSubview:_containerView];

        _sessionTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, 280, 20)];
        _sessionTitle.backgroundColor = [UIColor whiteColor];
        _sessionTitle.font = [DCLBoldFont sharedInstance];
        _sessionTitle.textColor = UIColorFromRGB(0x4b4745);
        [self.contentView addSubview:_sessionTitle];

        _speakerName = [[UILabel alloc] initWithFrame:CGRectMake(10, 32, 280, 20)];
        _speakerName.backgroundColor = [UIColor whiteColor];
        _speakerName.font = [DCLRegularFont sharedInstance];
        _speakerName.textColor = UIColorFromRGB(0x85817f);
        [self.contentView addSubview:_speakerName];

        _timeSlot = [[UILabel alloc] initWithFrame:CGRectMake(10, 67, 80, 20)];
        _timeSlot.backgroundColor = [UIColor whiteColor];
        _timeSlot.font = [UIFont fontWithName:@"OpenSans" size:11.0];
        _timeSlot.textColor = UIColorFromRGB(0x85817f);
        [self.contentView addSubview:_timeSlot];

        UIImage *favButtonImage = [UIImage imageNamed:@"fav.png"];
        UIImage *favButtonImageActive = [UIImage imageNamed:@"fav_active.png"];
        _favButton = [UIButton buttonWithType:UIButtonTypeCustom];

        [_favButton setBackgroundImage:favButtonImage forState:UIControlStateNormal];
        [_favButton setBackgroundImage:favButtonImageActive forState:UIControlStateSelected];

        [_favButton setFrame:CGRectMake(262, 65, favButtonImage.size.width, favButtonImage.size.height)];
        
        [self.contentView addSubview:_favButton];


        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, 60, 280, 1)];
        line.backgroundColor = UIColorFromRGB(0xe5e5e5);

        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self.contentView addSubview:line];

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
