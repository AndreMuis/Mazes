//
//  RatingViewStyle.m
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import "RatingViewStyle.h"

@implementation RatingViewStyle

- (id)init
{
    self = [super init];
	
    if (self)
	{
        _popupBackgroundColor = [Colors shared].lightYellowColor;
        
        _averageRatingStarColor = [Colors shared].redColor;
        _userRatingStarColor = [Colors shared].blueColor;
        _mazeFinishedStarColor = [Colors shared].yellowColor;
    }
  
    return self;
}

@end
