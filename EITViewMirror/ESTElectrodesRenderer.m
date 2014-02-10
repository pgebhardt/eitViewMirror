//
//  ESTElectrodesRenderer.m
//  EITViewMirror
//
//  Created by Patrik Gebhardt on 05/02/14.
//  Copyright (c) 2014 EST. All rights reserved.
//

#import "ESTElectrodesRenderer.h"

@implementation ESTElectrodesRenderer {
    GLuint _vertexBuffer;
    GLuint _colorBuffer;
}

-(id)initWithVertexAndColorData:(NSData*)data {
    if (self = [super init]) {
        // calculate electrode count from data length
        _count = data.length / sizeof(GLfloat) / 2 / 5;
        
        // init vertex buffer for electrodes
        glGenBuffers(1, &_vertexBuffer);
        glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
        glBufferData(GL_ARRAY_BUFFER, sizeof(GLfloat) * 2 * 2 * self.count, data.bytes, GL_STATIC_DRAW);
        
        // init color vertex buffer for electrodes
        glGenBuffers(1, &_colorBuffer);
        glBindBuffer(GL_ARRAY_BUFFER, _colorBuffer);
        glBufferData(GL_ARRAY_BUFFER, sizeof(GLfloat) * 2 * 3 * self.count, &data.bytes[self.count * 2 * 2 * sizeof(GLfloat)], GL_STATIC_DRAW);
    }
    
    return self;
}

-(void)dealloc {
    // cleanup vertex buffer
    glDeleteBuffers(1, &_vertexBuffer);
    glDeleteBuffers(1, &_colorBuffer);
}

-(void)drawInRect:(CGRect)rect {
    // increase line width
    glLineWidth(3.0);
    
    // draw electrodes to gl context
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, 0);
    
    glBindBuffer(GL_ARRAY_BUFFER, _colorBuffer);
    glEnableVertexAttribArray(GLKVertexAttribColor);
    glVertexAttribPointer(GLKVertexAttribColor, 3, GL_FLOAT, GL_FALSE, 0, 0);
    
    glDrawArrays(GL_LINES, 0, 2 * (GLsizei)self.count);
}

@end
