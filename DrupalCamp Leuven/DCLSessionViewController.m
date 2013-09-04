//
//  DCLSessionViewController.m
//  DrupalCamp
//
//  Created by Tim Leytens on 15/08/13.
//  Copyright (c) 2013 Tim Leytens. All rights reserved.
//

#import "DCLSessionViewController.h"
#import <QuartzCore/QuartzCore.h>

#import "DCLRegularFont.h"
#import "DCLBoldFont.h"
#import "SessionsDataModel.h"
#import "DCLSpeakerViewController.h"

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface DCLSessionViewController ()

@end

@implementation DCLSessionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];

    UIImage *buttonImage = [UIImage imageNamed:@"back.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(10, 10, buttonImage.size.width, buttonImage.size.height);
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = customBarItem;
     
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20, 240)];
    backView.backgroundColor = UIColorFromRGB(0xffffff);

    [backView setClipsToBounds:NO];
    [backView.layer setCornerRadius:1];
    [backView.layer setShadowOffset:CGSizeMake(0, 0)];
    [backView.layer setShadowColor:[[UIColor lightGrayColor] CGColor]];
    [backView.layer setShadowRadius:1];
    [backView.layer setShadowOpacity:0.5];

    [scroll addSubview:backView];

    UILabel *sessionTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, self.view.frame.size.width - 40, [self getHeightForString:_session.title forWidth:(self.view.frame.size.width - 40) withFont:[DCLBoldFont sharedInstance]])];
    sessionTitle.backgroundColor = [UIColor whiteColor];
    sessionTitle.font = [DCLBoldFont sharedInstance];
    sessionTitle.textColor = UIColorFromRGB(0x4b4745);
    sessionTitle.text = _session.title;
    sessionTitle.numberOfLines = 0;
    [scroll addSubview:sessionTitle];

    UILabel *sessionBody = [[UILabel alloc] initWithFrame:CGRectMake(20, sessionTitle.frame.size.height + sessionTitle.frame.origin.y + 20, self.view.frame.size.width - 40, [self getHeightForString:_session.body forWidth:(self.view.frame.size.width - 40) withFont:[DCLRegularFont sharedInstance]])];
    sessionBody.backgroundColor = [UIColor whiteColor];
    sessionBody.font = [DCLRegularFont sharedInstance];
    sessionBody.textColor = UIColorFromRGB(0x4b4745);
    sessionBody.text = _session.body;
    sessionBody.numberOfLines = 0;
    [scroll addSubview:sessionBody];

    UILabel *experienceLevel = [[UILabel alloc] initWithFrame:CGRectMake(20, sessionBody.frame.origin.y + sessionBody.frame.size.height + 20, 125, 20)];
    experienceLevel.backgroundColor = [UIColor whiteColor];
    experienceLevel.font = [DCLBoldFont sharedInstance];
    experienceLevel.textColor = UIColorFromRGB(0x4b4745);
    experienceLevel.text = @"Experience level:";
    [scroll addSubview:experienceLevel];

    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", _session.level]];
    imageView.frame = CGRectMake(experienceLevel.frame.size.width + experienceLevel.frame.origin.x, experienceLevel.frame.origin.y + 3, imageView.image.size.width, imageView.image.size.height);
    [scroll addSubview:imageView];

    UILabel *dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, experienceLevel.frame.origin.y + experienceLevel.frame.size.height + 10, 45, 20)];
    dayLabel.backgroundColor = [UIColor whiteColor];
    dayLabel.font = [DCLBoldFont sharedInstance];
    dayLabel.textColor = UIColorFromRGB(0x4b4745);
    dayLabel.text = @"Date:";
    [scroll addSubview:dayLabel];

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"ccc d/M"];

    UILabel *dayText= [[UILabel alloc] initWithFrame:CGRectMake(dayLabel.frame.origin.x + dayLabel.frame.size.width, experienceLevel.frame.origin.y + experienceLevel.frame.size.height + 10, 200, 20)];
    dayText.backgroundColor = [UIColor whiteColor];
    dayText.font = [DCLRegularFont sharedInstance];
    dayText.textColor = UIColorFromRGB(0x4b4745);
    dayText.text = [dateFormat stringFromDate:[NSDate dateWithTimeIntervalSince1970:[_session.from intValue]]];
    [scroll addSubview:dayText];

    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, dayLabel.frame.origin.y + dayLabel.frame.size.height + 10, 46, 20)];
    timeLabel.backgroundColor = [UIColor whiteColor];
    timeLabel.font = [DCLBoldFont sharedInstance];
    timeLabel.textColor = UIColorFromRGB(0x4b4745);
    timeLabel.text = @"Time:";
    [scroll addSubview:timeLabel];

    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"H:mm"];

    UILabel *timeText= [[UILabel alloc] initWithFrame:CGRectMake(timeLabel.frame.origin.x + timeLabel.frame.size.width, timeLabel.frame.origin.y, 200, 20)];
    timeText.backgroundColor = [UIColor whiteColor];
    timeText.font = [DCLRegularFont sharedInstance];
    timeText.textColor = UIColorFromRGB(0x4b4745);
    timeText.text = [NSString stringWithFormat:@"%@ - %@",
                     [timeFormat stringFromDate:[NSDate dateWithTimeIntervalSince1970:[_session.from intValue]]],
                     [timeFormat stringFromDate:[NSDate dateWithTimeIntervalSince1970:[_session.to intValue]]]];
    [scroll addSubview:timeText];

    
    UILabel *roomLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, timeLabel.frame.origin.y + timeLabel.frame.size.height + 10, 50, 20)];
    roomLabel.backgroundColor = [UIColor whiteColor];
    roomLabel.font = [DCLBoldFont sharedInstance];
    roomLabel.textColor = UIColorFromRGB(0x4b4745);
    roomLabel.text = @"Room:";
    [scroll addSubview:roomLabel];

    UILabel *roomText= [[UILabel alloc] initWithFrame:CGRectMake(roomLabel.frame.origin.x + roomLabel.frame.size.width, roomLabel.frame.origin.y, 200, 20)];
    roomText.backgroundColor = [UIColor whiteColor];
    roomText.font = [DCLRegularFont sharedInstance];
    roomText.textColor = UIColorFromRGB(0x4b4745);
    roomText.text = _session.room;
    [scroll addSubview:roomText];

    UIImage *favButtonImage = [UIImage imageNamed:@"fav_large.png"];
    UIImage *favButtonImageActive = [UIImage imageNamed:@"fav_active_large.png"];
    UIButton *favButton = [UIButton buttonWithType:UIButtonTypeCustom];

    [favButton setBackgroundImage:favButtonImage forState:UIControlStateNormal];
    [favButton setBackgroundImage:favButtonImageActive forState:(UIControlStateSelected)];
    [favButton setBackgroundImage:favButtonImageActive forState:(UIControlStateHighlighted)];
    [favButton setBackgroundImage:favButtonImageActive forState:(UIControlStateSelected|UIControlStateHighlighted)];

    [favButton setFrame:CGRectMake(245, roomLabel.frame.origin.y + roomLabel.frame.size.height, favButtonImage.size.width, favButtonImage.size.height)];

    [favButton addTarget:self
                       action:@selector(addEventToFavorites:)
             forControlEvents:UIControlEventTouchDown];

    if ([_session.fav isEqualToNumber:[NSNumber numberWithInt:1]]) {
        favButton.selected = YES;
    }
    else {
        favButton.selected = NO;
    }


    [scroll addSubview:favButton];


    backView.frame = CGRectMake(backView.frame.origin.x, backView.frame.origin.y, backView.frame.size.width, favButton.frame.origin.y + favButton.frame.size.height);

    if(!_calledFromSpeakerViewController) {

        UIButton *speakerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [speakerButton addTarget:self
                          action:@selector(pushSpeaker:)
              forControlEvents:UIControlEventTouchDown];
        [speakerButton setTitle:[NSString stringWithFormat:@"%@ %@", _session.speaker.firstName, _session.speaker.lastName] forState:UIControlStateNormal];
        speakerButton.frame = CGRectMake(10, backView.frame.origin.y + backView.frame.size.height + 10, self.view.frame.size.width - 20, 55.0);
        speakerButton.backgroundColor = UIColorFromRGB(0x3992c2);    
        [scroll addSubview:speakerButton];

        scroll.contentSize = CGSizeMake(self.view.frame.size.width, speakerButton.frame.origin.y + speakerButton.frame.size.height + 105);

    }
    else {
        scroll.contentSize = CGSizeMake(self.view.frame.size.width, backView.frame.origin.y + backView.frame.size.height + 105);

    }
    
    [self.view addSubview:scroll];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushSpeaker:(id)sender
{
    DCLSpeakerViewController *detail = [[DCLSpeakerViewController alloc] initWithNibName:nil bundle:NULL];
    detail.title = [NSString stringWithFormat:@"%@ %@", _session.speaker.firstName, _session.speaker.lastName];
    detail.speaker = _session.speaker;
    //detail.calledFromSessionViewController = YES;
    [self.navigationController pushViewController:detail animated:YES];
}


- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
    // Dispose of any resources that can be recreated.
}

-(CGFloat)getHeightForString:(NSString *)string forWidth:(float)width withFont:(UIFont *)font {
    NSString *text = string;
    CGSize constraint = CGSizeMake(width, 20000.0f);
    CGSize size = [text sizeWithFont:font constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    return size.height;
}

- (void)addEventToFavorites:(UIButton*)sender
{

    sender.selected = !sender.selected;
    [_session toggleFavorite:sender.selected];
    [_moc save:nil];
}

@end
