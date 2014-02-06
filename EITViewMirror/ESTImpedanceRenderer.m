//
//  ESTImpedanceRenderer.m
//  EITViewMirror
//
//  Created by Patrik Gebhardt on 06/02/14.
//  Copyright (c) 2014 EST. All rights reserved.
//

#import "ESTImpedanceRenderer.h"

@implementation ESTImpedanceRenderer {
    GLuint _vertexBuffer;
    GLuint _colorBuffer;
}

-(id)initWithVertexData:(NSData *)vertexData andColorData:(NSData *)colorData {
    if (self = [super init]) {
        // init properties
        _count = vertexData.length / sizeof(GLfloat) / 3 / 3;
        NSLog(@"%ld", (long)self.count);
        
        GLfloat* color = (GLfloat*)colorData.bytes;
        NSLog(@"%f, %f, %f", color[0], color[1], color[2]);
        
        // init vertex buffer for electrodes
        glGenBuffers(1, &_vertexBuffer);
        glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
        glBufferData(GL_ARRAY_BUFFER, vertexData.length, vertexData.bytes, GL_STATIC_DRAW);
        
        // init color vertex buffer for electrodes
        glGenBuffers(1, &_colorBuffer);
        glBindBuffer(GL_ARRAY_BUFFER, _colorBuffer);
        glBufferData(GL_ARRAY_BUFFER, colorData.length, colorData.bytes, GL_STATIC_DRAW);
    }
    
    return self;
}

-(void)dealloc {
    // cleanup vertex buffer
    glDeleteBuffers(1, &_vertexBuffer);
    glDeleteBuffers(1, &_colorBuffer);
}

-(void)drawInRect:(CGRect)rect {
    // draw electrodes to gl context
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 0, 0);
    
    glBindBuffer(GL_ARRAY_BUFFER, _colorBuffer);
    glEnableVertexAttribArray(GLKVertexAttribColor);
    glVertexAttribPointer(GLKVertexAttribColor, 3, GL_FLOAT, GL_FALSE, 0, 0);
    
    glDrawArrays(GL_TRIANGLES, 0, 3 * (GLsizei)self.count);
}


@end
