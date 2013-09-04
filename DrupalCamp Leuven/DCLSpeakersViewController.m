//
//  DCLSpeakersViewController.m
//  DrupalCamp Leuven
//
//  Created by Tim Leytens on 20/07/13.
//  Copyright (c) 2013 Tim Leytens. All rights reserved.
//

#import "DCLSpeakersViewController.h"
#import "DCLSpeakerCell.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"

#import "DCLLightFont.h"
#import "DCLBoldFont.h"
#import "SessionsDataModel.h"
#import "Speaker.h"
#import "Session.h"
#import "DCLAPIClient.h"
#import "DCLSpeakerViewController.h"

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@interface DCLSpeakersViewController () {
    MBProgressHUD *_hud;
}

@end

@implementation DCLSpeakersViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {

        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil
                                                        image:nil
                                                          tag:0];

        [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"speakersButton.png"]
                      withFinishedUnselectedImage:[UIImage imageNamed:@"speakersButton.png"]];

        self.tabBarItem.imageInsets = UIEdgeInsetsMake(4, 0, -4, 0);

    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

	self.navigationItem.title = @"SPEAKERS";

    [_day1 registerClass:[DCLSpeakerCell class] forCellReuseIdentifier:@"customCell"];
    [_day2 registerClass:[DCLSpeakerCell class] forCellReuseIdentifier:@"customCell"];

}

-(UIView *)addTableViewHeaderDay1 {

    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 20 , 65)];

    UIView *borderTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width , 1)];
    borderTop.backgroundColor = UIColorFromRGB(0xdcdcdc);

    UIView *borderBottom = [[UIView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width , 1)];
    borderBottom.backgroundColor = UIColorFromRGB(0xdcdcdc);

    [containerView addSubview:borderTop];
    [containerView addSubview:borderBottom];

    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, containerView.frame.size.width, 50)];
    headerLabel.font = [DCLLightFont sharedInstance];
    headerLabel.text = @"14TH SEPTEMBER 2013";
    headerLabel.textColor = UIColorFromRGB(0x4b4745);
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.backgroundColor = [UIColor clearColor];

    UIImage *arrowButtonRightImage = [UIImage imageNamed:@"arrow-right.png"];
    UIButton *arrowButtonRight = [UIButton buttonWithType:UIButtonTypeCustom];

    [arrowButtonRight setBackgroundImage:arrowButtonRightImage forState:UIControlStateNormal];
    [arrowButtonRight setBackgroundImage:arrowButtonRightImage forState:UIControlStateHighlighted];

    [arrowButtonRight setFrame:CGRectMake(containerView.frame.size.width - arrowButtonRightImage.size.width - 5, (50 - arrowButtonRightImage.size.height) / 2 + 1, arrowButtonRightImage.size.width, arrowButtonRightImage.size.height)];

    [arrowButtonRight setTag:1];
    [arrowButtonRight addTarget:self
                         action:@selector(switchScrollView:)
               forControlEvents:UIControlEventTouchDown];

    [containerView addSubview:arrowButtonRight];


    [containerView addSubview:headerLabel];

    return containerView;
}

-(UIView *)addTableViewHeaderDay2 {

    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 20, 65)];

    UIView *borderTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width , 1)];
    borderTop.backgroundColor = UIColorFromRGB(0xdcdcdc);

    UIView *borderBottom = [[UIView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width , 1)];
    borderBottom.backgroundColor = UIColorFromRGB(0xdcdcdc);

    [containerView addSubview:borderTop];
    [containerView addSubview:borderBottom];

    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, containerView.frame.size.width, 50)];
    headerLabel.font = [DCLLightFont sharedInstance];
    headerLabel.text = @"15TH SEPTEMBER 2013";
    headerLabel.textColor = UIColorFromRGB(0x4b4745);
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.backgroundColor = [UIColor clearColor];

    UIImage *arrowButtonLeftImage = [UIImage imageNamed:@"arrow-left.png"];
    UIButton *arrowButtonLeft = [UIButton buttonWithType:UIButtonTypeCustom];

    [arrowButtonLeft setBackgroundImage:arrowButtonLeftImage forState:UIControlStateNormal];
    [arrowButtonLeft setBackgroundImage:arrowButtonLeftImage forState:UIControlStateHighlighted];

    [arrowButtonLeft setFrame:CGRectMake(0 + 5, (50 - arrowButtonLeftImage.size.height) / 2 +1, arrowButtonLeftImage.size.width, arrowButtonLeftImage.size.height)];
    [arrowButtonLeft setTag:2];
    [arrowButtonLeft addTarget:self
                        action:@selector(switchScrollView:)
              forControlEvents:UIControlEventTouchDown];

    [containerView addSubview:arrowButtonLeft];
    
    
    [containerView addSubview:headerLabel];
    
    return containerView;
}

