//
//  ESTMirrorClient.h
//  EITViewMirror
//
//  Created by Patrik Gebhardt on 06/02/14.
//  Copyright (c) 2014 EST. All rights reserved.
//

#import <Foundation/Foundation.h>

// request constants
extern NSString* const ESTMirrorClientRequestElectrodesConfig;
extern NSString* const ESTMirrorClientRequestVerticesConfig;
extern NSString* const ESTMirrorClientRequestColorsConfig;
extern NSString* const ESTMirrorClientRequestVerticesUpdate;
extern NSString* const ESTMirrorClientRequestColorsUpdate;
extern NSString* const ESTMirrorClientRequestAnalysisUpdate;
extern NSString* const ESTMirrorClientRequestCalibration;

@interface ESTMirrorClient : NSObject

-(id)initWithHostAddress:(NSURL*)hostAddress;

-(void)request:(NSString*)request;
-(void)requestData:(NSString*)request success:(void (^)(NSData* data))success failure:(void (^)(NSError* error))failure;
-(void)requestDictionary:(NSString*)request success:(void (^)(NSDictionary* data))success failure:(void (^)(NSError* error))failure;

@property (nonatomic, strong) NSURL* hostAddress;

@end
