//
//  ScreenList.m
//  EvilApplesInterviewApp
//
//  Created by Terrick Mansur on 2/9/16.
//  Copyright © 2016 Terrick Mansur. All rights reserved.
//

#import "ScreenList.h"

@implementation ScreenList

/**
 * @brief This function get the list of screens we want to show on the iCarousel.
 *
 * @return NSArray. Returns the array of dictionary defining the screen/gifs with their respective audio.
 */
+(NSArray*)getScreenList{
    //Return the list in the ScreenList.plist
    return [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ScreenList" ofType:@"plist"]];
}

@end
