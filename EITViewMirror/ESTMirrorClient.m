//
//  ESTMirrorClient.m
//  EITViewMirror
//
//  Created by Patrik Gebhardt on 06/02/14.
//  Copyright (c) 2014 EST. All rights reserved.
//

#import "ESTMirrorClient.h"
#import "ESTElectrodesRenderer.h"

@implementation ESTMirrorClient

-(id)initWithHostAddress:(NSURL *)hostAddress {
    if (self = [super init]) {
        // init properties
        self.hostAddress = hostAddress;
    }
    
    return self;
}

-(void)requestElectrodesConfig:(void (^)(NSInteger, CGFloat, NSError *))completionHandler {
    // request electrodes configuration from server
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/electrodes", self.hostAddress]]];
    
    NSURLSession* urlSession = [NSURLSession sharedSession];
    [[urlSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            // extract data
            NSDictionary* body = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            
            // call completion handler
            completionHandler([body[@"count"] intValue], [body[@"length"] floatValue], error);
        }
    }] resume];
}

-(void)requestVetricesConfig:(void (^)(NSData*, NSError *))completionHandler {
    // request electrodes configuration from server
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/vertices", self.hostAddress]]];
    
    NSURLSession* urlSession = [NSURLSession sharedSession];
    [[urlSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            // call completion handler
            completionHandler(data, error);
        }
    }] resume];
}

-(void)requestColorConfig:(void (^)(NSData *, NSError *))completionHandler {
    // request electrodes configuration from server
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/colors", self.hostAddress]]];
    
    NSURLSession* urlSession = [NSURLSession sharedSession];
    [[urlSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            // call completion handler
            completionHandler(data, error);
        }
    }] resume];
}

@end
