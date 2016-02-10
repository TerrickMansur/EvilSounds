//
//  TutorialViewController.m
//  EvilApplesInterviewApp
//
//  Created by Terrick Mansur on 2/10/16.
//  Copyright © 2016 Terrick Mansur. All rights reserved.
//

#import "TutorialViewController.h"
#import "SoundManager.h"

@interface TutorialViewController ()

@end

@implementation TutorialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //Load click sound for the UI
    [[SoundManager sharedInstance] addSoundClip:@"click1" fileType:@"mp3"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 * @brief The action we take when start is clickes. We just dissmiss the view
 *
 * @param The button sending this event.
 */
-(IBAction)startClicked:(UIButton*)sender{
    //Play click sounds
    [[SoundManager sharedInstance] playSound:@"click1" delegate:NULL];
    //Dissmiss the view
    [self dismissViewControllerAnimated:YES completion:NULL];
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
