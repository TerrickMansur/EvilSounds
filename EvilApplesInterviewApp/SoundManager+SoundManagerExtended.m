//
//  SoundManager+SoundManagerExtended.m
//  EvilApplesInterviewApp
//
//  Created by Terrick Mansur on 2/10/16.
//  Copyright © 2016 Terrick Mansur. All rights reserved.
//

#import "SoundManager+SoundManagerExtended.h"

@implementation SoundManager (SoundManagerExtended)

/**
 * @brief This function allows the user to play multiple sounds at once with one call.
 *
 * @param NSArray. The array of sound files to play.
 * @param NSObject <AVAudioPlayerDelegate> The delegate to detect when the audio has finished playing.
 * @return BOOL. If the sound has been played successfully
 */
-(BOOL)playSounds:(NSArray*)soundFiles delegate:(NSObject<AVAudioPlayerDelegate>*)audioPlayerDelegate{
    BOOL iallSoundPlayedSuccesfully = YES;
    //Loop through and play all the sounds together.
    for (NSString *file in soundFiles){
        if(![self playSound:file delegate:audioPlayerDelegate])
            iallSoundPlayedSuccesfully=NO;
    }
    //Return the result
    return iallSoundPlayedSuccesfully;
}

@end
