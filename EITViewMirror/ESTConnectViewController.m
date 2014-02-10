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
    
    // observe keyboard
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLayoutForKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLayoutForKeyboard:) name:UIKeyboardWillHideNotification object:nil];
    
    // observer address field return
    self.addressField.delegate = self;
}

- (IBAction)connect:(id)sender {
    // hide keyboard and disable connect button
    [self.addressField resignFirstResponder];
    self.connectButton.enabled = NO;
    
    // connect to mirror server and request electrodes, vertices and colors config
    NSURL* hostAddress = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:3003", self.addressField.text]];
    self.mirrorClient = [[ESTMirrorClient alloc] initWithHostAddress:hostAddress];
    [self.mirrorClient request:ESTMirrorClientRequestElectrodesConfig withDataCompletionHandler:^(NSData* data, NSError *error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ERROR", @"message")
                                                                    message:[NSString stringWithFormat:@"%@:\n%@", NSLocalizedString(@"UNABLE_TO_CONNECT_TO_HOST", @"message"), hostAddress]
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                [alertView show];
            });
        }
        else {
            [EAGLContext setCurrentContext:self.context];
            
            // create electrodes renderer
            self.electrodesRenderer = [[ESTElectrodesRenderer alloc] initWithVertexAndColorData:data];
            
            // request vertices and colors config
            [self.mirrorClient request:ESTMirrorClientRequestVerticesConfig withDataCompletionHandler:^(NSData* vertices, NSError* error) {
                [self.mirrorClient request:ESTMirrorClientRequestColorsConfig withDataCompletionHandler:^(NSData* colors, NSError* error) {
                    [EAGLContext setCurrentContext:self.context];
                    
                    // create impedance renderer
                    self.impedanceRenderer = [[ESTImpedanceRenderer alloc] initWithVertexData:vertices colorsData:colors];
                    
                    // execute notification on main thread
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self performSegueWithIdentifier:@"showImageView" sender:self];
                    });
                }];
            }];
        }
        
        self.connectButton.enabled = YES;
    }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showImageView"]) {
        // init properties of image view controller
        ESTImageViewController* destinationViewController = (ESTImageViewController*)segue.destinationViewController;
        destinationViewController.context = self.context;
        destinationViewController.electrodesRenderer = self.electrodesRenderer;
        destinationViewController.impedanceRenderer = self.impedanceRenderer;
        destinationViewController.mirrorClient = self.mirrorClient;
        destinationViewController.navigationItem.title = self.addressField.text;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    // connect to server on return
    [self connect:self];
    
    return YES;
}

-(void)updateLayoutForKeyboard:(NSNotification *)notification {
    // animate only in landscape
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        // extract offset and animation duration from notification
        CGRect keyboardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGFloat offset = keyboardFrame.size.width;
        NSTimeInterval animationDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        // annimate update of constraint accordint to keyboard fadetime
        if ([notification.name isEqualToString:UIKeyboardWillShowNotification]) {
            self.verticalPostitionConstrain.constant += offset / 3;
        }
        else {
            self.verticalPostitionConstrain.constant -= offset / 3;
        }
        [UIView animateWithDuration:animationDuration animations:^{
            [self.view layoutIfNeeded];
        }];
    }
}

@end
