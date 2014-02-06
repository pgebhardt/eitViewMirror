//
//  ESTMirrorClient.h
//  EITViewMirror
//
//  Created by Patrik Gebhardt on 06/02/14.
//  Copyright (c) 2014 EST. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ESTMirrorClient : NSObject

-(id)initWithHostAddress:(NSURL*)hostAddress;

-(void)requestElectrodesConfig:(void (^)(NSInteger electodesCount, CGFloat length, NSError* error))completionHandler;

@property (nonatomic, strong) NSURL* hostAddress;

@end
