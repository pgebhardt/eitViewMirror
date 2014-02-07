//
//  ESTAnalysisViewController.h
//  EITViewMirror
//
//  Created by Patrik Gebhardt on 07/02/14.
//  Copyright (c) 2014 EST. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ESTAnalysisViewController : UITableViewController

-(void)updateAnalysis:(NSDictionary*)analysis;

@property (nonatomic, strong) NSDictionary* analysis;

@end