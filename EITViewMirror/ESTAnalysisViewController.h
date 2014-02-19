//
//  ESTAnalysisViewController.h
//  EITViewMirror
//
//  Created by Patrik Gebhardt on 07/02/14.
//  Copyright (c) 2014 EST. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESTMirrorClient.h"

@interface ESTAnalysisViewController : UITableViewController

-(void)updateWithMirrorClient:(ESTMirrorClient*)mirrorClient failure:(void (^)(NSError* error))failure;

@end
