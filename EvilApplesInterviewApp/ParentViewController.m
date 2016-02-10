//
//  ParentViewController.m
//  EvilApplesInterviewApp
//
//  Created by Terrick Mansur on 2/10/16.
//  Copyright © 2016 Terrick Mansur. All rights reserved.
//

#import "ParentViewController.h"
#import "SoundManager.h"
#import <pop/POP.h>

@interface ParentViewController ()

@end

@implementation ParentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 * @brief This function is called when a button is clicked
 *
 * @param The button sending this event.
 */
-(IBAction)buttonTouchDown:(UIButton*)button{
    //Play the button down button
    [[SoundManager sharedInstance] playSound:@"click1" delegate:NULL];
    //Lets scale the button down for some extra animation effect
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(0.85, 0.85)];
    scaleAnimation.springBounciness = 10.f;
    [button.layer pop_addAnimation:scaleAnimation forKey:@"scaleDown"];
}

/**
 * @brief This function is called when a button cancels click and we need to scale it back up
 *
 * @param The button sending this event.
 */
-(IBAction)scaleUp:(UIButton*)button{
    //Lets scale the button down for some extra animation effect
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0, 1.0)];
    scaleAnimation.springBounciness = 10.f;
    [button.layer pop_addAnimation:scaleAnimation forKey:@"scaleDown"];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
