//
//  ESTViewController.m
//  EITViewMirror
//
//  Created by Patrik Gebhardt on 05/02/14.
//  Copyright (c) 2014 EST. All rights reserved.
//

#import "ESTViewController.h"

const GLfloat Vertices[] = {
    1, -1, 0,
    1, 1, 0,
    -1, 1, 0
};

@implementation ESTViewController {
    GLuint _vertexBuffer;
    float _rotation;
}

-(void)setupGL {
    [EAGLContext setCurrentContext:self.context];
    
    // initialize shaders
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.useConstantColor = YES;
    self.baseEffect.constantColor = GLKVector4Make(0.0, 0.0, 0.0, 1.0);
    
    // fill vertex buffer
    GLfloat* electrodes = malloc(sizeof(GLfloat) * 2 * 2 * 36);
    float delta_angle = 2.0 * M_PI / 36.0;
    for (int i = 0; i < 36; ++i) {
        float angle = (float)i * delta_angle;
        electrodes[0 * 2 + 0 + i * 2 * 2] = cosf(angle);
        electrodes[0 * 2 + 1 + i * 2 * 2] = sinf(angle);
        electrodes[1 * 2 + 0 + i * 2 * 2] = cosf(angle + 0.1);
        electrodes[1 * 2 + 1 + i * 2 * 2] = sinf(angle + 0.1);
    }
    
    // init vertex and index buffer for square
    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(GLfloat) * 2 * 2 * 36, electrodes, GL_STATIC_DRAW);
    free(electrodes);
}

-(void)tearDown {
    [EAGLContext setCurrentContext:self.context];
    
    // delete vertex buffer
    glDeleteBuffers(1, &_vertexBuffer);
    
    // release shadres
    self.baseEffect = nil;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    // init gl context and assign it to main view
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    GLKView* view = (GLKView*)self.view;
    view.context = self.context;
    view.drawableMultisample = GLKViewDrawableMultisample4X;

    [self setupGL];
}

-(void)dealloc {
    [self tearDown];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    self.paused = !self.paused;
}

#pragma mark - GLKViewDelegate

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClearColor(1.0, 1.0, 1.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    // draw square
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, 0);
    glDrawArrays(GL_LINES, 0, 2 * 36);
}

#pragma mark - GLKViewController

-(void)update {
    // set projection matrix
    float aspect = fabsf(self.view.bounds.size.width / self.view.bounds.size.height);
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0), aspect, 0.0, 10.0);
    self.baseEffect.transform.projectionMatrix = projectionMatrix;
    
    // set model view matrix
    GLKMatrix4 modelViewMatrix = GLKMatrix4MakeTranslation(0.0, 0.0, -3.0);
    _rotation += 90.0 * self.timeSinceLastUpdate;
    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, GLKMathDegreesToRadians(_rotation), 0.0, 0.0, 1.0);
    self.baseEffect.transform.modelviewMatrix = modelViewMatrix;
    
    [self.baseEffect prepareToDraw];
}

@end
