//
//  ESTImpedanceRenderer.h
//  EITViewMirror
//
//  Created by Patrik Gebhardt on 06/02/14.
//  Copyright (c) 2014 EST. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "ESTRenderer.h"

@interface ESTImpedanceRenderer : NSObject<ESTRenderer>

-(id)initWithVertexData:(NSData*)vertexData colorsData:(NSData*)colorsData;
                                                     
@property (nonatomic, assign, readonly) NSInteger count;

@end
