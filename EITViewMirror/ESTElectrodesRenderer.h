//
//  ESTElectrodesRenderer.h
//  EITViewMirror
//
//  Created by Patrik Gebhardt on 05/02/14.
//  Copyright (c) 2014 EST. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "ESTRenderer.h"

@interface ESTElectrodesRenderer : NSObject<ESTRenderer>

-(id)initWithVertexAndColorData:(NSData*)data;

@property (nonatomic, assign, readonly) NSInteger count;

@end
