//
//  ESTViewController.m
//  EITViewMirror
//
//  Created by Patrik Gebhardt on 05/02/14.
//  Copyright (c) 2014 EST. All rights reserved.
//

#import "ESTImageViewController.h"

@implementation ESTImageViewController {
    CGPoint _oldTouchPoint;
    float _xAxisRotation;
    float _zAxisRotation;
    BOOL _updateing;
}

-(void)setupGL {
    [EAGLContext setCurrentContext:self.context];
    
    // initialize shaders
    self.baseEffect = [[GLKBaseEffect alloc] init];

    glEnable(GL_DEPTH_TEST);
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    // init gl context and assign it to main view
    GLKView* view = (GLKView*)self.view;
    view.context = self.context;
    view.drawableMultisample = GLKViewDrawableMultisample4X;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    // init properties
    _updateing = NO;
    
    [self setupGL];
}

-(void)updateImpedanceRenderer {
    // request
    _updateing = YES;
    [self.mirrorClient requestVetricesUpdate:^(NSData* vertexData, NSError *error) {
        [self.mirrorClient requestColorUpdate:^(NSData *colorData, NSError *error) {
            [EAGLContext setCurrentContext:self.context];
            
            // update impedance renderer
            [self.impedanceRenderer updateVertices:vertexData andColors:colorData];    
            
            _updateing = NO;
        }];
    }];
}

#pragma mark - GLKViewDelegate

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClearColor(1.0, 1.0, 1.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    // draw renderer
    [self.electrodesRenderer drawInRect:rect];
    [self.impedanceRenderer drawInRect:rect];
}

#pragma mark - GLKViewController

-(void)update {
    // set projection matrix
    float aspect = fabsf(self.view.bounds.size.width / self.view.bounds.size.height);
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(10.0), aspect, 0.1, 100.0);
    self.baseEffect.transform.projectionMatrix = projectionMatrix;
    
    // set model view matrix
    GLKMatrix4 modelViewMatrix = GLKMatrix4MakeTranslation(0.0, 0.0, -20.0);
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        modelViewMatrix = GLKMatrix4Scale(modelViewMatrix, aspect, aspect, aspect);
    }
    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, GLKMathDegreesToRadians(_xAxisRotation), 1.0, 0.0, 0.0);
    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, GLKMathDegreesToRadians(_zAxisRotation), 0.0, 0.0, 1.0);
    self.baseEffect.transform.modelviewMatrix = modelViewMatrix;
    
    [self.baseEffect prepareToDraw];
    
    // fetch new data
    if (!_updateing) {
        [self updateImpedanceRenderer];
    }
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
