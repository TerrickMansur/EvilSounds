//
//  SoundManager.m
//  EvilApplesInterviewApp
//
//  Created by Terrick Mansur on 2/9/16.
//  Copyright © 2016 Terrick Mansur. All rights reserved.
//

#import "SoundManager.h"
#import <AVFoundation/AVAudioPlayer.h>
#import <AVFoundation/AVAudioSession.h>

@implementation SoundManager

/**
 * @brief We will disable init,
 *
 * @return This function will only return NULL.
 */
-(id)init{
    //Lets log a message. Tell whoever is trying to call this init function to use get instance. This is a singleton class and here can only be one instance.
    NSLog(@"SoundManager is a singleton class. Use getInstance function.");
    //Return null
    return NULL;
}

/**
 * @brief This is our private init function. We can only call this function in this class (getInstance function).
 *
 * @return This function returns
 */
- (instancetype)initPrivate {
    self = [super init];
    if (self) {
        //Allocate the audio session.
        mAudioSession = [AVAudioSession sharedInstance];
        //Set the category to Ambient
        //(The category for an app in which sound playback is nonprimary—that is, your app can be used successfully with the sound turned off.)
        [mAudioSession setCategory:AVAudioSessionCategoryAmbient error:NULL];
        //Allocate the array that will keep the audio objects in memory.
        mAudiosInMemory=[[NSMutableDictionary alloc]init];
    }
    return self;
}

/**
 * @discussion This function allocates a static SoundManager instance if it is not allocated yet. If it is allocated, it returns the allocated instance. The allocated instance is a static variable, and only one instance will ever exist.
 *
 * @return SoundManager
 */
+(SoundManager*)sharedInstance{
    //Create the Sound manager if it is not null
    static SoundManager *instance = NULL;

    //Check if instance is NULL. If so, allocate it
    if (instance==NULL){
        //Call out private init.
        instance=[[SoundManager alloc] initPrivate];
    }
    
    //Return the static instance of SoundManager
    return instance;
}

/**
 * @discussion This function takes in a sound file and returns TRUE or FALSE if the sound was added succesfullt. It will also store the newly created audio (if successfull) in our audio dictionary.
 *
 * @param NSString. The name of the sound file you would like to add to the SoundManager.
 * @param NSString. The file type of the sound file you would like to add to the SoundManager
 * @return BOOL. If the sound has not been added succesfully.
 */
-(BOOL)addSoundClip:(NSString*)soundFile fileType:(NSString*)fileType{    
    //Get the path to the sound file.
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:soundFile ofType:fileType];
    //Declare the NSError to catch any errors.
    NSError *error;
    //Create the sound/audio.
    AVAudioPlayer* audio = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundFilePath] error:&error];
    //Check if there are any error.
    if (error!=NULL){
        //Log the error.
        NSLog(@"%@", error.localizedDescription);
        return NO;
    }
    //If all is good, we add the audio to our map.
    //Add the audio in our dictionary.
    [mAudiosInMemory setObject:audio forKey:soundFile];
    //Return that all was successfull
    return YES;
}

/**
 * @brief This function you call when you want to play a sound the is already in the manager.
 *
 * @param NSString. The sound file you would like to play.
 * @param NSObject <AVAudioPlayerDelegate> The delegate to detect when the audio has finished playing.
 * @return BOOL. If the sound has been played successfully
 */
-(BOOL)playSound:(NSString*)soundFile delegate:(NSObject<AVAudioPlayerDelegate>*)audioPlayerDelegate{
    //Grab the audio that we have or don't have in memory.
    AVAudioPlayer *player = [mAudiosInMemory objectForKey:soundFile];
    //Check if we did have this audio file in memory
    if (player){
        //If we do, play if and return YES.
        //Pause the player
        [player pause];
        //Set current time to 0
        player.currentTime=0.0f;
        //Play
        [player play];
        //Set the audio delegate
        [player setDelegate:audioPlayerDelegate];
        //Return yes, all good.
        return YES;
    }
    //If we are down here we do not have the sound file in memory and could not play it. Return NO and log an error.
    NSLog(@"Error: The file you are trying to play is not yet in memory. Play add to by calling the function 'addSoundClip'");
    return NO;
}

/**
 * @brief Calling this function will stop all sound that is currently playing
 */
-(void)stopAllSound{
    //Loop through all the audios and stop them
    for (NSString* key in mAudiosInMemory){
        //Gran the audio from the dictionary
        AVAudioPlayer *player = [mAudiosInMemory objectForKey:key];
        //Stop the audio
        [player stop];
        //Reset the time
        player.currentTime=0.0f;
    }
}

@end
