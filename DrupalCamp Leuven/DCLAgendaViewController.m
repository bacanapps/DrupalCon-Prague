//
//  DCLAgendaViewController.m
//  DrupalCamp Leuven
//
//  Created by Tim Leytens on 20/07/13.
//  Copyright (c) 2013 Tim Leytens. All rights reserved.
//

#import "DCLAgendaViewController.h"

#import "MBProgressHUD.h"

#import "DCLSessionCell.h"

#import "DCLLightFont.h"
#import "DCLRegularFont.h"
#import "SessionsDataModel.h"
#import "Session.h"
#import "DCLSessionViewController.h"
#import "DCLAPIClient.h"
#import "PHFRefreshControl.h"


#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface DCLAgendaViewController () {
    MBProgressHUD *_hud;
}

@property (nonatomic, strong) NSArray *sessions;
@property (nonatomic, strong) NSManagedObjectContext *moc;


@end

@implementation DCLAgendaViewController 


- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {

        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil
                                                        image:nil
                                                          tag:0];

        [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"agendaButton.png"]
                      withFinishedUnselectedImage:[UIImage imageNamed:@"agendaButton.png"]];

        self.tabBarItem.imageInsets = UIEdgeInsetsMake(4, 0, -4, 0);

    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = @"SCHEDULE";

    PHFRefreshControl *refreshControl = [PHFRefreshControl new];
    [refreshControl setTintColor:[UIColor darkGrayColor]];
    [refreshControl addTarget:self
                       action:@selector(refresh)
             forControlEvents:UIControlEventValueChanged];
    [_outerScrollView setRefreshControl:refreshControl];
    
    [_day1 registerClass:[DCLSessionCell class] forCellReuseIdentifier:@"customCell"];
    [_day2 registerClass:[DCLSessionCell class] forCellReuseIdentifier:@"customCell"];
    [_day3 registerClass:[DCLSessionCell class] forCellReuseIdentifier:@"customCell"];
    [_day4 registerClass:[DCLSessionCell class] forCellReuseIdentifier:@"customCell"];
    [_day5 registerClass:[DCLSessionCell class] forCellReuseIdentifier:@"customCell"];

    self.moc = [[NSManagedObjectContext alloc] init];
    [self.moc setPersistentStoreCoordinator:[[SessionsDataModel sharedDataModel] persistentStoreCoordinator]];
    [self.moc setMergePolicy:NSMergeByPropertyStoreTrumpMergePolicy];

   
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshData:)
                                                 name:NSManagedObjectContextDidSaveNotification
                                               object:self.moc];


}

- (void) refreshData:(NSNotification *)notification
{
    _firstFetchedResultsController = nil;
    _secondFetchedResultsController = nil;
    _thirdFetchedResultsController = nil;
    _fourthFetchedResultsController = nil;
    _fifthFetchedResultsController = nil;

    [_day1 reloadData];
    [_day2 reloadData];
    [_day3 reloadData];
    [_day4 reloadData];
    [_day5 reloadData];

}

- (void)refresh {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [[DCLAPIClient sharedInstance] getPath:@"timeslots/list.json" parameters:nil
                                   success:^(AFHTTPRequestOperation *operation, id response) {
                                       [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

                                       
                                       // Get existing ids from DB.
                                       NSArray *ids = [Session getSessionsIdsUsingManagedObjectContext:self.moc];

                                       // Get new ids from response.
                                       NSMutableArray *serverIds = [[NSMutableArray alloc] init];
                                       for (NSDictionary *sessionDict in response) {
                                           [serverIds addObject:[NSNumber numberWithInteger:[[sessionDict objectForKey:@"id"] intValue]]];
                                       }

                                       // Check for deleted serverIds.
                                       for (NSNumber *serverId in ids) {
                                           if (![serverIds containsObject:serverId]) {
                                               Session *session = [Session eventWithServerId:[serverId integerValue] usingManagedObjectContext:self.moc];
                                               [self.moc deleteObject:session];
                                           }
                                       }
                                       
                                       for (NSDictionary *dictionary in response) {

                                           
                                           Speaker *speaker = nil;

                                           NSMutableSet *speakers = [[NSMutableSet alloc] init];

                                           for (NSDictionary *speakerDictionary in [dictionary objectForKey:@"speakers"]) {
                                               NSInteger userId = [[speakerDictionary objectForKey:@"id"] intValue];
                                               speaker = [Speaker speakerWithServerId:userId usingManagedObjectContext:self.moc];
                                                if (speaker == nil) {
                                                    speaker = [Speaker insertInManagedObjectContext:self.moc];
                                                    [speaker setServerId:[NSNumber numberWithInteger:userId]];
                                                }
                                                [speaker updateAttributes:speakerDictionary];
                                               [speakers addObject:speaker];
                                            }

                                            NSInteger serverId = [[dictionary objectForKey:@"id"] intValue];
                                            Session *session = [Session eventWithServerId:serverId usingManagedObjectContext:self.moc];
                                            if (session == nil) {
                                                session = [Session insertInManagedObjectContext:self.moc];
                                                [session setServerId:[NSNumber numberWithInteger:serverId]];
                                            }
                                            
                                            [session updateAttributes:dictionary withSpeakers:speakers];

                                        }

                                       NSError *error = nil;
                                       if ([self.moc save:&error]) {

                                           
                                       } else {
                                           NSLog(@"ERROR: %@ %@", [error localizedDescription], [error userInfo]);
                                           exit(1);
                                       }

                                       [[_outerScrollView refreshControl] endRefreshing];
                                   }
                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                       [[_outerScrollView refreshControl] endRefreshing];

                                   }];

}



