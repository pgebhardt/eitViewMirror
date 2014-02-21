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
    
    // init properties
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    self.mirrorClient = [[ESTMirrorClient alloc] init];
    
    // observe keyboard
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLayoutForKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLayoutForKeyboard:) name:UIKeyboardWillHideNotification object:nil];
    
    // observer address field return
    self.addressField.delegate = self;
}

-(void)dealloc {
    // remove keyboard observer
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:UIKeyboardWillShowNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:UIKeyboardWillHideNotification];
}

- (IBAction)connect:(id)sender {
    // hide keyboard and disable connect button
    [self.addressField resignFirstResponder];
    self.connectButton.enabled = NO;

    // connect to mirror server and request electrodes, vertices and colors config
    self.mirrorClient.hostAddress = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:3003",
                                               self.addressField.text.length > 0 ? self.addressField.text : @"127.0.0.1"]];
    
    // error handler
    void (^errorHanlder)(NSError*) = ^(NSError* error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ERROR", @"message")
                                                                message:[NSString stringWithFormat:@"%@:\n%@", NSLocalizedString(@"UNABLE_TO_CONNECT_TO_HOST", @"message"), self.mirrorClient.hostAddress]
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
            self.connectButton.enabled = YES;
        });
    };
    
    // create renderer
    [self.mirrorClient request:ESTMirrorClientRequestElectrodesConfig withSuccess:^(NSData *data) {
        [EAGLContext setCurrentContext:self.context];
        
        // create electrodes renderer
        self.electrodesRenderer = [[ESTElectrodesRenderer alloc] initWithVertexAndColorData:data];
        
        // request vertices and colors config
        [self.mirrorClient request:ESTMirrorClientRequestVerticesConfig withSuccess:^(NSData* vertices) {
            [self.mirrorClient request:ESTMirrorClientRequestColorsConfig withSuccess:^(NSData* colors) {
                [EAGLContext setCurrentContext:self.context];
                
                // create impedance renderer
                self.impedanceRenderer = [[ESTImpedanceRenderer alloc] initWithVertexData:vertices colorsData:colors];
                
                // execute notification on main thread
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.connectButton.enabled = YES;
                    [self performSegueWithIdentifier:@"showImageView" sender:self];
                });
            } failure:errorHanlder];
        } failure:errorHanlder];
    } failure:errorHanlder];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showImageView"]) {
        // init properties of image view controller
        ESTImageViewController* destinationViewController = (ESTImageViewController*)segue.destinationViewController;
        destinationViewController.context = self.context;
        destinationViewController.renderer = @[self.electrodesRenderer, self.impedanceRenderer];
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
        CGRect keyboardEndFrameWindow = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        double keyboardTransitionDuration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        UIViewAnimationCurve keyboardTransitionAnimationCurve = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
        
        // annimate update of constraint accordint to keyboard fadetime
        if ([notification.name isEqualToString:UIKeyboardWillShowNotification]) {
            self.verticalPostitionConstrain.constant += keyboardEndFrameWindow.size.width / 3;
        }
        else {
            self.verticalPostitionConstrain.constant -= keyboardEndFrameWindow.size.width / 3;
        }
        [UIView animateKeyframesWithDuration:keyboardTransitionDuration
                                       delay:0.0
                                     options:(keyboardTransitionAnimationCurve << 16 | UIViewAnimationOptionBeginFromCurrentState)
                                  animations:^{
                                      [self.view layoutIfNeeded];
                                  }
                                  completion:nil];
    }
}

@end
