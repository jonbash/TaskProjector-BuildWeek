//
//  JBTagsTableViewController.m
//  TaskProjector
//
//  Created by Jon Bash on 2020-02-07.
//  Copyright © 2020 Jon Bash. All rights reserved.
//

#import "JBTagsTableViewController.h"
#import "TaskProjector-Swift.h"


@implementation JBTagsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Tags";
}


#pragma mark - TableView Methods

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return (self.tagsCoordinator != nil) ? self.tagsCoordinator.tagCount : 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TagCell"
                                                            forIndexPath:indexPath];
    Tag *tag = [self.tagsCoordinator tagForIndexPath:indexPath];
    cell.textLabel.text = tag.name;
    
    return cell;
}


- (void)      tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tagsCoordinator viewTagDetailsForIndex:indexPath];
}


@end
