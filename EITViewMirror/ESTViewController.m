//
//  ESTViewController.m
//  EITViewMirror
//
//  Created by Patrik Gebhardt on 05/02/14.
//  Copyright (c) 2014 EST. All rights reserved.
//

#import "ESTViewController.h"

@implementation ESTViewController {
    float _rotation;
}

-(void)setupGL {
    [EAGLContext setCurrentContext:self.context];
    
    // initialize shaders
    self.baseEffect = [[GLKBaseEffect alloc] init];
    
    // create electrode renderer
    self.electrodesRenderer = [[ESTElectrodesRenderer alloc] initWithCount:36 andLength:0.1];
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

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    self.paused = !self.paused;
}

#pragma mark - GLKViewDelegate

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClearColor(1.0, 1.0, 1.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    // draw electrodes
    [self.electrodesRenderer drawInRect:rect];
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
