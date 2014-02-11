//
//  ESTMirrorClient.h
//  EITViewMirror
//
//  Created by Patrik Gebhardt on 06/02/14.
//  Copyright (c) 2014 EST. All rights reserved.
//

#import <Foundation/Foundation.h>

// request constants
typedef enum {
    ESTMirrorClientRequestElectrodesConfig = 0,
    ESTMirrorClientRequestVerticesConfig,
    ESTMirrorClientRequestColorsConfig,
    ESTMirrorClientRequestVerticesUpdate,
    ESTMirrorClientRequestColorsUpdate,
    ESTMirrorClientRequestAnalysisUpdate,
    ESTMirrorClientRequestCalibration
} ESTMirrorClientRequest;

@interface ESTMirrorClient : NSObject

-(id)initWithHostAddress:(NSURL*)hostAddress;
-(void)request:(ESTMirrorClientRequest)request;
-(void)request:(ESTMirrorClientRequest)request withSuccess:(void (^)(NSData* data))success failure:(void (^)(NSError* error))failure;

@property (nonatomic, strong) NSURL* hostAddress;

@end
