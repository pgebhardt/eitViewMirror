//
//  ESTConnectViewController.m
//  EITViewMirror
//
//  Created by Patrik Gebhardt on 06/02/14.
//  Copyright (c) 2014 EST. All rights reserved.
//

#import "ESTConnectViewController.h"
#import "ESTElectrodesRenderer.h"
#import "ESTImageViewController.h"

@implementation ESTConnectViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    // init opengl context
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
}

- (IBAction)connect:(id)sender {
    // hide keyboard
    [self.addressField resignFirstResponder];
    
    // test mirror client
    NSURL* hostAddress = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:3003", self.addressField.text]];
    self.mirrorClient = [[ESTMirrorClient alloc] initWithHostAddress:hostAddress];
    [self.mirrorClient requestElectrodesConfig:^(NSInteger electodesCount, CGFloat length, NSError *error) {
        [EAGLContext setCurrentContext:self.context];
        
        // create electrodes renderer
        self.electrodesRenderer = [[ESTElectrodesRenderer alloc] initWithCount:electodesCount andLength:length];
    
        // request
        [self.mirrorClient requestVetricesConfig:^(NSData* vertexData, NSError *error) {
            [self.mirrorClient requestColorConfig:^(NSData *colorData, NSError *error) {
                [EAGLContext setCurrentContext:self.context];
                
                // create impedance renderer
                self.impedanceRenderer = [[ESTImpedanceRenderer alloc] initWithVertexData:vertexData andColorData:colorData];
                
                // execute notification on main thread
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self performSegueWithIdentifier:@"showImageView" sender:self];
                });
            }];
        }];
    }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showImageView"]) {
        ESTImageViewController* destinationViewController = (ESTImageViewController*)segue.destinationViewController;
        destinationViewController.context = self.context;
        destinationViewController.electrodesRenderer = self.electrodesRenderer;
        destinationViewController.impedanceRenderer = self.impedanceRenderer;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self connect:self];
    
    return YES;
}

@end