- (void)switchScrollView:(UIButton *)sender {
    if (sender.tag == 1) {
        CGRect frame = CGRectMake(320, 0, _innerScrollView.frame.size.width, _innerScrollView.frame.size.height);
        [_innerScrollView scrollRectToVisible:frame animated:YES];
        _innerScrollView.frame = CGRectMake(_innerScrollView.frame.origin.x, _innerScrollView.frame.origin.y, _innerScrollView.frame.size.width, _day2.contentSize.height);
        _innerScrollView.contentSize = CGSizeMake(320 * 5, _innerScrollView.frame.size.height);
        _outerScrollView.contentSize = CGSizeMake(320, _day2.contentSize.height + 80);
    }
    else if (sender.tag == 2) {
        CGRect frame = CGRectMake(0, 0, _innerScrollView.frame.size.width, _innerScrollView.frame.size.height);
        [_innerScrollView scrollRectToVisible:frame animated:YES];
        _innerScrollView.frame = CGRectMake(_innerScrollView.frame.origin.x, _innerScrollView.frame.origin.y, _innerScrollView.frame.size.width, _day1.contentSize.height);
        _innerScrollView.contentSize = CGSizeMake(320 * 5, _innerScrollView.frame.size.height);
        _outerScrollView.contentSize = CGSizeMake(320, _day1.contentSize.height + 80);
    }
    else if (sender.tag == 3) {
        CGRect frame = CGRectMake(640, 0, _innerScrollView.frame.size.width, _innerScrollView.frame.size.height);
        [_innerScrollView scrollRectToVisible:frame animated:YES];
        _innerScrollView.frame = CGRectMake(_innerScrollView.frame.origin.x, _innerScrollView.frame.origin.y, _innerScrollView.frame.size.width, _day1.contentSize.height);
        _innerScrollView.contentSize = CGSizeMake(320 * 5, _innerScrollView.frame.size.height);
        _outerScrollView.contentSize = CGSizeMake(320, _day1.contentSize.height + 80);
    }
    else if (sender.tag == 4) {
        CGRect frame = CGRectMake(960, 0, _innerScrollView.frame.size.width, _innerScrollView.frame.size.height);
        [_innerScrollView scrollRectToVisible:frame animated:YES];
        _innerScrollView.frame = CGRectMake(_innerScrollView.frame.origin.x, _innerScrollView.frame.origin.y, _innerScrollView.frame.size.width, _day1.contentSize.height);
        _innerScrollView.contentSize = CGSizeMake(320 * 5, _innerScrollView.frame.size.height);
        _outerScrollView.contentSize = CGSizeMake(320, _day1.contentSize.height + 80);
    }
    else if (sender.tag == 5) {
        CGRect frame = CGRectMake(1280, 0, _innerScrollView.frame.size.width, _innerScrollView.frame.size.height);
        [_innerScrollView scrollRectToVisible:frame animated:YES];
        _innerScrollView.frame = CGRectMake(_innerScrollView.frame.origin.x, _innerScrollView.frame.origin.y, _innerScrollView.frame.size.width, _day1.contentSize.height);
        _innerScrollView.contentSize = CGSizeMake(320 * 5, _innerScrollView.frame.size.height);
        _outerScrollView.contentSize = CGSizeMake(320, _day1.contentSize.height + 80);
    }
}




-(UIView *)addTableViewHeaderDay1 {
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 20 , 60)];

    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 3, containerView.frame.size.width, 60)];
    headerLabel.font = [UIFont fontWithName:@"PT Sans Narrow" size:20.0];
    headerLabel.text = @"23TH SEPTEMBER 2013";
    headerLabel.textColor = UIColorFromRGB(0x4b4745);
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.backgroundColor = [UIColor clearColor];

    UIImage *arrowButtonRightImage = [UIImage imageNamed:@"arrow-right.png"];
    UIButton *arrowButtonRight = [UIButton buttonWithType:UIButtonTypeCustom];

    [arrowButtonRight setBackgroundImage:arrowButtonRightImage forState:UIControlStateNormal];
    [arrowButtonRight setBackgroundImage:arrowButtonRightImage forState:UIControlStateHighlighted];

    [arrowButtonRight setFrame:CGRectMake(containerView.frame.size.width - arrowButtonRightImage.size.width - 5, (60 - arrowButtonRightImage.size.height) / 2 + 1, arrowButtonRightImage.size.width, arrowButtonRightImage.size.height)];

    [arrowButtonRight setTag:1];
    [arrowButtonRight addTarget:self
                    action:@selector(switchScrollView:)
        forControlEvents:UIControlEventTouchDown];

    [containerView addSubview:arrowButtonRight];


    [containerView addSubview:headerLabel];

    return containerView;
}

