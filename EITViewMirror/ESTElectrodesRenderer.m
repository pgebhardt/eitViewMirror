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

-(id)initWithCount:(NSInteger)count andLength:(CGFloat)length {
    if (self = [super init]) {
        // init properties
        _count = count;
        
        // fill buffer with electrode locations
        GLfloat* electrodes = malloc(sizeof(GLfloat) * 2 * 2 * self.count);
        float delta_angle = 2.0 * M_PI / (float)self.count;
        for (int i = 0; i < self.count; ++i) {
            float angle = (float)i * delta_angle;
            electrodes[0 * 2 + 0 + i * 2 * 2] = cosf(angle);
            electrodes[0 * 2 + 1 + i * 2 * 2] = sinf(angle);
            electrodes[1 * 2 + 0 + i * 2 * 2] = cosf(angle + length);
            electrodes[1 * 2 + 1 + i * 2 * 2] = sinf(angle + length);
        }
        
        // init vertex buffer for electrodes
        glGenBuffers(1, &_vertexBuffer);
        glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
        glBufferData(GL_ARRAY_BUFFER, sizeof(GLfloat) * 2 * 2 * self.count, electrodes, GL_STATIC_DRAW);
        free(electrodes);
        
        // fill color buffer with first electrode colored red, the rest black
        GLfloat* colors = malloc(sizeof(GLfloat) * 2 * 4 * self.count);
        for (int i = 0; i < self.count; ++i) {
            colors[0 * 4 + 0 + i * 2 * 4] = colors[1 * 4 + 0 + i * 2 * 4] = 0.0;
            colors[0 * 4 + 1 + i * 2 * 4] = colors[1 * 4 + 1 + i * 2 * 4] = 0.0;
            colors[0 * 4 + 2 + i * 2 * 4] = colors[1 * 4 + 2 + i * 2 * 4] = 0.0;
            colors[0 * 4 + 3 + i * 2 * 4] = colors[1 * 4 + 3 + i * 2 * 4] = 1.0;
        }
        colors[0 * 4 + 0] = colors[1 * 4 + 0] = 1.0;
    
        // init color vertex buffer for electrodes
        glGenBuffers(1, &_colorBuffer);
        glBindBuffer(GL_ARRAY_BUFFER, _colorBuffer);
        glBufferData(GL_ARRAY_BUFFER, sizeof(GLfloat) * 2 * 4 * self.count, colors, GL_STATIC_DRAW);
        free(colors);
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
    glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, 0, 0);
    
    glDrawArrays(GL_LINES, 0, 2 * (GLsizei)self.count);
}

@end
