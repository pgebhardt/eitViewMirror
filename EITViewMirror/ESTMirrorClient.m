//
//  ESTMirrorClient.m
//  EITViewMirror
//
//  Created by Patrik Gebhardt on 06/02/14.
//  Copyright (c) 2014 EST. All rights reserved.
//

#import "ESTMirrorClient.h"
#import "ESTElectrodesRenderer.h"

// request strings
static NSArray* requestStrings = nil;

@interface ESTMirrorClient ()

@property (nonatomic, strong) NSURLSession* urlSession;

@end

@implementation ESTMirrorClient

+(void)initialize {
    [super initialize];

    // init request strings
    requestStrings = @[@"electrodes", @"vertices", @"colors", @"vertices-update", @"colors-update", @"analysis-update", @"calibrate"];
}

-(id)initWithHostAddress:(NSURL *)hostAddress {
    if (self = [super init]) {
        // init properties
        self.hostAddress = hostAddress;

        // create and init url session
        NSURLSessionConfiguration* sessionConfiguration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        sessionConfiguration.allowsCellularAccess = NO;
        sessionConfiguration.timeoutIntervalForRequest = 5.0;
        sessionConfiguration.timeoutIntervalForResource = 6.0;
        sessionConfiguration.HTTPMaximumConnectionsPerHost = 1;
        self.urlSession = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    }
    
    return self;
}

-(void)request:(ESTMirrorClientRequest)request {
    // request at server without expecting response
    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", self.hostAddress, requestStrings[request]]]];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:nil];
}

-(void)request:(ESTMirrorClientRequest)request withSuccess:(void (^)(NSData *))success failure:(void (^)(NSError *))failure {
    // request electrodes configuration from server
    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", self.hostAddress, requestStrings[request]]]];
    
    [[self.urlSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        // call completion handler
        if (error) {
            if (failure) {
                failure(error);
            }
        }
        else {
            success(data);
        }
    }] resume];
}

@end
