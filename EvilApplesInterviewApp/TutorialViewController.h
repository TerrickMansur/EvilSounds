//
//  TutorialViewController.h
//  EvilApplesInterviewApp
//
//  Created by Terrick Mansur on 2/10/16.
//  Copyright © 2016 Terrick Mansur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParentViewController.h"

@interface TutorialViewController : ParentViewController

/**
 * @brief The action we take when start is clickes. We just dissmiss the view
 *
 * @param The button sending this event.
 */
-(IBAction)startClicked:(UIButton*)sender;

@end
