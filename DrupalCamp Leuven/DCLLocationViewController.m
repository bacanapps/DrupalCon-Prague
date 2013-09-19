//
//  DCLLocationViewController.m
//  DrupalCamp Leuven
//
//  Created by Tim Leytens on 20/07/13.
//  Copyright (c) 2013 Tim Leytens. All rights reserved.
//

#import "DCLLocationViewController.h"
#import "DCLRegularFont.h"
#import "DCLBoldFont.h"
#import <MapKit/MapKit.h>
#import "DCLAnnotation.h"
#import <QuartzCore/QuartzCore.h>


#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )


@interface DCLLocationViewController () <MKMapViewDelegate>

@end

@implementation DCLLocationViewController 

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {

        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil
                                                        image:nil
                                                          tag:0];

        [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"locationButton.png"]
                      withFinishedUnselectedImage:[UIImage imageNamed:@"locationButton.png"]];

        self.tabBarItem.imageInsets = UIEdgeInsetsMake(4, 0, -4, 0);

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = @"LOCATION";

    _name.font = [DCLBoldFont sharedInstance];
    _name.textColor = UIColorFromRGB(0x4b4745);

    _subtitle.font = [UIFont fontWithName:@"OpenSans" size:11.0];
    _subtitle.textColor = UIColorFromRGB(0x4b4745);

    _address.font = [DCLRegularFont sharedInstance];
    _address.textColor = UIColorFromRGB(0x4b4745);

    _phone.font = [DCLRegularFont sharedInstance];
    _phone.textColor = UIColorFromRGB(0x4b4745);

    _website.font = [DCLRegularFont sharedInstance];
    _website.textColor = UIColorFromRGB(0x4b4745);

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20.0f, 20.0f, 15.0f, 19.0f)];
    imageView.image = [UIImage imageNamed:@"location.png"];
    [_scrollView addSubview:imageView];


    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(20, 130, self.view.frame.size.width - 40, 240)];
    backView.backgroundColor = UIColorFromRGB(0xffffff);

    _scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);

    
    [_scrollView addSubview:backView];

    if (IS_IPHONE_5) {
        _scrollView.scrollEnabled = NO;
    }

    MKMapView *mapView = [[MKMapView alloc] initWithFrame:CGRectMake(23, 133, self.view.frame.size.width - 46, 234)];

    [mapView setMapType:MKMapTypeStandard];
    [mapView setZoomEnabled:YES];
    [mapView setScrollEnabled:YES];

    MKCoordinateRegion region = { {0.0, 0.0 }, { 0.0, 0.0 } };
    region.center.latitude = 50.062152;
    region.center.longitude = 14.428607;
    region.span.longitudeDelta = 0.02f;
    region.span.latitudeDelta = 0.02f;
    [mapView setRegion:region animated:NO];

    
    DCLAnnotation *annotation = [[DCLAnnotation alloc] init];
    annotation.lat = 50.062152;
    annotation.lon = 14.428607;
    [mapView addAnnotation:annotation];

    [mapView setDelegate:self];

    [_scrollView addSubview:mapView];

    UIButton *routeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [routeButton addTarget:self
                    action:@selector(showRoute)
          forControlEvents:UIControlEventTouchDown];
    [routeButton setTitle:@"Show route" forState:UIControlStateNormal];
    routeButton.frame = CGRectMake(20, backView.frame.origin.y + backView.frame.size.height + 15, self.view.frame.size.width - 40, 55.0);
    routeButton.backgroundColor = UIColorFromRGB(0x00878a);


    [_scrollView addSubview:routeButton];

    _scrollView.contentSize = CGSizeMake(320, routeButton.frame.origin.y + routeButton.frame.size.height + 15);


}

- (void)showRoute
{
    Class mapItemClass = [MKMapItem class];
    if (mapItemClass && [mapItemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)])
    {
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(50.062152, 14.428607);
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate
                                                       addressDictionary:nil];
        MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
        [mapItem setName:@"Katholieke Hogeschool Leuven - \"Gezondheidszorg en Technologie\""];

        NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
        MKMapItem *currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];
        [MKMapItem openMapsWithItems:@[currentLocationMapItem, mapItem]
                       launchOptions:launchOptions];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
