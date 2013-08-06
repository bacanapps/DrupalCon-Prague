//
//  DCLAgendaViewController.h
//  DrupalCamp Leuven
//
//  Created by Tim Leytens on 20/07/13.
//  Copyright (c) 2013 Tim Leytens. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DCLAgendaViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UIScrollView *outerScrollView;

@property (strong, nonatomic) IBOutlet UIScrollView *innerScrollView;

@property (strong, nonatomic) IBOutlet UITableView *day1;

@property (strong, nonatomic) IBOutlet UITableView *day2;

@end
