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

    UIScrollView *scroll = nil;

    if (self.calledInModalViewController) {
        scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44)];
        self.navigationItem.rightBarButtonItem = [self showCloseFavoritesButton];
    }
    else {
        scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 49 - 44)];
    }
    
    UIImage *buttonImage = [UIImage imageNamed:@"back.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(10, 10, buttonImage.size.width, buttonImage.size.height);
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = customBarItem;

    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20, 240)];
    backView.backgroundColor = SPEAKER_BACKGROUND_COLOR;
    [scroll addSubview:backView];

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 123, 123)];
    [imageView setImageWithURL:[NSURL URLWithString:_speaker.avatar] placeholderImage:[UIImage imageNamed:@"avatar.png"]];
    [backView addSubview:imageView];

    UILabel *firstNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(155, 20, 150, 20)];
    firstNameLabel.backgroundColor = [UIColor clearColor];
    firstNameLabel.font = [DCLRegularFont sharedInstance];
    firstNameLabel.textColor = UIColorFromRGB(0x4b4745);
    firstNameLabel.text = @"First name:";
    [scroll addSubview:firstNameLabel];

    UILabel *firstNameText= [[UILabel alloc] initWithFrame:CGRectMake(155, 40, 150, 20)];
    firstNameText.backgroundColor = [UIColor clearColor];
    firstNameText.font = [DCLBoldFont sharedInstance];
    firstNameText.textColor = UIColorFromRGB(0x4b4745);
    firstNameText.text = _speaker.firstName;
    [scroll addSubview:firstNameText];

    UILabel *lastNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(155, 70, 150, 20)];
    lastNameLabel.backgroundColor = [UIColor clearColor];
    lastNameLabel.font = [DCLRegularFont sharedInstance];
    lastNameLabel.textColor = UIColorFromRGB(0x4b4745);
    lastNameLabel.text = @"Last name:";
    [scroll addSubview:lastNameLabel];

    UILabel *lastNameText= [[UILabel alloc] initWithFrame:CGRectMake(155, 90, 150, 20)];
    lastNameText.backgroundColor = [UIColor clearColor];
    lastNameText.font = [DCLBoldFont sharedInstance];
    lastNameText.textColor = UIColorFromRGB(0x4b4745);
    lastNameText.text = _speaker.lastName;
    [scroll addSubview:lastNameText];

    UILabel *organisationLabel = [[UILabel alloc] initWithFrame:CGRectMake(155, 120, 150, 20)];
    organisationLabel.backgroundColor = [UIColor clearColor];
    organisationLabel.font = [DCLRegularFont sharedInstance];
    organisationLabel.textColor = UIColorFromRGB(0x4b4745);
    organisationLabel.text = @"Organization:";
    [scroll addSubview:organisationLabel];

    UILabel *organisationText= [[UILabel alloc] initWithFrame:CGRectMake(155, 140, 150, 20)];
    organisationText.backgroundColor = [UIColor clearColor];
    organisationText.font = [DCLBoldFont sharedInstance];
    organisationText.textColor = UIColorFromRGB(0x4b4745);
    organisationText.text = _speaker.company ? _speaker.company : @"-";
    [scroll addSubview:organisationText];
        
    backView.frame = CGRectMake(backView.frame.origin.x, backView.frame.origin.y, backView.frame.size.width, organisationText.frame.origin.y + organisationText.frame.size.height + 10);

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
            sessionButton.lineBreakMode = NSLineBreakByTruncatingTail;
            offset += 65;
            [scroll addSubview:sessionButton];
        }
    }

    scroll.contentSize = CGSizeMake(self.view.frame.size.width, offset + 95);

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

    if (self.calledInModalViewController) {
        detail.calledInModalViewController = YES;
    }
    
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissModal:(id)button
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ModalViewControllerDismissed"
                                                        object:nil
                                                      userInfo:nil];

    [self dismissModalViewControllerAnimated:YES];
}

- (UIBarButtonItem *)showCloseFavoritesButton {
    UIImage *favButtonImage = [UIImage imageNamed:@"close.png"];
    UIImage *favButtonImageActive = [UIImage imageNamed:@"close.png"];
    UIButton *favButton = [UIButton buttonWithType:UIButtonTypeCustom];

    [favButton setBackgroundImage:favButtonImage forState:UIControlStateNormal];
    [favButton setBackgroundImage:favButtonImageActive forState:UIControlStateHighlighted];

    [favButton setFrame:CGRectMake(0, 1, favButtonImage.size.width, favButtonImage.size.height)];

    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, favButtonImage.size.width, favButtonImage.size.height)];

    [favButton addTarget:self
                  action:@selector(dismissModal:)
        forControlEvents:UIControlEventTouchDown];

    [containerView addSubview:favButton];

    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:containerView];
    return item;
}


- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
    // Dispose of any resources that can be recreated.
}

@end
