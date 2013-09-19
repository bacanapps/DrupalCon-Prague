//
//  DCLUIViewController.m
//  DrupalCamp Leuven
//
//  Created by Tim Leytens on 11/08/13.
//  Copyright (c) 2013 Tim Leytens. All rights reserved.
//

#import "DCLUIViewController.h"

#import "DCLFavoritesViewController.h"
#import "DCLNavigationBar.h"


#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface DCLUIViewController () 

@end

@implementation DCLUIViewController

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

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tile.png"]];

    self.navigationItem.rightBarButtonItem = [self showFavoritesButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIBarButtonItem *)showFavoritesButton {
    UIImage *favButtonImage = [UIImage imageNamed:@"fav_top.png"];
    UIImage *favButtonImageActive = [UIImage imageNamed:@"fav_top.png"];
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
    
     DCLFavoritesViewController *favoritesViewController = [[DCLFavoritesViewController alloc] init];
     UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:favoritesViewController];
    [navController setValue:[[DCLNavigationBar alloc]init] forKeyPath:@"navigationBar"];
     [self presentModalViewController:navController animated:YES];
     
}

@end
