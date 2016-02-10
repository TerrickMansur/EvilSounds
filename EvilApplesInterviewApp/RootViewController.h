//
//  RootViewController.h
//  EvilApplesInterviewApp
//
//  Created by Terrick Mansur on 2/9/16.
//  Copyright © 2016 Terrick Mansur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import <AVFoundation/AVFoundation.h>
#import "ParentViewController.h"
/**
 * This enum defined the tag of the buttons for the menu
 */
typedef enum{
    BUTTON_DONT_CLICK=0,
    BUTTON_REPLAY=1,
    BUTTON_SPEAKER=2,
    BUTTON_QUESTION=3,

}ButtonTags;


@interface RootViewController : ParentViewController <UIPageViewControllerDelegate, iCarouselDataSource, iCarouselDelegate, AVAudioPlayerDelegate>{
    //The gif files that we have already loaded
    NSMutableDictionary *mLoadedGifFiles;
    //The views thet we returned based in the indexed
    NSMutableDictionary *mAnimatedImageViews;
    //This bool keeps track is this is the first appearance of the view controller
    BOOL mFirstAppearance;
}


/**
 * @brief The instance of the replay button.
 */
@property (nonatomic, strong)IBOutlet UIButton *mReplayButton;

/**
 * @brief The instance os the dont press button
 */
@property (nonatomic, strong)IBOutlet UIButton *mDontPressButton;

/**
 * @brief The carousel that will be displaying the views.
 */
@property (nonatomic, strong)IBOutlet iCarousel *mSoundImagesCarousel;

/**
 * @brief The array that contains the sounds clip and gif file names
 */
@property (nonatomic, strong)NSArray *mListOfScreens;

/**
 * @brief The UIView that will serve as the menu.
 */
@property (nonatomic, strong)IBOutlet UIView *mMenu;

/**
 * @brief The UILabel that will display the file name that we just played.
 */
@property (nonatomic, strong)IBOutlet UILabel *mMenuFileName;

/**
 * @brief This function is called when a button is clicked
 *
 * @param The button sending this event.
 */
-(IBAction)buttonClicked:(UIButton*)button;

@end