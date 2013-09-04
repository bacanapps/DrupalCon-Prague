//
//  DCLAgendaViewController.h
//  DrupalCamp Leuven
//
//  Created by Tim Leytens on 20/07/13.
//  Copyright (c) 2013 Tim Leytens. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "DCLUIViewController.h"


@interface DCLAgendaViewController : DCLUIViewController <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *outerScrollView;

@property (strong, nonatomic) IBOutlet UIScrollView *innerScrollView;

@property (strong, nonatomic) IBOutlet UITableView *day1;

@property (strong, nonatomic) IBOutlet UITableView *day2;

@property (strong, nonatomic) NSFetchedResultsController *firstFetchedResultsController;

@property (strong, nonatomic) NSFetchedResultsController *secondFetchedResultsController;

@end
