//
//  ParentViewController.h
//  EvilApplesInterviewApp
//
//  Created by Terrick Mansur on 2/10/16.
//  Copyright © 2016 Terrick Mansur. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParentViewController : UIViewController

/**
 * @brief This function is called when a button is clicked
 */
-(IBAction)buttonTouchDown:(UIButton*)button;
/**
 * @brief This function is called when a button cancels click and we need to scale it back up
 */
-(IBAction)scaleUp:(UIButton*)button;

@end
