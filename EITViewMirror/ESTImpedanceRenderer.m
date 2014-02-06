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

-(id)initWithData:(NSData *)data {
    if (self = [super init]) {
        // init properties
        _count = data.length / sizeof(GLfloat) / 3 / 3;
        NSLog(@"%ld", (long)self.count);
        
        // init vertex buffer for electrodes
        glGenBuffers(1, &_vertexBuffer);
        glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
        glBufferData(GL_ARRAY_BUFFER, data.length, data.bytes, GL_STATIC_DRAW);
        
        // fill color buffer with first electrode colored red, the rest black
        GLfloat* colors = malloc(sizeof(GLfloat) * 3 * 4 * self.count);
        for (int i = 0; i < self.count; ++i) {
            colors[0 * 4 + 0 + i * 3 * 4] = colors[1 * 4 + 0 + i * 3 * 4] = colors[2 * 4 + 0 + i * 3 * 4] = 0.0;
            colors[0 * 4 + 1 + i * 3 * 4] = colors[1 * 4 + 1 + i * 3 * 4] = colors[2 * 4 + 1 + i * 3 * 4] = 1.0;
            colors[0 * 4 + 2 + i * 3 * 4] = colors[1 * 4 + 2 + i * 3 * 4] = colors[2 * 4 + 2 + i * 3 * 4] = 0.0;
            colors[0 * 4 + 3 + i * 3 * 4] = colors[1 * 4 + 3 + i * 3 * 4] = colors[2 * 4 + 3 + i * 3 * 4] = 1.0;
        }
        
        // init color vertex buffer for electrodes
        glGenBuffers(1, &_colorBuffer);
        glBindBuffer(GL_ARRAY_BUFFER, _colorBuffer);
        glBufferData(GL_ARRAY_BUFFER, sizeof(GLfloat) * 3 * 4 * self.count, colors, GL_STATIC_DRAW);
        free(colors);    }
    
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
    glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, 0, 0);
    
    glDrawArrays(GL_TRIANGLES, 0, 3 * (GLsizei)self.count);
}


@end
