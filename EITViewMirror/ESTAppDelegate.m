//
//  ESTAppDelegate.m
//  EITViewMirror
//
//  Created by Patrik Gebhardt on 05/02/14.
//  Copyright (c) 2014 EST. All rights reserved.
//

#import "ESTAppDelegate.h"

@implementation ESTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // prevent application from entering sleep
    application.idleTimerDisabled = YES;
    
    return YES;
}

@end
