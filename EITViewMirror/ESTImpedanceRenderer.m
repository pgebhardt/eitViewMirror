//
//  ESTImpedanceRenderer.m
//  EITViewMirror
//
//  Created by Patrik Gebhardt on 06/02/14.
//  Copyright (c) 2014 EST. All rights reserved.
//

#import "ESTImpedanceRenderer.h"

@interface ESTImpedanceRenderer ()

@property (nonatomic, assign) GLuint vertexBuffer;
@property (nonatomic, assign) GLuint colorsBuffer;
@property (nonatomic, assign) GLfloat* vertices;
@property (nonatomic, assign) GLfloat* colors;

@end

@implementation ESTImpedanceRenderer

-(id)initWithVertexData:(NSData *)vertexData colorsData:(NSData *)colorsData {
    if (self = [super init]) {
        // init properties
        _count = vertexData.length / sizeof(GLfloat) / 3 / 3;
        
        // init vertex buffer for electrodes
        glGenBuffers(1, &_vertexBuffer);
        glBindBuffer(GL_ARRAY_BUFFER, self.vertexBuffer);
        glBufferData(GL_ARRAY_BUFFER, vertexData.length, vertexData.bytes, GL_DYNAMIC_DRAW);
        self.vertices = malloc(vertexData.length);
        memcpy(self.vertices, vertexData.bytes, vertexData.length);
        
        // init color vertex buffer for electrodes
        glGenBuffers(1, &_colorsBuffer);
        glBindBuffer(GL_ARRAY_BUFFER, self.colorsBuffer);
        glBufferData(GL_ARRAY_BUFFER, colorsData.length, colorsData.bytes, GL_DYNAMIC_DRAW);
        self.colors = malloc(colorsData.length);
        memcpy(self.colors, colorsData.bytes, colorsData.length);
    }
    
    return self;
}

-(void)updateVertexData:(NSData *)vertexData colorsData:(NSData *)colorsData {
    // check buffer sizes
    if (vertexData.length != self.count * sizeof(GLfloat) * 3 ||
        colorsData.length != self.count * sizeof(GLfloat) * 3) {
        return;
    }
    
    // update vertex buffer
    GLfloat* vertexUpdate = (GLfloat*)vertexData.bytes;
    for (int i = 0; i < self.count; ++i) {
        self.vertices[2 + 0 * 3 + i * 3 * 3] = -vertexUpdate[0 + i * 3];
        self.vertices[2 + 1 * 3 + i * 3 * 3] = -vertexUpdate[1 + i * 3];
        self.vertices[2 + 2 * 3 + i * 3 * 3] = -vertexUpdate[2 + i * 3];
    }
    
    // update color buffer
    GLfloat* colorsUpdate = (GLfloat*)colorsData.bytes;
    for (int i = 0; i < self.count; ++i) {
        self.colors[0 + 0 * 3 + i * 3 * 3] = self.colors[0 + 1 * 3 + i * 3 * 3] = self.colors[0 + 2 * 3 + i * 3 * 3] = colorsUpdate[0 + i * 3];
        self.colors[1 + 0 * 3 + i * 3 * 3] = self.colors[1 + 1 * 3 + i * 3 * 3] = self.colors[1 + 2 * 3 + i * 3 * 3] = colorsUpdate[1 + i * 3];
        self.colors[2 + 0 * 3 + i * 3 * 3] = self.colors[2 + 1 * 3 + i * 3 * 3] = self.colors[2 + 2 * 3 + i * 3 * 3] = colorsUpdate[2 + i * 3];
    }
}

-(void)dealloc {
    // cleanup vertex buffer
    glDeleteBuffers(1, &_vertexBuffer);
    glDeleteBuffers(1, &_colorsBuffer);
    free(_vertices);
    free(_colors);
}

-(void)drawInRect:(CGRect)rect {
    // draw electrodes to gl context
    glBindBuffer(GL_ARRAY_BUFFER, self.vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, self.count * 3 * 3 * sizeof(GLfloat), self.vertices, GL_DYNAMIC_DRAW);
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 0, 0);
    
    glBindBuffer(GL_ARRAY_BUFFER, self.colorsBuffer);
    glBufferData(GL_ARRAY_BUFFER, self.count * 3 * 3 * sizeof(GLfloat), self.colors, GL_DYNAMIC_DRAW);
    glEnableVertexAttribArray(GLKVertexAttribColor);
    glVertexAttribPointer(GLKVertexAttribColor, 3, GL_FLOAT, GL_FALSE, 0, 0);
    
    glDrawArrays(GL_TRIANGLES, 0, 3 * (GLsizei)self.count);
}


@end
