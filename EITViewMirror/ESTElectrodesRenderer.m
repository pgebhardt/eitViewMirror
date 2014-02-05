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
}

-(id)initWithCount:(NSInteger)count andLength:(CGFloat)length {
    if (self = [super init]) {
        // init properties
        _count = count;
        
        // initialize vertex buffer
        GLfloat* electrodes = malloc(sizeof(GLfloat) * 2 * 2 * self.count);
        float delta_angle = 2.0 * M_PI / (float)self.count;
        for (int i = 0; i < self.count; ++i) {
            float angle = (float)i * delta_angle;
            electrodes[0 * 2 + 0 + i * 2 * 2] = cosf(angle);
            electrodes[0 * 2 + 1 + i * 2 * 2] = sinf(angle);
            electrodes[1 * 2 + 0 + i * 2 * 2] = cosf(angle + length);
            electrodes[1 * 2 + 1 + i * 2 * 2] = sinf(angle + length);
        }
        
        // init vertex and index buffer for square
        glGenBuffers(1, &_vertexBuffer);
        glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
        glBufferData(GL_ARRAY_BUFFER, sizeof(GLfloat) * 2 * 2 * self.count, electrodes, GL_STATIC_DRAW);
        free(electrodes);
    }
    
    return self;
}

-(void)dealloc {
    // cleanup vertex buffer
    glDeleteBuffers(1, &_vertexBuffer);
}

-(void)drawInRect:(CGRect)rect withBaseEffect:(GLKBaseEffect *)baseEffect {
    // enable solid color for base effect
    if (baseEffect) {
        baseEffect.useConstantColor = YES;
        baseEffect.constantColor = GLKVector4Make(0.0, 0.0, 0.0, 1.0);
        [baseEffect prepareToDraw];
    }
    
    // increase line width
    glLineWidth(3.0);
    
    // draw electrodes to gl context
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, 0);
    glDrawArrays(GL_LINES, 0, 2 * (GLsizei)self.count);
}

@end
