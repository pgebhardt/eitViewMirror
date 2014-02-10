//
//  ESTViewController.h
//  EITViewMirror
//
//  Created by Patrik Gebhardt on 05/02/14.
//  Copyright (c) 2014 EST. All rights reserved.
//

#import <GLKit/GLKit.h>
#import "ESTElectrodesRenderer.h"
#import "ESTImpedanceRenderer.h"
#import "ESTMirrorClient.h"

@interface ESTImageViewController : GLKViewController

@property (nonatomic, strong) EAGLContext* context;
@property (nonatomic, strong) ESTElectrodesRenderer* electrodesRenderer;
@property (nonatomic, strong) ESTImpedanceRenderer* impedanceRenderer;
@property (nonatomic, strong) ESTMirrorClient* mirrorClient;

- (IBAction)infoButtonPressed:(id)sender;
- (IBAction)calibrateButtonPressed:(id)sender;

@end
