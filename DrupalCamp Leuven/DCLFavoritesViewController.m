//
//  DCLFavoritesViewController.m
//  DrupalCamp
//
//  Created by Tim Leytens on 30/08/13.
//  Copyright (c) 2013 Tim Leytens. All rights reserved.
//

#import "DCLFavoritesViewController.h"
#import "DCLSessionCell.h"
#import "DCLLightFont.h"
#import "DCLRegularFont.h"
#import "SessionsDataModel.h"
#import "Session.h"
#import "DCLSessionViewController.h"

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@interface DCLFavoritesViewController ()

@property (nonatomic, strong) NSManagedObjectContext *moc;

@end

@implementation DCLFavoritesViewController

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
	// Do any additional setup after loading the view.

    self.view.backgroundColor = APP_BACKGROUND_COLOR;

    self.navigationItem.rightBarButtonItem = [self showCloseFavoritesButton];

    self.navigationItem.title = @"FAVORITES";
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20, self.view.frame.size.height - 20 - 44)];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[DCLSessionCell class] forCellReuseIdentifier:@"customCell"];

    [self.view addSubview:_tableView];

    self.moc = [[NSManagedObjectContext alloc] init];
    [self.moc setPersistentStoreCoordinator:[[SessionsDataModel sharedDataModel] persistentStoreCoordinator]];
    [self.moc setMergePolicy:NSMergeByPropertyStoreTrumpMergePolicy];

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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if ([[self.fetchedResultsController sections] count] == 0) {
        return 30;
    }
    else {
        return 98;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[self.fetchedResultsController sections] count] == 0) {
        return 1;
    }
    else {
        id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
        return [sectionInfo numberOfObjects];
    }

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([[self.fetchedResultsController sections] count] == 0) {
        return 1;
    }
    else {
        return [[self.fetchedResultsController sections] count];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    if ([[self.fetchedResultsController sections] count] == 0) {
        return nil;
    }

    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];

    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 20 , 50)];
    containerView.backgroundColor = APP_BACKGROUND_COLOR;

    UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width , 9)];
    maskView.backgroundColor = APP_BACKGROUND_COLOR;

    UIView *borderTop = [[UIView alloc] initWithFrame:CGRectMake(0, 9, self.view.frame.size.width , 1)];
    borderTop.backgroundColor = APP_BACKGROUND_COLOR;

   

    [containerView addSubview:maskView];
    [containerView addSubview:borderTop];

    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, containerView.frame.size.width, 50)];
    headerLabel.font = [UIFont fontWithName:@"PT Sans Narrow" size:20.0];
    headerLabel.text = [NSString stringWithFormat:@"%@TH SEPTEMBER 2013", [sectionInfo name]];
    headerLabel.textColor = UIColorFromRGB(0x4b4745);
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.backgroundColor = FAVORITES_BACKGROUND_COLOR;

    [containerView addSubview:headerLabel];
    
    return containerView;
}

-(float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([[self.fetchedResultsController sections] count] == 0) {
        return 0;
    }
    else {
        return 65.0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Session *session = [self.fetchedResultsController objectAtIndexPath:indexPath];

    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    DCLSessionViewController *detail = [[DCLSessionViewController alloc] initWithNibName:nil bundle:NULL];
    detail.title = session.title;
    detail.session = session;
    detail.moc = self.moc;
    detail.calledInModalViewController = YES;
    [self.navigationController pushViewController:detail animated:YES];

}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];

    NSEntityDescription *entity = [Session entityInManagedObjectContext:self.moc];

    [fetchRequest setEntity:entity];

    [fetchRequest setReturnsObjectsAsFaults:NO];

    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:[[NSSortDescriptor alloc] initWithKey:@"from" ascending:YES], [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES], nil];

    [fetchRequest setSortDescriptors:sortDescriptors];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"fav == 1"];
    fetchRequest.predicate = predicate;

    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.moc sectionNameKeyPath:@"day" cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;

	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
        abort();
	}
    return _fetchedResultsController;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if ([[self.fetchedResultsController sections] count] == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];

        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, 50)];
        label.font = [DCLLightFont sharedInstance];
        label.text = @"NO FAVORITES YET";
        label.textColor = UIColorFromRGB(0x4b4745);
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];

        [cell.contentView addSubview:label];

        return cell;
    }

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"H:mm"];

    Session *session = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    static NSString *CellIdentifier = @"customCell";
    DCLSessionCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    cell.sessionTitle.text = session.title;

    NSMutableArray *speakers = [[NSMutableArray alloc] init];

    for (Speaker *speaker in session.speaker) {
        [speakers addObject:speaker.username];
    }

    cell.speakerName.text = [speakers componentsJoinedByString:@", "];
    
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


- (void)dismissModal:(id)button
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ModalViewControllerDismissed"
                                                        object:nil
                                                      userInfo:nil];
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)addEventToFavorites:(UIButton*)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    if (indexPath != nil)
    {

        NSInteger serverId = [[[self.fetchedResultsController objectAtIndexPath:indexPath] serverId] intValue];
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
        [[self.fetchedResultsController objectAtIndexPath:indexPath] toggleFavorite:status];
        [self.moc save:nil];
        [self.fetchedResultsController performFetch:nil];
        [_tableView reloadData];
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
