//
//  ESTViewController.m
//  EITViewMirror
//
//  Created by Patrik Gebhardt on 05/02/14.
//  Copyright (c) 2014 EST. All rights reserved.
//

#import "ESTViewController.h"

@implementation ESTViewController {
    CGPoint _oldTouchPoint;
    float _xAxisRotation;
    float _zAxisRotation;
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
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(40.0), aspect, 0.0, 10.0);
    self.baseEffect.transform.projectionMatrix = projectionMatrix;
    
    // set model view matrix
    GLKMatrix4 modelViewMatrix = GLKMatrix4MakeTranslation(0.0, 0.0, -3.0);
    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, GLKMathDegreesToRadians(_xAxisRotation), 1.0, 0.0, 0.0);
    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, GLKMathDegreesToRadians(_zAxisRotation), 0.0, 0.0, 1.0);
    self.baseEffect.transform.modelviewMatrix = modelViewMatrix;
    
    [self.baseEffect prepareToDraw];
}

#pragma mark - Touch Events

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // save start touch point
    _oldTouchPoint = [touches.allObjects[0] locationInView:self.view];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    // change rotation angles according to finger position relative to last touch event event
    CGPoint newTouchPoint = [touches.allObjects[0] locationInView:self.view];
    
    _xAxisRotation += 2e-1 * (newTouchPoint.y - _oldTouchPoint.y);
    if (fabsf(fmodf(_xAxisRotation, 360.0)) < 90.0 || fabsf(fmodf(_xAxisRotation, 360.0)) >= 270.0) {
        if (newTouchPoint.y < self.view.bounds.size.height / 2) {
            _zAxisRotation -= 2e-1 * (newTouchPoint.x - _oldTouchPoint.x);
        }
        else {
            _zAxisRotation += 2e-1 * (newTouchPoint.x - _oldTouchPoint.x);
        }
    }
    else {
        if (newTouchPoint.y < self.view.bounds.size.height / 2) {
            _zAxisRotation += 2e-1 * (newTouchPoint.x - _oldTouchPoint.x);
        }
        else {
            _zAxisRotation -= 2e-1 * (newTouchPoint.x - _oldTouchPoint.x);
        }
    }
    
    _oldTouchPoint = newTouchPoint;
}

@end