-(UIView *)addTableViewHeaderDay2 {

    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 20 , 60)];

    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 3, containerView.frame.size.width, 60)];
    headerLabel.font = [UIFont fontWithName:@"PT Sans Narrow" size:20.0];
    headerLabel.text = @"24TH SEPTEMBER 2013";
    headerLabel.textColor = UIColorFromRGB(0x4b4745);
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.backgroundColor = [UIColor clearColor];

    UIImage *arrowButtonLeftImage = [UIImage imageNamed:@"arrow-left.png"];
    UIButton *arrowButtonLeft = [UIButton buttonWithType:UIButtonTypeCustom];

    [arrowButtonLeft setBackgroundImage:arrowButtonLeftImage forState:UIControlStateNormal];
    [arrowButtonLeft setBackgroundImage:arrowButtonLeftImage forState:UIControlStateHighlighted];

    [arrowButtonLeft setFrame:CGRectMake(0 + 5, (60 - arrowButtonLeftImage.size.height) / 2 + 1, arrowButtonLeftImage.size.width, arrowButtonLeftImage.size.height)];
    [arrowButtonLeft setTag:2];
    [arrowButtonLeft addTarget:self
                        action:@selector(switchScrollView:)
              forControlEvents:UIControlEventTouchDown];

    [containerView addSubview:arrowButtonLeft];


    UIImage *arrowButtonRightImage = [UIImage imageNamed:@"arrow-right.png"];
    UIButton *arrowButtonRight = [UIButton buttonWithType:UIButtonTypeCustom];

    [arrowButtonRight setBackgroundImage:arrowButtonRightImage forState:UIControlStateNormal];
    [arrowButtonRight setBackgroundImage:arrowButtonRightImage forState:UIControlStateHighlighted];

    [arrowButtonRight setFrame:CGRectMake(containerView.frame.size.width - arrowButtonRightImage.size.width - 5, (60 - arrowButtonRightImage.size.height) / 2 + 1, arrowButtonRightImage.size.width, arrowButtonRightImage.size.height)];

    [arrowButtonRight setTag:3];
    [arrowButtonRight addTarget:self
                         action:@selector(switchScrollView:)
               forControlEvents:UIControlEventTouchDown];

    [containerView addSubview:arrowButtonRight];



    [containerView addSubview:headerLabel];
    
    return containerView;
}

-(UIView *)addTableViewHeaderDay3 {

    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 20 , 60)];

    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 3, containerView.frame.size.width, 60)];
    headerLabel.font = [UIFont fontWithName:@"PT Sans Narrow" size:20.0];
    headerLabel.text = @"25TH SEPTEMBER 2013";
    headerLabel.textColor = UIColorFromRGB(0x4b4745);
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.backgroundColor = [UIColor clearColor];

    UIImage *arrowButtonLeftImage = [UIImage imageNamed:@"arrow-left.png"];
    UIButton *arrowButtonLeft = [UIButton buttonWithType:UIButtonTypeCustom];

    [arrowButtonLeft setBackgroundImage:arrowButtonLeftImage forState:UIControlStateNormal];
    [arrowButtonLeft setBackgroundImage:arrowButtonLeftImage forState:UIControlStateHighlighted];

    [arrowButtonLeft setFrame:CGRectMake(0 + 5, (60 - arrowButtonLeftImage.size.height) / 2 + 1, arrowButtonLeftImage.size.width, arrowButtonLeftImage.size.height)];
    [arrowButtonLeft setTag:1];
    [arrowButtonLeft addTarget:self
                        action:@selector(switchScrollView:)
              forControlEvents:UIControlEventTouchDown];

    [containerView addSubview:arrowButtonLeft];

    UIImage *arrowButtonRightImage = [UIImage imageNamed:@"arrow-right.png"];
    UIButton *arrowButtonRight = [UIButton buttonWithType:UIButtonTypeCustom];

    [arrowButtonRight setBackgroundImage:arrowButtonRightImage forState:UIControlStateNormal];
    [arrowButtonRight setBackgroundImage:arrowButtonRightImage forState:UIControlStateHighlighted];

    [arrowButtonRight setFrame:CGRectMake(containerView.frame.size.width - arrowButtonRightImage.size.width - 5, (60 - arrowButtonRightImage.size.height) / 2 + 1, arrowButtonRightImage.size.width, arrowButtonRightImage.size.height)];

    [arrowButtonRight setTag:4];
    [arrowButtonRight addTarget:self
                         action:@selector(switchScrollView:)
               forControlEvents:UIControlEventTouchDown];

    [containerView addSubview:arrowButtonRight];

    [containerView addSubview:headerLabel];
    
    return containerView;
}


