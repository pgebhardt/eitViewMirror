//
//  ESTRenderer.h
//  EITViewMirror
//
//  Created by Patrik Gebhardt on 19/02/14.
//  Copyright (c) 2014 EST. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ESTMirrorClient.h"

@protocol ESTRenderer <NSObject>

-(void)drawInRect:(CGRect)rect;
-(void)updateWithMirrorClient:(ESTMirrorClient*)mirrorClient failure:(void (^)(NSError* error))failure;

@end
