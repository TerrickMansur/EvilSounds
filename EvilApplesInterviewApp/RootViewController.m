//
//  RootViewController.m
//  EvilApplesInterviewApp
//
//  Created by Terrick Mansur on 2/9/16.
//  Copyright © 2016 Terrick Mansur. All rights reserved.
//

#import "RootViewController.h"
#import <FLAnimatedImage.h>
#import "SoundManager+SoundManagerExtended.h"
#import "ScreenList.h"
#import <QuartzCore/QuartzCore.h>
#import <pop/POP.h>
#import "TutorialViewController.h"

@interface RootViewController ()

@end

//Pre-define some constants
const float DECELERATION_RATE = 0.8;

@implementation RootViewController

/**
 * @brief In this view did load we prepare the Sound Images Carousel object.
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    //Set first appearance to YES
    mFirstAppearance=YES;
    // Do any additional setup after loading the view, typically from a nib.
    //Allocate the array of file names (sound and gif). And add all the name of the files
    self.mListOfScreens = [[NSMutableArray alloc]init];
    //Get the screen list from the ScreenList.plist
    self.mListOfScreens = [ScreenList getScreenList];
    //Now lets load them
    [self loadAllScreens:self.mListOfScreens];

    //Set the carousel deceleration rate.
    self.mSoundImagesCarousel.decelerationRate = DECELERATION_RATE;
    //Set bounce to no.
    [self.mSoundImagesCarousel setBounces:NO];
    //Allocate the dictionary for the gifs that we will be loading, and the dictionary for the Animated Image Views
    mLoadedGifFiles = [[NSMutableDictionary alloc]init];
    mAnimatedImageViews = [[NSMutableDictionary alloc]init];
    //Lets hide the menu view.
    [self hideMenuAnimate:NO block:NULL];
    //Lets load some sounds for the UI
    [[SoundManager sharedInstance] addSoundClip:@"notice" fileType:@"mp3"];
    [[SoundManager sharedInstance] addSoundClip:@"click1" fileType:@"mp3"];
    [[SoundManager sharedInstance] addSoundClip:@"whoosh" fileType:@"mp3"];
    [[SoundManager sharedInstance] addSoundClip:@"chat_incoming" fileType:@"mp3"];
    //Lets give out menu button some round corners
    self.mReplayButton.layer.cornerRadius = 5;
    self.mDontPressButton.layer.cornerRadius = 5;
    self.mReplayButton.layer.masksToBounds = YES;
    self.mDontPressButton.layer.masksToBounds = YES;
}

/**
 * @brief Reload the data after view has been loaded
 */
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //Reload the carousel
    [self.mSoundImagesCarousel reloadData];
    
    //If its the first appearance we show the tutorial
    if (mFirstAppearance) {
        //It will no longer be the first appearance
        mFirstAppearance=NO;
        //Run the tutorial
        [self runTutorialAnimate:NO];
    }
}

/**
 * Load all the sounds and the screens.
 *
 * @return BOOL. If everything was loaded correctly.
 */
-(BOOL)loadAllScreens:(NSArray*)screenArr{
    //If everything loaded correctly
    BOOL allGood = YES;
    //Lets look ta add all the screens
    for(int i = 0 ; i < [screenArr count]; i++){
        //Get the screen dictionary
        NSDictionary *screen = [screenArr objectAtIndex:i];
        //Grab the file name and the sound file type
        NSString *fileName = [screen objectForKey:@"filesName"];
        NSString *soundFileType = [screen objectForKey:@"soundFileType"];
        //Load sounds in memory
        BOOL loaded = [[SoundManager sharedInstance] addSoundClip:fileName fileType:soundFileType];
        //If one didn't load correctly, return false
        if (!loaded)
            allGood = NO;
    }
    return allGood;
}

/**
 * @brief From iCarouselDataSource protocol. Return the amount of images you want this carousel to display.
 *
 * @return NSInteger. The amount of images you want this carousel.
 */
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    return [self.mListOfScreens count];
}

