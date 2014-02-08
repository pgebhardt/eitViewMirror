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
-(void)request:(NSString*)request withDataCompletionHandler:(void (^)(NSData* data, NSError* error))completionHandler;
-(void)request:(NSString*)request withDictionaryCompletionHandler:(void (^)(NSDictionary* data, NSError* error))completionHandler;

@property (nonatomic, strong) NSURL* hostAddress;

@end
