//
//  ModelController.h
//  EvilApplesInterviewApp
//
//  Created by Terrick Mansur on 2/9/16.
//  Copyright © 2016 Terrick Mansur. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DataViewController;

@interface ModelController : NSObject <UIPageViewControllerDataSource>

- (DataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
- (NSUInteger)indexOfViewController:(DataViewController *)viewController;

@end

