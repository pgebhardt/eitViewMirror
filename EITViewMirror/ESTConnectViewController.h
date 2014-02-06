//
//  ESTConnectViewController.h
//  EITViewMirror
//
//  Created by Patrik Gebhardt on 06/02/14.
//  Copyright (c) 2014 EST. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import "ESTMirrorClient.h"
#import "ESTElectrodesRenderer.h"
#import "ESTImpedanceRenderer.h"

@interface ESTConnectViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *addressField;
@property (nonatomic, strong) ESTMirrorClient* mirrorClient;
@property (nonatomic, strong) ESTElectrodesRenderer* electrodesRenderer;
@property (nonatomic, strong) ESTImpedanceRenderer* impedanceRenderer;
@property (nonatomic, strong) EAGLContext* context;

- (IBAction)connect:(id)sender;
-(void)updateImpedanceRenderer:(void (^)(NSError* error))completionHandler;

@end
