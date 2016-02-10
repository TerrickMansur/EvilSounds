//
//  SoundManager.h
//  EvilApplesInterviewApp
//
//  Created by Terrick Mansur on 2/9/16.
//  Copyright © 2016 Terrick Mansur. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

//Forward declaration
@class AVAudioSession;

@interface SoundManager : NSObject{
    //The sound session for this singleton
    AVAudioSession *mAudioSession;
    //Audio dictionary. This array keeps all the audios in memory for playback at a later time.
    NSMutableDictionary *mAudiosInMemory;
}

/**
 * @discussion This function allocates a static SoundManager instance if it is not allocated yet. If it is allocated, it returns the allocated instance. The allocated instance is a static variable, and only one instance will ever exist.
 *
 * @return SoundManager
 */
+(SoundManager*)sharedInstance;

/**
 * @discussion This function takes in a sound file and returns TRUE or FALSE if the sound was added succesfullt. It will also store the newly created audio (if successfull) in our audio dictionary.
 *
 * @param NSString. The name of the sound file you would like to add to the SoundManager.
 * @param NSString. The file type of the sound file you would like to add to the SoundManager
 * @return BOOL. If the sound has not been added succesfully.
 */
-(BOOL)addSoundClip:(NSString*)soundFile fileType:(NSString*)fileType;

/**
 * @discussion This function you call when you want to play a sound the is already in the manager.
 *
 * @param NSString. The sound file you would like to play.
 * @param NSObject <AVAudioPlayerDelegate> The delegate to detect when the audio has finished playing.
 * @return BOOL. If the sound has been played successfully
 */
-(BOOL)playSound:(NSString*)soundFile delegate:(NSObject<AVAudioPlayerDelegate>*)audioPlayerDelegate;

/**
 * @brief Calling this function will stop all sound that is currently playing
 */
-(void)stopAllSound;

@end
