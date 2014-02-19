//
//  ESTRotateGestureRecognizer.h
//  EITViewMirror
//
//  Created by Patrik Gebhardt on 19/02/14.
//  Copyright (c) 2014 EST. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIGestureRecognizerSubclass.h>

@interface ESTRotateGestureRecognizer : UIGestureRecognizer

@property (nonatomic, assign) CGFloat xAxisRotation;
@property (nonatomic, assign) CGFloat zAxisRotation;

@end