-(UIView *)addTableViewHeaderDay4 {

    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 20 , 60)];

    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 3, containerView.frame.size.width, 60)];
    headerLabel.font = [UIFont fontWithName:@"PT Sans Narrow" size:20.0];
    headerLabel.text = @"26TH SEPTEMBER 2013";
    headerLabel.textColor = UIColorFromRGB(0x4b4745);
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.backgroundColor = [UIColor clearColor];

    UIImage *arrowButtonLeftImage = [UIImage imageNamed:@"arrow-left.png"];
    UIButton *arrowButtonLeft = [UIButton buttonWithType:UIButtonTypeCustom];

    [arrowButtonLeft setBackgroundImage:arrowButtonLeftImage forState:UIControlStateNormal];
    [arrowButtonLeft setBackgroundImage:arrowButtonLeftImage forState:UIControlStateHighlighted];

    [arrowButtonLeft setFrame:CGRectMake(0 + 5, (60 - arrowButtonLeftImage.size.height) / 2 + 1, arrowButtonLeftImage.size.width, arrowButtonLeftImage.size.height)];
    [arrowButtonLeft setTag:3];
    [arrowButtonLeft addTarget:self
                        action:@selector(switchScrollView:)
              forControlEvents:UIControlEventTouchDown];

    [containerView addSubview:arrowButtonLeft];

    UIImage *arrowButtonRightImage = [UIImage imageNamed:@"arrow-right.png"];
    UIButton *arrowButtonRight = [UIButton buttonWithType:UIButtonTypeCustom];

    [arrowButtonRight setBackgroundImage:arrowButtonRightImage forState:UIControlStateNormal];
    [arrowButtonRight setBackgroundImage:arrowButtonRightImage forState:UIControlStateHighlighted];

    [arrowButtonRight setFrame:CGRectMake(containerView.frame.size.width - arrowButtonRightImage.size.width - 5, (60 - arrowButtonRightImage.size.height) / 2 + 1, arrowButtonRightImage.size.width, arrowButtonRightImage.size.height)];

    [arrowButtonRight setTag:5];
    [arrowButtonRight addTarget:self
                         action:@selector(switchScrollView:)
               forControlEvents:UIControlEventTouchDown];

    [containerView addSubview:arrowButtonRight];

    [containerView addSubview:headerLabel];
    
    return containerView;
}

