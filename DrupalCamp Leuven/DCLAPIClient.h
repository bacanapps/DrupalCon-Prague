//
//  DCLAPIClient.h
//  DrupalCamp Leuven
//
//  Created by Tim Leytens on 15/08/13.
//  Copyright (c) 2013 Tim Leytens. All rights reserved.
//

#import "AFHTTPClient.h"

@interface DCLAPIClient : AFHTTPClient

+ (id)sharedInstance;

@end
