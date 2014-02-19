//
//  ESTElectrodesRenderer.m
//  EITViewMirror
//
//  Created by Patrik Gebhardt on 05/02/14.
//  Copyright (c) 2014 EST. All rights reserved.
//

#import "ESTElectrodesRenderer.h"

@interface ESTElectrodesRenderer ()

@property (nonatomic, assign) GLuint vertexBuffer;
@property (nonatomic, assign) GLuint colorsBuffer;

@end

@implementation ESTElectrodesRenderer

-(id)initWithVertexAndColorData:(NSData*)data {
    if (self = [super init]) {
        // calculate electrode count from data length
        _count = data.length / sizeof(GLfloat) / 2 / 5;
        
        // init open gl properties
        glLineWidth(3.0);
        
        // init vertex buffer for electrodes
        glGenBuffers(1, &_vertexBuffer);
        glBindBuffer(GL_ARRAY_BUFFER, self.vertexBuffer);
        glBufferData(GL_ARRAY_BUFFER, sizeof(GLfloat) * 2 * 2 * self.count, data.bytes, GL_STATIC_DRAW);
        
        // init color vertex buffer for electrodes
        glGenBuffers(1, &_colorsBuffer);
        glBindBuffer(GL_ARRAY_BUFFER, self.colorsBuffer);
        glBufferData(GL_ARRAY_BUFFER, sizeof(GLfloat) * 2 * 3 * self.count, &data.bytes[self.count * 2 * 2 * sizeof(GLfloat)], GL_STATIC_DRAW);
    }
    
    return self;
}

-(void)updateWithMirrorClient:(ESTMirrorClient *)mirrorClient failure:(void (^)(NSError *))failure {    
}

-(void)dealloc {
    // cleanup vertex buffer
    glDeleteBuffers(1, &_vertexBuffer);
    glDeleteBuffers(1, &_colorsBuffer);
}

-(void)drawInRect:(CGRect)rect {
    // draw electrodes to gl context
    glBindBuffer(GL_ARRAY_BUFFER, self.vertexBuffer);
    glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, 0);
    
    glBindBuffer(GL_ARRAY_BUFFER, self.colorsBuffer);
    glVertexAttribPointer(GLKVertexAttribColor, 3, GL_FLOAT, GL_FALSE, 0, 0);
    
    glDrawArrays(GL_LINES, 0, 2 * (GLsizei)self.count);
}

@end
