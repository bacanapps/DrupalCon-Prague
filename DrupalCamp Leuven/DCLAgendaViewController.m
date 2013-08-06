//
//  DCLAgendaViewController.m
//  DrupalCamp Leuven
//
//  Created by Tim Leytens on 20/07/13.
//  Copyright (c) 2013 Tim Leytens. All rights reserved.
//

#import "DCLAgendaViewController.h"

#import "DCLSessionCell.h"

#import "DCLLightFont.h"
#import "DCLBoldFont.h"

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface DCLAgendaViewController ()

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
    self.view.backgroundColor = UIColorFromRGB(0xf0f0f2);

    self.navigationItem.title = @"DRUPALCAMP";

    _outerScrollView.contentSize = CGSizeMake(320, 2000);
    _innerScrollView.frame = CGRectMake(_innerScrollView.frame.origin.x, _innerScrollView.frame.origin.y, _innerScrollView.frame.size.width, 2000);
    _innerScrollView.contentSize = CGSizeMake(640, _innerScrollView.frame.size.height);

    _day1.tableHeaderView = [self addTableViewHeaderDay1];
    _day2.tableHeaderView = [self addTableViewHeaderDay2];

    self.navigationItem.rightBarButtonItem = [self showFavoritesButton];

    [_day1 registerClass:[DCLSessionCell class] forCellReuseIdentifier:@"customCell"];
    [_day2 registerClass:[DCLSessionCell class] forCellReuseIdentifier:@"customCell"];

}

- (UIBarButtonItem *)showFavoritesButton {
    UIImage *favButtonImage = [UIImage imageNamed:@"fav.png"];
    UIImage *favButtonImageActive = [UIImage imageNamed:@"fav.png"];
    UIButton *favButton = [UIButton buttonWithType:UIButtonTypeCustom];

    [favButton setBackgroundImage:favButtonImage forState:UIControlStateNormal];
    [favButton setBackgroundImage:favButtonImageActive forState:UIControlStateHighlighted];

    [favButton setFrame:CGRectMake(0, 1, favButtonImage.size.width, favButtonImage.size.height)];

    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, favButtonImage.size.width, favButtonImage.size.height)];

    [favButton addTarget:self
                  action:@selector(openFavoritesView:)
        forControlEvents:UIControlEventTouchDown];

    [containerView addSubview:favButton];

    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:containerView];
    return item;
}


- (void)openFavoritesView:(id)sender {
    /*
    UIViewController *favoritesViewController = [[UIViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:favoritesViewController];
    [self presentModalViewController:navController animated:YES];
     */
}


-(UIView *)addTableViewHeaderDay1 {
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width , 65)];

    UIView *borderTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width , 1)];
    borderTop.backgroundColor = UIColorFromRGB(0xdcdcdc);

    UIView *borderBottom = [[UIView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width , 1)];
    borderBottom.backgroundColor = UIColorFromRGB(0xdcdcdc);

    [containerView addSubview:borderTop];
    [containerView addSubview:borderBottom];

    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    headerLabel.font = [DCLLightFont sharedInstance];
    headerLabel.text = @"14 SEPTEMBER 2013";
    headerLabel.textColor = UIColorFromRGB(0x4b4745);
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.backgroundColor = [UIColor clearColor];

    UIImage *arrow = [UIImage imageNamed:@"arrow-right.png"];
    UIImageView *arrowView = [[UIImageView alloc] initWithImage:arrow];
    arrowView.frame = CGRectMake(containerView.frame.size.width - 20 - arrowView.frame.size.width, (50 - arrowView.frame.size.height) / 2, arrowView.frame.size.width, arrowView.frame.size.height);
    [containerView addSubview:arrowView];
    
    [containerView addSubview:headerLabel];

    return containerView;
}

-(UIView *)addTableViewHeaderDay2 {

    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width , 65)];

    UIView *borderTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width , 1)];
    borderTop.backgroundColor = UIColorFromRGB(0xdcdcdc);

    UIView *borderBottom = [[UIView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width , 1)];
    borderBottom.backgroundColor = UIColorFromRGB(0xdcdcdc);

    [containerView addSubview:borderTop];
    [containerView addSubview:borderBottom];

    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    headerLabel.font = [DCLLightFont sharedInstance];
    headerLabel.text = @"15 SEPTEMBER 2013";
    headerLabel.textColor = UIColorFromRGB(0x4b4745);
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.backgroundColor = [UIColor clearColor];

    UIImage *arrow = [UIImage imageNamed:@"arrow-left.png"];
    UIImageView *arrowView = [[UIImageView alloc] initWithImage:arrow];
    arrowView.frame = CGRectMake(0, (50 - arrowView.frame.size.height) / 2, arrowView.frame.size.width, arrowView.frame.size.height);
    [containerView addSubview:arrowView];

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
    if(tableView == _day1)
        return 24;
    else 
        return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.row != 2) {
        static NSString *CellIdentifier = @"customCell";
        DCLSessionCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

        cell.sessionTitle.text = @"Hier komt de naam van de sessie";
        cell.speakerName.text = @"Naam van de spreker";
        cell.timeSlot.text = @"11u30 - 12u30";

        return cell;
    }
    else {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 46)];
        containerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cell-blue.png"]];
        [cell.contentView addSubview:containerView];

        UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, 280, 20)];
        titleView.font = [DCLBoldFont sharedInstance];
        titleView.textColor = [UIColor whiteColor];
        titleView.text = @"Coffeebreak";
        titleView.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:titleView];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != 2) {
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
            _innerScrollView.frame = CGRectMake(_innerScrollView.frame.origin.x, _innerScrollView.frame.origin.y, _innerScrollView.frame.size.width, 3000);
            _outerScrollView.contentSize = CGSizeMake(320, 3000);
        }
        else {
            _innerScrollView.frame = CGRectMake(_innerScrollView.frame.origin.x, _innerScrollView.frame.origin.y, _innerScrollView.frame.size.width, 3000);
            _outerScrollView.contentSize = CGSizeMake(320, 3000);
        }
        _innerScrollView.contentSize = CGSizeMake(640, _innerScrollView.frame.size.height);
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}



@end
