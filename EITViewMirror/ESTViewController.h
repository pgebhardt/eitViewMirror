//
//  ESTViewController.h
//  EITViewMirror
//
//  Created by Patrik Gebhardt on 05/02/14.
//  Copyright (c) 2014 EST. All rights reserved.
//

#import <GLKit/GLKit.h>
#import "ESTElectrodesRenderer.h"

@interface ESTViewController : GLKViewController

@property (nonatomic, strong) EAGLContext* context;
@property (nonatomic, strong) GLKBaseEffect* baseEffect;
@property (nonatomic, strong) ESTElectrodesRenderer* electrodesRenderer;

@end