/**
 * @brief Return the view for the given corousel index.
 *
 * @return UIView. The view we want the carousel to display on the given index.
 */
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    //Cast the view
    FLAnimatedImageView *castedView = (FLAnimatedImageView*)view;
    //Grab the screen at thin index
    NSDictionary *screenDictionary = [self.mListOfScreens objectAtIndex:index];
    //Grab the file name for this index
    NSString *fileName = [screenDictionary objectForKey:@"filesName"];

    //Check if we can reuse this view.
    if(castedView==NULL){
        //Create the view
        castedView = [[FLAnimatedImageView alloc] init];
    }
    
    //Declare the gif image we will be showing.
    FLAnimatedImage *image = NULL;
    //Check if we have the gif loaded in memory already.
    if(![mLoadedGifFiles objectForKey:fileName]){
        //Get the gif file location.
        NSString *gifFilePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"gif"];
        //Create the FLAnimatedview for playing th gif with the gif we want to play.
        image = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfFile:gifFilePath]];
        //Store this object, we dont want to load it everytime
        [mLoadedGifFiles setObject:image forKey:fileName];
    }
    else{
        //If we do have it loaded already, just grab it from there.
        image=[mLoadedGifFiles objectForKey:fileName];
    }

    //Set the imege (gif) to animate.
    castedView.animatedImage = image;
    //Set the frame rect
    castedView.frame = carousel.frame;
    //Kinda of a hack. Need to stop it after the return. So I stop it after a milisecond.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.001 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [castedView stopAnimating];
    });
    //Lets also set the dictionary that will keep track of these casted view. We will beed them to sync them with the sound later.
    [mAnimatedImageViews setObject:castedView forKey:[@(index) stringValue]];
    //Return the view
    return castedView;
}

/**
 * @brief The Carousel did end scrolling. Let's play the sound in the index that we are on.
 */
- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel{
    //Stop all the sounds
    [[SoundManager sharedInstance] stopAllSound];
    //Play the screen at the given index
    [self playScreen:carousel.currentItemIndex];
}

/**
 * @brief The Carousel did begin dragging.
 */
- (void)carouselWillBeginDragging:(iCarousel *)carousel{
    //Stop all the sounds
    [[SoundManager sharedInstance] stopAllSound];
    //Loop through all the gifs and stop them
    for (NSString* key in mAnimatedImageViews){
        //Gran the audio from the dictionary
        FLAnimatedImageView *animatedImageView = [mAnimatedImageViews objectForKey:key];
        //Stop the audio
        [animatedImageView stopAnimating];
    }
    
    //Hide the menu
    [self hideMenuAnimate:YES block:NULL];
}

/**
 * @brief From iCarouselDelegate protocol. Tells the carousel if it should wrap or not.
 *
 * @return YES.
 */
- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value{
    //Check if its asking about the wrap option, if so return YES.
    if (option == iCarouselOptionWrap)
        return YES;
    return value;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 * @brief When an audio did finish playing. We stop the gif that is currently playing as well.
 */
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    //Grab the mAnimated Image View we are on
    FLAnimatedImageView *animatedImageView = [mAnimatedImageViews objectForKey:[@(self.mSoundImagesCarousel.currentItemIndex) stringValue]];
    //Stop the animation because the sound stopped.
    [animatedImageView stopAnimating];
    //Show the menu
    [self showMenuAnimate:YES];
}

/**
 * @brief This function will show the menu
 *
 * @param BOOL. If you want to run the animation or not
 */
-(void)showMenuAnimate:(BOOL)animate{
    
    //Play the chat_incoming file when we are running the show menu animation
    [[SoundManager sharedInstance] playSound:@"chat_incoming" delegate:NULL];
    
    //Set hidden to no
    self.mMenu.hidden=NO;

    //If we want to animate, we will do that.
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    //Set some scale animation value
    scaleAnimation.fromValue =[NSValue valueWithCGSize:CGSizeMake(0.0, 0.0)];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0f, 1.0f)];
    scaleAnimation.springBounciness = 0.2f;
    scaleAnimation.springSpeed=0.2f;
    
    //Lets do some radius animation as well
    POPSpringAnimation *radiusAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerCornerRadius];
    //Set some radius animation values
    radiusAnimation.fromValue = @(100.0f);
    radiusAnimation.toValue = @(20.0f);
    
    [self.mMenu.layer pop_addAnimation:scaleAnimation forKey:@"scaleUp"];
    [self.mMenu.layer pop_addAnimation:radiusAnimation forKey:@"roundCorner"];
}

/**
 * @brief This function will hide the menu
 *
 * @param BOOL. If you want to run the animation or not
 * @param Block. The completion block that is called when the animation is finished.
 */