-(UIView *)addTableViewHeaderDay5 {

    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 20 , 60)];

    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 3, containerView.frame.size.width, 60)];
    headerLabel.font = [UIFont fontWithName:@"PT Sans Narrow" size:20.0];
    headerLabel.text = @"27TH SEPTEMBER 2013";
    headerLabel.textColor = UIColorFromRGB(0x4b4745);
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.backgroundColor = [UIColor clearColor];

    UIImage *arrowButtonLeftImage = [UIImage imageNamed:@"arrow-left.png"];
    UIButton *arrowButtonLeft = [UIButton buttonWithType:UIButtonTypeCustom];

    [arrowButtonLeft setBackgroundImage:arrowButtonLeftImage forState:UIControlStateNormal];
    [arrowButtonLeft setBackgroundImage:arrowButtonLeftImage forState:UIControlStateHighlighted];

    [arrowButtonLeft setFrame:CGRectMake(0 + 5, (60 - arrowButtonLeftImage.size.height) / 2 + 1, arrowButtonLeftImage.size.width, arrowButtonLeftImage.size.height)];
    [arrowButtonLeft setTag:4];
    [arrowButtonLeft addTarget:self
                        action:@selector(switchScrollView:)
              forControlEvents:UIControlEventTouchDown];

    [containerView addSubview:arrowButtonLeft];


    [containerView addSubview:headerLabel];
    
    return containerView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == _day1) {
        if ([[self.firstFetchedResultsController sections] count] == 0) {
            return 0;
        }
        else {
            id <NSFetchedResultsSectionInfo> sectionInfo = [self.firstFetchedResultsController sections][section];
            return [sectionInfo numberOfObjects];
        }
    }
    else if (tableView == _day2){
        if ([[self.secondFetchedResultsController sections] count] == 0) {
            return 0;
        }
        else {
            id <NSFetchedResultsSectionInfo> sectionInfo = [self.secondFetchedResultsController sections][section];
            return [sectionInfo numberOfObjects];
        }
    }
    else if (tableView == _day3){
        if ([[self.thirdFetchedResultsController sections] count] == 0) {
            return 0;
        }
        else {
            id <NSFetchedResultsSectionInfo> sectionInfo = [self.thirdFetchedResultsController sections][section];
            return [sectionInfo numberOfObjects];
        }
    }
    else if (tableView == _day4){
        if ([[self.fourthFetchedResultsController sections] count] == 0) {
            return 0;
        }
        else {
            id <NSFetchedResultsSectionInfo> sectionInfo = [self.fourthFetchedResultsController sections][section];
            return [sectionInfo numberOfObjects];
        }
    }
    else if (tableView == _day5){
        if ([[self.fifthFetchedResultsController sections] count] == 0) {
            return 0;
        }
        else {
            id <NSFetchedResultsSectionInfo> sectionInfo = [self.fifthFetchedResultsController sections][section];
            return [sectionInfo numberOfObjects];
        }
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"H:mm"];

    Session *session;
    if(tableView == _day1) {
        session = [self.firstFetchedResultsController objectAtIndexPath:indexPath];
    }
    else if(tableView == _day2) {
        session = [self.secondFetchedResultsController objectAtIndexPath:indexPath];
    }
    else if(tableView == _day3) {
        session = [self.thirdFetchedResultsController objectAtIndexPath:indexPath];
    }
    else if(tableView == _day4) {
        session = [self.fourthFetchedResultsController objectAtIndexPath:indexPath];
    }
    else if(tableView == _day5) {
        session = [self.fifthFetchedResultsController objectAtIndexPath:indexPath];
    }
    
    if ([session.special integerValue] == 0) {
        static NSString *CellIdentifier = @"customCell";
        DCLSessionCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

        cell.sessionTitle.text = session.title;

        NSMutableArray *speakers = [[NSMutableArray alloc] init];

        for (Speaker *speaker in session.speaker) {
            [speakers addObject:speaker.username];
        }

        if ([speakers count] > 0) {
            cell.speakerName.text = [speakers componentsJoinedByString:@", "];
        }
        else {
            cell.speakerName.text = session.extra;
        }
        
        if ([session.track isEqualToString:@"Business + Strategy"]) {
            [cell.trackImageView setImage:[UIImage imageNamed:@"business.png"]];
        }
        else if ([session.track isEqualToString:@"DevOps"]) {
            [cell.trackImageView setImage:[UIImage imageNamed:@"devops.png"]];
        }
        else if ([session.track isEqualToString:@"Site Building"]) {
            [cell.trackImageView setImage:[UIImage imageNamed:@"sitebuilding.png"]];
        }
        else if ([session.track isEqualToString:@"Labs"]) {
            [cell.trackImageView setImage:[UIImage imageNamed:@"labs.png"]];
        }
        else if ([session.track isEqualToString:@"Coding + Development"]) {
            [cell.trackImageView setImage:[UIImage imageNamed:@"coding.png"]];
        }
        else if ([session.track isEqualToString:@"Frontend"]) {
            [cell.trackImageView setImage:[UIImage imageNamed:@"html5.png"]];
        }
        else if ([session.track isEqualToString:@"Core Conversations"]) {
            [cell.trackImageView setImage:[UIImage imageNamed:@"core.png"]];
        }
        else if ([session.track isEqualToString:@"Business Showcase"]) {
            [cell.trackImageView setImage:[UIImage imageNamed:@"showcase.png"]];
        }

        if (![session.track isEqualToString:@""]) {
            cell.trackTitle.text = session.track;
        }
        
        [cell.favButton addTarget:self
                           action:@selector(addEventToFavorites:)
            forControlEvents:UIControlEventTouchDown];

        if ([session.fav isEqualToNumber:[NSNumber numberWithInt:1]]) {
            cell.favButton.selected = YES;
        }
        else {
            cell.favButton.selected = NO;
        }

        return cell;
    }
    else {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.backgroundColor = [UIColor clearColor];
        UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 46)];
        containerView.backgroundColor = TIME_SLOT_ITEM;
        [cell.contentView addSubview:containerView];

        UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, 280, 20)];
        titleView.font = [DCLRegularFont sharedInstance];
        titleView.textColor = [UIColor whiteColor];
        titleView.text = [NSString stringWithFormat:@"%@", session.title];
        titleView.backgroundColor = [UIColor clearColor];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.contentView addSubview:titleView];
        [cell setUserInteractionEnabled:NO];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    int page = _innerScrollView.contentOffset.x / _innerScrollView.frame.size.width;
    if (page == 0) {
        _innerScrollView.frame = CGRectMake(_innerScrollView.frame.origin.x, _innerScrollView.frame.origin.y, _innerScrollView.frame.size.width, _day1.contentSize.height);
        _innerScrollView.contentSize = CGSizeMake(320 * 5, _innerScrollView.frame.size.height);
        _outerScrollView.contentSize = CGSizeMake(320, _day1.contentSize.height + 10);
    }
    else if (page == 1) {
        _innerScrollView.frame = CGRectMake(_innerScrollView.frame.origin.x, _innerScrollView.frame.origin.y, _innerScrollView.frame.size.width, _day2.contentSize.height);
        _innerScrollView.contentSize = CGSizeMake(320 * 5, _innerScrollView.frame.size.height);
        _outerScrollView.contentSize = CGSizeMake(320, _day2.contentSize.height + 10);
    }
    else if (page == 2) {
        _innerScrollView.frame = CGRectMake(_innerScrollView.frame.origin.x, _innerScrollView.frame.origin.y, _innerScrollView.frame.size.width, _day3.contentSize.height);
        _innerScrollView.contentSize = CGSizeMake(320 * 5, _innerScrollView.frame.size.height);
        _outerScrollView.contentSize = CGSizeMake(320, _day3.contentSize.height + 10);
    }
    else if (page == 3) {
        _innerScrollView.frame = CGRectMake(_innerScrollView.frame.origin.x, _innerScrollView.frame.origin.y, _innerScrollView.frame.size.width, _day4.contentSize.height);
        _innerScrollView.contentSize = CGSizeMake(320 * 5, _innerScrollView.frame.size.height);
        _outerScrollView.contentSize = CGSizeMake(320, _day4.contentSize.height + 10);
    }
    else if (page == 4) {
        _innerScrollView.frame = CGRectMake(_innerScrollView.frame.origin.x, _innerScrollView.frame.origin.y, _innerScrollView.frame.size.width, _day5.contentSize.height);
        _innerScrollView.contentSize = CGSizeMake(320 * 5, _innerScrollView.frame.size.height);
        _outerScrollView.contentSize = CGSizeMake(320, _day5.contentSize.height + 10);
    }


    Session *session;
    if(tableView == _day1) {
        session = [self.firstFetchedResultsController objectAtIndexPath:indexPath];
    }
    else if(tableView == _day2) {
        session = [self.secondFetchedResultsController objectAtIndexPath:indexPath];
    }
    else if(tableView == _day3) {
        session = [self.thirdFetchedResultsController objectAtIndexPath:indexPath];
    }
    else if(tableView == _day4) {
        session = [self.fourthFetchedResultsController objectAtIndexPath:indexPath];
    }
    else if(tableView == _day5) {
        session = [self.fifthFetchedResultsController objectAtIndexPath:indexPath];
    }
    
    if ([session.special integerValue] == 0) {
        return 98;
    }
    else {
        return 50;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == _innerScrollView) {
        int page = _innerScrollView.contentOffset.x / _innerScrollView.frame.size.width;
        if (page == 0) {
            _innerScrollView.frame = CGRectMake(_innerScrollView.frame.origin.x, _innerScrollView.frame.origin.y, _innerScrollView.frame.size.width, _day1.contentSize.height);
            _outerScrollView.contentSize = CGSizeMake(320, _day1.contentSize.height + 10);
        }
        else if (page == 1) {
            _innerScrollView.frame = CGRectMake(_innerScrollView.frame.origin.x, _innerScrollView.frame.origin.y, _innerScrollView.frame.size.width, _day2.contentSize.height);
            _outerScrollView.contentSize = CGSizeMake(320, _day2.contentSize.height + 10);
        }
        else if (page == 2) {
            _innerScrollView.frame = CGRectMake(_innerScrollView.frame.origin.x, _innerScrollView.frame.origin.y, _innerScrollView.frame.size.width, _day3.contentSize.height);
            _outerScrollView.contentSize = CGSizeMake(320, _day3.contentSize.height + 10);
        }
        else if (page == 3) {
            _innerScrollView.frame = CGRectMake(_innerScrollView.frame.origin.x, _innerScrollView.frame.origin.y, _innerScrollView.frame.size.width, _day4.contentSize.height);
            _outerScrollView.contentSize = CGSizeMake(320, _day4.contentSize.height + 10);
        }
        else if (page == 4) {
            _innerScrollView.frame = CGRectMake(_innerScrollView.frame.origin.x, _innerScrollView.frame.origin.y, _innerScrollView.frame.size.width, _day5.contentSize.height);
            _outerScrollView.contentSize = CGSizeMake(320, _day5.contentSize.height + 10);
        }
        _innerScrollView.contentSize = CGSizeMake(320 * 5, _innerScrollView.frame.size.height);
    }
}





