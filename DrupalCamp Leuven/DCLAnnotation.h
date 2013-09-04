//
//  DCLAnnotation.h
//  DrupalCamp
//
//  Created by Tim Leytens on 30/08/13.
//  Copyright (c) 2013 Tim Leytens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface DCLAnnotation : NSObject <MKAnnotation> {
    CLLocationCoordinate2D coordinate;
}

@property (nonatomic) float lat;
@property (nonatomic) float lon;


@end