-(void)hideMenuAnimate:(BOOL)animate block:(void(^)(POPAnimation *animation, BOOL finished))block{
    
    //If we want to hide without animation, just set to hidden to true.
    if (!animate){
        self.mMenu.hidden=YES;
    }
    
    //Play the hide menu sound only if the animation will run (the menu is not already hidden).
    if (!self.mMenu.hidden) {
        [[SoundManager sharedInstance] playSound:@"whoosh" delegate:NULL];
    }

    //If we want to animate, we will do that.
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(0.0, 0.0)];
    scaleAnimation.springBounciness = 0.0f;

    //Scale down
    [self.mMenu.layer pop_addAnimation:scaleAnimation forKey:@"scaleDown"];
    //Set the completion block
    scaleAnimation.completionBlock=^(POPAnimation *_animation, BOOL _finished){
        //Set hidden to YES
        self.mMenu.hidden=YES;
        //Call the block from the parameter passed in if its not NULL
        if (block!=NULL)
            block(_animation, _finished);
    };
}

/**
 * @brief This function plays the screen at the given index
 *
 * @param NSInteger. The index of the screen you want to play
 */
-(void)playScreen:(NSInteger)screenIndex{
    //Paranoid check.
    if(screenIndex == -1)
        return;
    //Grab the screen at the given index
    NSDictionary *screenDictionary = [self.mListOfScreens objectAtIndex:screenIndex];
    //Grab the file name
    NSString *filesName =[screenDictionary objectForKey:@"filesName"];
    //Get the instance and play the sound we are on
    [[SoundManager sharedInstance] playSound:filesName delegate:self];
    //Grab the mAnimated Image View we landed on
    FLAnimatedImageView *animatedImageView = [mAnimatedImageViews objectForKey:[@(screenIndex) stringValue]];
    //Start the animation
    [animatedImageView startAnimating];
    //Set the menu its file name to the file name we just played
    [self.mMenuFileName setText:filesName];
}

/**
 * @brief This function is called when a button is clicked
 *
 * @param The button sending this event.
 */
-(IBAction)buttonClicked:(UIButton*)button{
    //Scale the button back up
    [self scaleUp:button];
    //Check what button they clicked
    if (button.tag==BUTTON_DONT_CLICK){
        //All the sounds
        NSMutableArray *allSoound = [[NSMutableArray alloc]init];
        //Get the screen list from the ScreenList.plist
        for (NSDictionary * screen in [ScreenList getScreenList]) {
            //Grab the file name
            NSString *fileName = [screen objectForKey:@"filesName"];
            //Ad the file name
            [allSoound addObject:fileName];
        }
        //Play all the sound together
        [[SoundManager sharedInstance] playSounds:allSoound delegate:NULL];
    }
    else if (button.tag==BUTTON_REPLAY){
        //Play the notice sound
        [[SoundManager sharedInstance] playSound:@"notice" delegate:NULL];
        //Hide the menu first.
        [self hideMenuAnimate:YES block:^(POPAnimation *animation, BOOL finished){
            //When we are done hiding the menu, we can replay
            [self playScreen:self.mSoundImagesCarousel.currentItemIndex];
        }];
    }
    else if(button.tag==BUTTON_SPEAKER){
        //Repeat sounds only
        [[SoundManager sharedInstance] playSound:self.mMenuFileName.text delegate:NULL];
    }
    else if(button.tag==BUTTON_QUESTION){
        //Run the tutorial
        [self runTutorialAnimate:YES];
        //Hide the menu
        [self hideMenuAnimate:YES block:NULL];
    }
}

/**
 * @brief This function runs the tutorial.
 *
 * @param BOOL. If we need to animate when transitionaing to the screen.
 */
-(void)runTutorialAnimate:(BOOL)animate{
    //Lets show the tutorial page. Create it first
    TutorialViewController *tutorialViewController = [[TutorialViewController alloc]initWithNibName:@"TutorialViewController" bundle:nil];
    //Show the view controller
    [self presentViewController:tutorialViewController animated:animate completion:^(void){
        //Only when we finifh tutorial do we start the carousel.
        //Set the datasource and delegate to this class(self).
        [self.mSoundImagesCarousel setDataSource:self];
        [self.mSoundImagesCarousel setDelegate:self];
    }];
}



@end
