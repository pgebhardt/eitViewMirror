//
//  ESTAnalysisViewController.m
//  EITViewMirror
//
//  Created by Patrik Gebhardt on 07/02/14.
//  Copyright (c) 2014 EST. All rights reserved.
//

#import "ESTAnalysisViewController.h"

@implementation ESTAnalysisViewController

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.analysis.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* reusableIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusableIdentifier];
    }
    
    NSString* name = self.analysis[indexPath.row][@"name"];
    NSString* analysis = self.analysis[indexPath.row][@"result"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", name, analysis];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)updateAnalysis:(NSArray*)analysis {
    self.analysis = analysis;

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        self.preferredContentSize = self.tableView.contentSize;
    });
}

@end