- (NSFetchedResultsController *)firstFetchedResultsController
{
   
    if (_firstFetchedResultsController != nil) {
        return _firstFetchedResultsController;
    }

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];

    NSEntityDescription *entity = [Session entityInManagedObjectContext:self.moc];

    [fetchRequest setEntity:entity];

    [fetchRequest setReturnsObjectsAsFaults:NO];

    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:[[NSSortDescriptor alloc] initWithKey:@"from" ascending:YES], [[NSSortDescriptor alloc] initWithKey:@"to" ascending:YES], [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES], nil];

    [fetchRequest setSortDescriptors:sortDescriptors];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"day == 23"];
    fetchRequest.predicate = predicate;

    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.moc sectionNameKeyPath:@"day" cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.firstFetchedResultsController = aFetchedResultsController;

	NSError *error = nil;
	if (![self.firstFetchedResultsController performFetch:&error]) {
        abort();
	}
 
    return _firstFetchedResultsController;
}

- (NSFetchedResultsController *)secondFetchedResultsController
{

    if (_secondFetchedResultsController != nil) {
        return _secondFetchedResultsController;
    }

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];

    NSEntityDescription *entity = [Session entityInManagedObjectContext:self.moc];

    [fetchRequest setEntity:entity];

    [fetchRequest setReturnsObjectsAsFaults:NO];

    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:[[NSSortDescriptor alloc] initWithKey:@"from" ascending:YES], [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES], nil];

    [fetchRequest setSortDescriptors:sortDescriptors];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"day == 24"];
    fetchRequest.predicate = predicate;

    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.moc sectionNameKeyPath:@"day" cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.secondFetchedResultsController = aFetchedResultsController;

	NSError *error = nil;
	if (![self.secondFetchedResultsController performFetch:&error]) {
        abort();
	}

    return _secondFetchedResultsController;
}

- (NSFetchedResultsController *)thirdFetchedResultsController
{

    if (_thirdFetchedResultsController != nil) {
        return _thirdFetchedResultsController;
    }

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];

    NSEntityDescription *entity = [Session entityInManagedObjectContext:self.moc];

    [fetchRequest setEntity:entity];

    [fetchRequest setReturnsObjectsAsFaults:NO];

    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:[[NSSortDescriptor alloc] initWithKey:@"from" ascending:YES], [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES], nil];

    [fetchRequest setSortDescriptors:sortDescriptors];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"day == 25"];
    fetchRequest.predicate = predicate;

    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.moc sectionNameKeyPath:@"day" cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.thirdFetchedResultsController = aFetchedResultsController;

	NSError *error = nil;
	if (![self.thirdFetchedResultsController performFetch:&error]) {
        abort();
	}

    return _thirdFetchedResultsController;
}

- (NSFetchedResultsController *)fourthFetchedResultsController
{

    if (_fourthFetchedResultsController != nil) {
        return _fourthFetchedResultsController;
    }

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];

    NSEntityDescription *entity = [Session entityInManagedObjectContext:self.moc];

    [fetchRequest setEntity:entity];

    [fetchRequest setReturnsObjectsAsFaults:NO];

    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:[[NSSortDescriptor alloc] initWithKey:@"from" ascending:YES], [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES], nil];

    [fetchRequest setSortDescriptors:sortDescriptors];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"day == 26"];
    fetchRequest.predicate = predicate;

    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.moc sectionNameKeyPath:@"day" cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fourthFetchedResultsController = aFetchedResultsController;

	NSError *error = nil;
	if (![self.fourthFetchedResultsController performFetch:&error]) {
        abort();
	}

    return _fourthFetchedResultsController;
}

