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
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
    _day1.tableHeaderView = headerView;

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
        if ([[self.firstFetchedResultsController sections] count] == 0) {
            return 0;
        }
        else {
            id <NSFetchedResultsSectionInfo> sectionInfo = [self.firstFetchedResultsController sections][section];
            return [sectionInfo numberOfObjects];
        }
            
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    Speaker *speaker;
    speaker = [self.firstFetchedResultsController objectAtIndexPath:indexPath];
    
    
    static NSString *CellIdentifier = @"customCell";
    DCLSpeakerCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    cell.speakerName.text = speaker.username; 

    if (speaker.firstName || speaker.lastName) {
        if (!speaker.firstName) {
            speaker.firstName = @"";
        }

        if (!speaker.lastName) {
            speaker.lastName = @"";
        }

        cell.userName.text = [[NSString stringWithFormat:@"%@ %@", speaker.firstName, speaker.lastName] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    cell.company.text = speaker.company;

    [cell.avatar setImageWithURL:[NSURL URLWithString:speaker.avatar] placeholderImage:[UIImage imageNamed:@"avatar.png"]];

    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    _scrollView.frame = CGRectMake(_scrollView.frame.origin.x, _scrollView.frame.origin.y, 320, _day1.contentSize.height + 5);
    _scrollView.contentSize = CGSizeMake(320, _scrollView.frame.size.height);
    _outerScrollView.contentSize = CGSizeMake(320, _day1.contentSize.height + 10);


    return 85;
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

    NSSortDescriptor *sortSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"username" ascending:YES];

    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortSortDescriptor, nil];

    [fetchRequest setSortDescriptors:sortDescriptors];

    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.firstFetchedResultsController = aFetchedResultsController;

	NSError *error = nil;
	if (![self.firstFetchedResultsController performFetch:&error]) {
        abort();
	}

    return _firstFetchedResultsController;
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
        [self.firstFetchedResultsController performFetch:nil];

        [_day1 reloadData];

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
                Speaker *speaker = [Speaker speakerWithServerId:userId usingManagedObjectContext:context];
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
                [self.firstFetchedResultsController performFetch:nil];

                [_day1 reloadData];

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
    speaker = [self.firstFetchedResultsController objectAtIndexPath:indexPath];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    DCLSpeakerViewController *detail = [[DCLSpeakerViewController alloc] initWithNibName:nil bundle:NULL];
    detail.title = speaker.username;
    detail.speaker = speaker;
    [self.navigationController pushViewController:detail animated:YES];

}

@end
