//
//  ESTRotateGestureRecognizer.m
//  EITViewMirror
//
//  Created by Patrik Gebhardt on 19/02/14.
//  Copyright (c) 2014 EST. All rights reserved.
//

#import "ESTRotateGestureRecognizer.h"

@interface ESTRotateGestureRecognizer ()

@property (nonatomic, assign) CGPoint oldTouchPoint;

@end

@implementation ESTRotateGestureRecognizer

-(void)reset {
    [super reset];
    
    // invalidate x and z angle
    self.xAxisRotation = 0.0;
    self.zAxisRotation = 0.0;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    // check for only one finger gesture
    if ([touches count] != 1 || [[touches anyObject] tapCount] > 1) {
        self.state = UIGestureRecognizerStateFailed;
        return;
    }
    
    // save start touch point
    self.oldTouchPoint = [touches.anyObject locationInView:self.view];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    if (self.state == UIGestureRecognizerStateFailed) {
        return;
    }
    
    // change rotation angles according to finger position relative to last touch event event
    CGPoint newTouchPoint = [touches.anyObject locationInView:self.view];
    
    self.xAxisRotation = 2e-1 * (newTouchPoint.y - self.oldTouchPoint.y);
    if (fabsf(fmodf(self.xAxisRotation, 360.0)) < 90.0 || fabsf(fmodf(self.xAxisRotation, 360.0)) >= 270.0) {
        if (newTouchPoint.y < self.view.bounds.size.height / 2) {
            self.zAxisRotation = -2e-1 * (newTouchPoint.x - self.oldTouchPoint.x);
        }
        else {
            self.zAxisRotation = 2e-1 * (newTouchPoint.x - self.oldTouchPoint.x);
        }
    }
    else {
        if (newTouchPoint.y < self.view.bounds.size.height / 2) {
            self.zAxisRotation = 2e-1 * (newTouchPoint.x - self.oldTouchPoint.x);
        }
        else {
            self.zAxisRotation = -2e-1 * (newTouchPoint.x - self.oldTouchPoint.x);
        }
    }
    
    self.state = UIGestureRecognizerStateChanged;
    self.oldTouchPoint = newTouchPoint;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    self.state = UIGestureRecognizerStateEnded;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    self.state = UIGestureRecognizerStateFailed;
}

@end