- (void)switchScrollView:(UIButton *)sender {
    if (sender.tag == 1) {
        CGRect frame = CGRectMake(320, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
        [_scrollView scrollRectToVisible:frame animated:YES];
        _scrollView.frame = CGRectMake(_scrollView.frame.origin.x, _scrollView.frame.origin.y, _scrollView.frame.size.width, _day2.contentSize.height + 5);
        _scrollView.contentSize = CGSizeMake(640, _scrollView.frame.size.height);
        _outerScrollView.contentSize = CGSizeMake(320, _day2.contentSize.height + 30);

    }
    else {
        CGRect frame = CGRectMake(0, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
        [_scrollView scrollRectToVisible:frame animated:YES];
        _scrollView.frame = CGRectMake(_scrollView.frame.origin.x, _scrollView.frame.origin.y, _scrollView.frame.size.width, _day1.contentSize.height + 5);
        _scrollView.contentSize = CGSizeMake(640, _scrollView.frame.size.height);
        _outerScrollView.contentSize = CGSizeMake(320, _day1.contentSize.height + 30);

    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    else {
        if ([[self.secondFetchedResultsController sections] count] == 0) {
            return 0;
        }
        else {
            id <NSFetchedResultsSectionInfo> sectionInfo = [self.secondFetchedResultsController sections][section];
            return [sectionInfo numberOfObjects];
        }
    }
     
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    Speaker *speaker;
    if(tableView == _day1) {
        speaker = [self.firstFetchedResultsController objectAtIndexPath:indexPath];
    }
    else {
        speaker = [self.secondFetchedResultsController objectAtIndexPath:indexPath];
    }
    
    static NSString *CellIdentifier = @"customCell";
    DCLSpeakerCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    cell.speakerName.text = [NSString stringWithFormat:@"%@ %@", speaker.firstName, speaker.lastName];

    cell.userName.text = speaker.username;
    cell.company.text = speaker.company;

    [cell.avatar setImageWithURL:[NSURL URLWithString:speaker.avatar] placeholderImage:[UIImage imageNamed:@"avatar.png"]];

    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    _scrollView.frame = CGRectMake(_scrollView.frame.origin.x, _scrollView.frame.origin.y, _scrollView.frame.size.width, _day1.contentSize.height + 5);
    _scrollView.contentSize = CGSizeMake(640, _scrollView.frame.size.height);
    _outerScrollView.contentSize = CGSizeMake(320, _day1.contentSize.height + 30);


    return 85;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == _scrollView) {
        int page = _scrollView.contentOffset.x / _scrollView.frame.size.width;
        if (page == 0) {
            _scrollView.frame = CGRectMake(_scrollView.frame.origin.x, _scrollView.frame.origin.y, _scrollView.frame.size.width, _day1.contentSize.height + 5);
            _outerScrollView.contentSize = CGSizeMake(320, _day1.contentSize.height + 30);

        }
        else {
            _scrollView.frame = CGRectMake(_scrollView.frame.origin.x, _scrollView.frame.origin.y, _scrollView.frame.size.width, _day2.contentSize.height + 5);
            _outerScrollView.contentSize = CGSizeMake(320, _day2.contentSize.height + 30);

        }
        _scrollView.contentSize = CGSizeMake(640, _scrollView.frame.size.height);
    }
}


- (NSFetchedResultsController *)firstFetchedResultsController
{

    if (_firstFetchedResultsController != nil) {
        return _firstFetchedResultsController;
    }

    NSManagedObjectContext *context = [[SessionsDataModel sharedDataModel] mainContext];

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];

    NSEntityDescription *entity = [Speaker entityInManagedObjectContext:context];

    [fetchRequest setEntity:entity];

    [fetchRequest setReturnsObjectsAsFaults:NO];

    NSSortDescriptor *sortSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];

    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortSortDescriptor, nil];

    [fetchRequest setSortDescriptors:sortDescriptors];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY session.day == 14"];
    fetchRequest.predicate = predicate;

    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
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

    NSManagedObjectContext *context = [[SessionsDataModel sharedDataModel] mainContext];

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];

    NSEntityDescription *entity = [Speaker entityInManagedObjectContext:context];

    [fetchRequest setEntity:entity];

    [fetchRequest setReturnsObjectsAsFaults:NO];

    NSSortDescriptor *sortSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];

    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortSortDescriptor, nil];

    [fetchRequest setSortDescriptors:sortDescriptors];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY session.day == 15"];
    fetchRequest.predicate = predicate;

    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.secondFetchedResultsController = aFetchedResultsController;

	NSError *error = nil;
	if (![self.secondFetchedResultsController performFetch:&error]) {
        abort();
	}
    
    return _secondFetchedResultsController;
}

