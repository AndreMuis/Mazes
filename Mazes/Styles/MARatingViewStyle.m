//
//  MARatingViewStyle.m
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import "MARatingViewStyle.h"

#import "MAColors.h"

@implementation MARatingViewStyle

- (id)initWithColors: (MAColors *)colors
{
    self = [super init];
	
    if (self)
	{
        _popupBackgroundColor = colors.lightYellowColor;
        
        _averageRatingStarColor = colors.redColor;
        _userRatingStarColor = colors.blueColor;
        _mazeFinishedStarColor = colors.yellowColor;
    }
  
    return self;
}

@end
