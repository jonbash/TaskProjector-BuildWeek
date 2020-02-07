//
//  JBTagsTableViewController.h
//  TaskProjector
//
//  Created by Jon Bash on 2020-02-07.
//  Copyright © 2020 Jon Bash. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TagsCoordinator;
@protocol StoryboardInitializable;


NS_SWIFT_NAME(TagsTableViewController)
@interface JBTagsTableViewController : UITableViewController <StoryboardInitializable> // the warnings lie!!

@property (nonatomic, weak, nullable) TagsCoordinator *tagsCoordinator;

@end
