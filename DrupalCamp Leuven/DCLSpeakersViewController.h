//
//  DCLSpeakersViewController.h
//  DrupalCamp Leuven
//
//  Created by Tim Leytens on 20/07/13.
//  Copyright (c) 2013 Tim Leytens. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "DCLUIViewController.h"


@interface DCLSpeakersViewController : DCLUIViewController <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITableView *day1;
@property (strong, nonatomic) IBOutlet UITableView *day2;
@property (strong, nonatomic) NSFetchedResultsController *firstFetchedResultsController;
@property (strong, nonatomic) NSFetchedResultsController *secondFetchedResultsController;
@property (strong, nonatomic) IBOutlet UIScrollView *outerScrollView;

@end