- (NSFetchedResultsController *)fifthFetchedResultsController
{

    if (_fifthFetchedResultsController != nil) {
        return _fifthFetchedResultsController;
    }

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];

    NSEntityDescription *entity = [Session entityInManagedObjectContext:self.moc];

    [fetchRequest setEntity:entity];

    [fetchRequest setReturnsObjectsAsFaults:NO];

    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:[[NSSortDescriptor alloc] initWithKey:@"from" ascending:YES], [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES], nil];

    [fetchRequest setSortDescriptors:sortDescriptors];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"day == 27"];
    fetchRequest.predicate = predicate;

    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.moc sectionNameKeyPath:@"day" cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fifthFetchedResultsController = aFetchedResultsController;

	NSError *error = nil;
	if (![self.fifthFetchedResultsController performFetch:&error]) {
        abort();
	}

    return _fifthFetchedResultsController;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Session *session;
    if(tableView == _day1) {
        session = [self.firstFetchedResultsController objectAtIndexPath:indexPath];
    }
    else if(tableView == _day2) {
        session = [self.secondFetchedResultsController objectAtIndexPath:indexPath];
    }
    else if(tableView == _day3) {
        session = [self.thirdFetchedResultsController objectAtIndexPath:indexPath];
    }
    else if(tableView == _day4) {
        session = [self.fourthFetchedResultsController objectAtIndexPath:indexPath];
    }
    else if(tableView == _day5) {
        session = [self.fifthFetchedResultsController objectAtIndexPath:indexPath];
    }

    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    DCLSessionViewController *detail = [[DCLSessionViewController alloc] initWithNibName:nil bundle:NULL];
    detail.title = session.title;
    detail.session = session;
    detail.moc = self.moc;
    [self.navigationController pushViewController:detail animated:YES];

}

-(void)viewWillAppear:(BOOL) animated {

    int count = [Session countWithManagedObjectContext:self.moc];

    if (count == 0) {
        _hud = [MBProgressHUD showHUDAddedTo:self.parentViewController.parentViewController.view animated:YES];
        _hud.dimBackground = YES;
        _hud.mode = MBProgressHUDModeIndeterminate;
        [_hud setLabelText:@"Downloading..."];
        [[DCLAPIClient sharedInstance] getPath:@"timeslots/list.json" parameters:nil
                                       success:^(AFHTTPRequestOperation *operation, id response) {
                                           [self parseEvents:response];
                                       }
                                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                           [_hud hide:YES];
                                           [[[UIAlertView alloc] initWithTitle:@"Error!"
                                                                       message:@"Could not download data."
                                                                      delegate:nil
                                                             cancelButtonTitle:@"OK"
                                                             otherButtonTitles:nil] show];
                                       }];
    
    }
    else {

        _day1.tableHeaderView = [self addTableViewHeaderDay1];
        _day2.tableHeaderView = [self addTableViewHeaderDay2];
        _day3.tableHeaderView = [self addTableViewHeaderDay3];
        _day4.tableHeaderView = [self addTableViewHeaderDay4];
        _day5.tableHeaderView = [self addTableViewHeaderDay5];

        [_day1 reloadData];
        [_day2 reloadData];
        [_day3 reloadData];
        [_day4 reloadData];
        [_day5 reloadData];

        
    }
}

- (void)parseEvents:(id)sessions {

    [_hud setMode:MBProgressHUDModeDeterminate];
    [_hud setProgress:0];
    [_hud setLabelText:@"Importing"];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSInteger totalRecords = [sessions count];
        NSInteger currentRecord = 0;
        
        
        NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
        [context setPersistentStoreCoordinator:[[SessionsDataModel sharedDataModel] persistentStoreCoordinator]];

        for (NSDictionary *dictionary in sessions) {

            Speaker *speaker = nil;
            NSMutableSet *speakers = [[NSMutableSet alloc] init];

            for (NSDictionary *speakerDictionary in [dictionary objectForKey:@"speakers"]) {
                NSInteger userId = [[speakerDictionary objectForKey:@"id"] intValue];
                speaker = [Speaker speakerWithServerId:userId usingManagedObjectContext:context];
                if (speaker == nil) {
                    speaker = [Speaker insertInManagedObjectContext:context];
                    [speaker setServerId:[NSNumber numberWithInteger:userId]];
                }
                [speaker updateAttributes:speakerDictionary];
                [speakers addObject:speaker];
            }
            
            NSInteger serverId = [[dictionary objectForKey:@"id"] intValue];
            Session *session = [Session eventWithServerId:serverId usingManagedObjectContext:context];
            if (session == nil) {
                session = [Session insertInManagedObjectContext:context];
                [session setServerId:[NSNumber numberWithInteger:serverId]];
            }

            [session updateAttributes:dictionary withSpeakers:speakers];

            currentRecord++;

            dispatch_async(dispatch_get_main_queue(), ^{
                float percent = ((float)currentRecord)/totalRecords;
                [_hud setProgress:percent];
            });
        }

        NSError *error = nil;
        if ([context save:&error]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_hud setLabelText:@"Done!"];
                [_hud hide:YES afterDelay:2.0];
                _day1.tableHeaderView = [self addTableViewHeaderDay1];
                _day2.tableHeaderView = [self addTableViewHeaderDay2];
                _day3.tableHeaderView = [self addTableViewHeaderDay3];
                _day4.tableHeaderView = [self addTableViewHeaderDay4];
                _day5.tableHeaderView = [self addTableViewHeaderDay5];

                [self.firstFetchedResultsController performFetch:nil];
                [self.secondFetchedResultsController performFetch:nil];
                [self.thirdFetchedResultsController performFetch:nil];
                [self.fourthFetchedResultsController performFetch:nil];
                [self.fifthFetchedResultsController performFetch:nil];

                [_day1 reloadData];
                [_day2 reloadData];
                [_day3 reloadData];
                [_day4 reloadData];
                [_day5 reloadData];

            });
        } else {
            NSLog(@"ERROR: %@ %@", [error localizedDescription], [error userInfo]);
            exit(1);
        }
    });
    
}