-(void)viewWillAppear:(BOOL) animated {

    int count = [Session countWithManagedObjectContext:[[SessionsDataModel sharedDataModel] mainContext]];

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
                                                                       message:@"Kon programma niet downloaden."
                                                                      delegate:nil
                                                             cancelButtonTitle:@"OK"
                                                             otherButtonTitles:nil] show];
                                       }];

    }
    else {
        _day1.tableHeaderView = [self addTableViewHeaderDay1];
        _day2.tableHeaderView = [self addTableViewHeaderDay2];

        [self.firstFetchedResultsController performFetch:nil];
        [self.secondFetchedResultsController performFetch:nil];

        [_day1 reloadData];
        [_day2 reloadData];

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

            for (NSDictionary *speakerDictionary in [dictionary objectForKey:@"speakers"]) {
                NSInteger userId = [[speakerDictionary objectForKey:@"id"] intValue];
                Speaker *speaker = [Speaker speakerWithServerId:userId usingManagedObjectContext:context];
                if (speaker == nil) {
                    speaker = [Speaker insertInManagedObjectContext:context];
                    [speaker setServerId:[NSNumber numberWithInteger:userId]];
                }
                [speaker updateAttributes:speakerDictionary];
            }

            NSInteger serverId = [[dictionary objectForKey:@"id"] intValue];
            Session *session = [Session eventWithServerId:serverId usingManagedObjectContext:context];
            if (session == nil) {
                session = [Session insertInManagedObjectContext:context];
                [session setServerId:[NSNumber numberWithInteger:serverId]];
            }

            [session updateAttributes:dictionary withSpeaker:speaker];

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
                [self.firstFetchedResultsController performFetch:nil];
                [self.secondFetchedResultsController performFetch:nil];

                [_day1 reloadData];
                [_day2 reloadData];

            });
        } else {
            NSLog(@"ERROR: %@ %@", [error localizedDescription], [error userInfo]);
            exit(1);
        }
    });
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Speaker *speaker;
    if(tableView == _day1) {
        speaker = [self.firstFetchedResultsController objectAtIndexPath:indexPath];
    }
    else {
        speaker = [self.secondFetchedResultsController objectAtIndexPath:indexPath];
    }

    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    DCLSpeakerViewController *detail = [[DCLSpeakerViewController alloc] initWithNibName:nil bundle:NULL];
    detail.title = [NSString stringWithFormat:@"%@ %@", speaker.firstName, speaker.lastName];
    detail.speaker = speaker;
    [self.navigationController pushViewController:detail animated:YES];

}

@end
