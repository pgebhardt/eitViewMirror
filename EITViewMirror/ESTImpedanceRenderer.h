//
//  ESTImpedanceRenderer.h
//  EITViewMirror
//
//  Created by Patrik Gebhardt on 06/02/14.
//  Copyright (c) 2014 EST. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface ESTImpedanceRenderer : NSObject

-(id)initWithVertexData:(NSData*)vertexData andColorData:(NSData*)colorData;
-(void)drawInRect:(CGRect)rect;
-(void)updateVertices:(NSData*)vertexData andColors:(NSData*)colorData;
                                                     
@property (nonatomic, assign, readonly) NSInteger count;

@end
