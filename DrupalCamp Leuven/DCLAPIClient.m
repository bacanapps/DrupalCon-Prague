//
//  DCLAPIClient.m
//  DrupalCamp Leuven
//
//  Created by Tim Leytens on 15/08/13.
//  Copyright (c) 2013 Tim Leytens. All rights reserved.
//

#import "DCLAPIClient.h"

#import "AFNetworking.h"

@implementation DCLAPIClient

+ (id)sharedInstance {
    static DCLAPIClient *__sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[DCLAPIClient alloc] initWithBaseURL:
                            [NSURL URLWithString:@"http://dcleuven-api.timleytens.be:8080/api/"]];
    });
    return __sharedInstance;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [self setDefaultHeader:@"Accept" value:@"application/json"];
    }

    return self;
}


@end
