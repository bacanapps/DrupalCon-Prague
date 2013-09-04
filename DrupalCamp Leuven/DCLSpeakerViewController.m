//
//  DCLSpeakerViewController.m
//  DrupalCamp
//
//  Created by Tim Leytens on 3/09/13.
//  Copyright (c) 2013 Tim Leytens. All rights reserved.
//

#import "DCLSpeakerViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AFNetworking.h"
#import "DCLRegularFont.h"
#import "DCLBoldFont.h"
#import "Session.h"
#import "SessionsDataModel.h"
#import "DCLSessionViewController.h"

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface DCLSpeakerViewController ()

@end

@implementation DCLSpeakerViewController

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

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 123, 123)];
    [imageView setImageWithURL:[NSURL URLWithString:_speaker.avatar] placeholderImage:[UIImage imageNamed:@"avatar.png"]];
    [backView addSubview:imageView];

    UILabel *firstNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(155, 20, 150, 20)];
    firstNameLabel.backgroundColor = [UIColor whiteColor];
    firstNameLabel.font = [DCLRegularFont sharedInstance];
    firstNameLabel.textColor = UIColorFromRGB(0x4b4745);
    firstNameLabel.text = @"First name:";
    [scroll addSubview:firstNameLabel];

    UILabel *firstNameText= [[UILabel alloc] initWithFrame:CGRectMake(155, 40, 150, 20)];
    firstNameText.backgroundColor = [UIColor whiteColor];
    firstNameText.font = [DCLBoldFont sharedInstance];
    firstNameText.textColor = UIColorFromRGB(0x4b4745);
    firstNameText.text = _speaker.firstName;
    [scroll addSubview:firstNameText];

    UILabel *lastNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(155, 70, 150, 20)];
    lastNameLabel.backgroundColor = [UIColor whiteColor];
    lastNameLabel.font = [DCLRegularFont sharedInstance];
    lastNameLabel.textColor = UIColorFromRGB(0x4b4745);
    lastNameLabel.text = @"Last name:";
    [scroll addSubview:lastNameLabel];

    UILabel *lastNameText= [[UILabel alloc] initWithFrame:CGRectMake(155, 90, 150, 20)];
    lastNameText.backgroundColor = [UIColor whiteColor];
    lastNameText.font = [DCLBoldFont sharedInstance];
    lastNameText.textColor = UIColorFromRGB(0x4b4745);
    lastNameText.text = _speaker.lastName;
    [scroll addSubview:lastNameText];


    UILabel *userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(155, 120, 150, 20)];
    userNameLabel.backgroundColor = [UIColor whiteColor];
    userNameLabel.font = [DCLRegularFont sharedInstance];
    userNameLabel.textColor = UIColorFromRGB(0x4b4745);
    userNameLabel.text = @"Username:";
    [scroll addSubview:userNameLabel];

    UILabel *userNameText= [[UILabel alloc] initWithFrame:CGRectMake(155, 140, 150, 20)];
    userNameText.backgroundColor = [UIColor whiteColor];
    userNameText.font = [DCLBoldFont sharedInstance];
    userNameText.textColor = UIColorFromRGB(0x4b4745);
    userNameText.text = _speaker.username;
    [scroll addSubview:userNameText];

    UILabel *organisationLabel = [[UILabel alloc] initWithFrame:CGRectMake(155, 170, 150, 20)];
    organisationLabel.backgroundColor = [UIColor whiteColor];
    organisationLabel.font = [DCLRegularFont sharedInstance];
    organisationLabel.textColor = UIColorFromRGB(0x4b4745);
    organisationLabel.text = @"Organization:";
    [scroll addSubview:organisationLabel];

    UILabel *organisationText= [[UILabel alloc] initWithFrame:CGRectMake(155, 190, 150, 20)];
    organisationText.backgroundColor = [UIColor whiteColor];
    organisationText.font = [DCLBoldFont sharedInstance];
    organisationText.textColor = UIColorFromRGB(0x4b4745);
    organisationText.text = _speaker.company ? _speaker.company : @"-";
    [scroll addSubview:organisationText];
        
    UILabel *twitterLabel = [[UILabel alloc] initWithFrame:CGRectMake(155, 220, 150, 20)];
    twitterLabel.backgroundColor = [UIColor whiteColor];
    twitterLabel.font = [DCLRegularFont sharedInstance];
    twitterLabel.textColor = UIColorFromRGB(0x4b4745);
    twitterLabel.text = @"Twitter:";
    [scroll addSubview:twitterLabel];

    UILabel *twitterText= [[UILabel alloc] initWithFrame:CGRectMake(155, 240, 150, 20)];
    twitterText.backgroundColor = [UIColor whiteColor];
    twitterText.font = [DCLBoldFont sharedInstance];
    twitterText.textColor = UIColorFromRGB(0x4b4745);
    twitterText.text = _speaker.twitter ? _speaker.twitter : @"-";
    [scroll addSubview:twitterText];
    
    backView.frame = CGRectMake(backView.frame.origin.x, backView.frame.origin.y, backView.frame.size.width, twitterText.frame.origin.y + twitterText.frame.size.height + 10);

    [self.view addSubview:scroll];

    int offset = backView.frame.origin.y + backView.frame.size.height + 10 ;
    if (!_calledFromSessionViewController) {
        for (Session *session in _speaker.session) {
            UIButton *sessionButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [sessionButton addTarget:self
                              action:@selector(pushSession:)
                  forControlEvents:UIControlEventTouchDown];
            [sessionButton setTitle:session.title forState:UIControlStateNormal];
            sessionButton.frame = CGRectMake(10, offset, self.view.frame.size.width - 20, 55.0);
            sessionButton.backgroundColor = UIColorFromRGB(0x00878a);
            sessionButton.tag = [session.serverId integerValue];
            offset += 65;
            [scroll addSubview:sessionButton];
        }
    }
}

- (void)pushSession:(UIButton *)sender
{

    NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] init];
    [moc setPersistentStoreCoordinator:[[SessionsDataModel sharedDataModel] persistentStoreCoordinator]];

    Session *session = [Session eventWithServerId:sender.tag usingManagedObjectContext:moc];
    DCLSessionViewController *detail = [[DCLSessionViewController alloc] initWithNibName:nil bundle:NULL];
    detail.title = session.title;
    detail.session = session;
    detail.moc = moc;
    //detail.calledFromSpeakerViewController = YES;
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
    // Dispose of any resources that can be recreated.
}

@end
