//
//  ScreenList.h
//  EvilApplesInterviewApp
//
//  Created by Terrick Mansur on 2/9/16.
//  Copyright © 2016 Terrick Mansur. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScreenList : NSObject

/**
 * @brief This function get the list of screens we want to show on the iCarousel.
 *
 * @return NSArray. Returns the array of dictionary defining the screen/gifs with their respective audio.
 */
+(NSArray*)getScreenList;

@end