- (void)addEventToFavorites:(UIButton*)sender
{
    CGPoint buttonPosition = CGPointZero;

    NSIndexPath *indexPath = nil;
    
    buttonPosition = [sender convertPoint:CGPointZero toView:_day1];
    indexPath = [_day1 indexPathForRowAtPoint:buttonPosition];
    if (indexPath != nil)
    {
        NSInteger serverId = [[[self.firstFetchedResultsController objectAtIndexPath:indexPath] serverId] intValue];
        Session *session = [Session eventWithServerId:serverId usingManagedObjectContext:self.moc];
        bool status;
        if ([session.fav isEqualToNumber:[NSNumber numberWithInt:1]]) {
            status = NO;
        }
        else {
            status = YES;
        }
        sender.selected = status;
        [session toggleFavorite:status];
        [[self.firstFetchedResultsController objectAtIndexPath:indexPath] toggleFavorite:status];
        [self.moc save:nil];

    }

    buttonPosition = [sender convertPoint:CGPointZero toView:_day2];
    indexPath = [_day2 indexPathForRowAtPoint:buttonPosition];
    if (indexPath != nil)
    {
        NSInteger serverId = [[[self.secondFetchedResultsController objectAtIndexPath:indexPath] serverId] intValue];
        Session *session = [Session eventWithServerId:serverId usingManagedObjectContext:self.moc];
        bool status;
        if ([session.fav isEqualToNumber:[NSNumber numberWithInt:1]]) {
            status = NO;
        }
        else {
            status = YES;
        }
        sender.selected = status;
        [session toggleFavorite:status];
        [[self.secondFetchedResultsController objectAtIndexPath:indexPath] toggleFavorite:status];
        [self.moc save:nil];

    }

    buttonPosition = [sender convertPoint:CGPointZero toView:_day3];
    indexPath = [_day3 indexPathForRowAtPoint:buttonPosition];
    if (indexPath != nil)
    {
        NSInteger serverId = [[[self.thirdFetchedResultsController objectAtIndexPath:indexPath] serverId] intValue];
        Session *session = [Session eventWithServerId:serverId usingManagedObjectContext:self.moc];
        bool status;
        if ([session.fav isEqualToNumber:[NSNumber numberWithInt:1]]) {
            status = NO;
        }
        else {
            status = YES;
        }
        sender.selected = status;
        [session toggleFavorite:status];
        [[self.thirdFetchedResultsController objectAtIndexPath:indexPath] toggleFavorite:status];
        [self.moc save:nil];

    }

    buttonPosition = [sender convertPoint:CGPointZero toView:_day4];
    indexPath = [_day4 indexPathForRowAtPoint:buttonPosition];
    if (indexPath != nil)
    {
        NSInteger serverId = [[[self.fourthFetchedResultsController objectAtIndexPath:indexPath] serverId] intValue];
        Session *session = [Session eventWithServerId:serverId usingManagedObjectContext:self.moc];
        bool status;
        if ([session.fav isEqualToNumber:[NSNumber numberWithInt:1]]) {
            status = NO;
        }
        else {
            status = YES;
        }
        sender.selected = status;
        [session toggleFavorite:status];
        [[self.fourthFetchedResultsController objectAtIndexPath:indexPath] toggleFavorite:status];
        [self.moc save:nil];

    }

    buttonPosition = [sender convertPoint:CGPointZero toView:_day5];
    indexPath = [_day5 indexPathForRowAtPoint:buttonPosition];
    if (indexPath != nil)
    {
        NSInteger serverId = [[[self.fifthFetchedResultsController objectAtIndexPath:indexPath] serverId] intValue];
        Session *session = [Session eventWithServerId:serverId usingManagedObjectContext:self.moc];
        bool status;
        if ([session.fav isEqualToNumber:[NSNumber numberWithInt:1]]) {
            status = NO;
        }
        else {
            status = YES;
        }
        sender.selected = status;
        [session toggleFavorite:status];
        [[self.fifthFetchedResultsController objectAtIndexPath:indexPath] toggleFavorite:status];
        [self.moc save:nil];

    }
}




@end
