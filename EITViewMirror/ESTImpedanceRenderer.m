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
    GLfloat* _vertices;
    GLfloat* _verticesSmall;
    GLfloat* _colors;
    GLfloat* _colorsSmall;
}

-(id)initWithVertexData:(NSData *)vertexData colorsData:(NSData *)colorData {
    if (self = [super init]) {
        // init properties
        _count = vertexData.length / sizeof(GLfloat) / 3 / 3;
        
        // init vertex buffer for electrodes
        glGenBuffers(1, &_vertexBuffer);
        glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
        glBufferData(GL_ARRAY_BUFFER, vertexData.length, vertexData.bytes, GL_STATIC_DRAW);
        _vertices = malloc(vertexData.length);
        _verticesSmall = malloc(vertexData.length / 3);
        memcpy(_vertices, vertexData.bytes, vertexData.length);
        
        // init color vertex buffer for electrodes
        glGenBuffers(1, &_colorBuffer);
        glBindBuffer(GL_ARRAY_BUFFER, _colorBuffer);
        glBufferData(GL_ARRAY_BUFFER, colorData.length, colorData.bytes, GL_STATIC_DRAW);
        _colors = malloc(colorData.length);
        _colorsSmall = malloc(colorData.length / 3);
        memcpy(_colors, colorData.bytes, colorData.length);
    }
    
    return self;
}

-(void)updateVertexData:(NSData *)vertexData colorsData:(NSData *)colorData {
    // update vertex buffer
    memcpy(_verticesSmall, vertexData.bytes, vertexData.length);
    for (int i = 0; i < self.count; ++i) {
        _vertices[2 + 0 * 3 + i * 3 * 3] = -_verticesSmall[0 + i * 3];
        _vertices[2 + 1 * 3 + i * 3 * 3] = -_verticesSmall[1 + i * 3];
        _vertices[2 + 2 * 3 + i * 3 * 3] = -_verticesSmall[2 + i * 3];
    }
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, self.count * 3 * 3 * sizeof(GLfloat), _vertices, GL_DYNAMIC_DRAW);
    
    // update color buffer
    memcpy(_colorsSmall, colorData.bytes, colorData.length);
    for (int i = 0; i < self.count; ++i) {
        _colors[0 + 0 * 3 + i * 3 * 3] = _colors[0 + 1 * 3 + i * 3 * 3] = _colors[0 + 2 * 3 + i * 3 * 3] = _colorsSmall[0 + i * 3];
        _colors[1 + 0 * 3 + i * 3 * 3] = _colors[1 + 1 * 3 + i * 3 * 3] = _colors[1 + 2 * 3 + i * 3 * 3] = _colorsSmall[1 + i * 3];
        _colors[2 + 0 * 3 + i * 3 * 3] = _colors[2 + 1 * 3 + i * 3 * 3] = _colors[2 + 2 * 3 + i * 3 * 3] = _colorsSmall[2 + i * 3];
    }
    glBindBuffer(GL_ARRAY_BUFFER, _colorBuffer);
    glBufferData(GL_ARRAY_BUFFER, self.count * 3 * 3 * sizeof(GLfloat), _colors, GL_DYNAMIC_DRAW);
}

-(void)dealloc {
    // cleanup vertex buffer
    glDeleteBuffers(1, &_vertexBuffer);
    glDeleteBuffers(1, &_colorBuffer);
    free(_vertices);
    free(_verticesSmall);
    free(_colors);
    free(_colorsSmall);
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
