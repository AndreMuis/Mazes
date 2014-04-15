//
//  MATopMazesScreenStyle.m
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import "MATopMazesScreenStyle.h"

#import "MAColors.h"

@implementation MATopMazesScreenStyle

+ (MATopMazesScreenStyle *)topMazesScreenStyle
{
    MATopMazesScreenStyle *topMazesScreenStyle = [[MATopMazesScreenStyle alloc] init];
    return topMazesScreenStyle;
}

- (id)init
{
    self = [super init];
	
    if (self)
	{
        MAColors *colors = [MAColors colors];

        _tableBackgroundColor = [UIColor clearColor];
        _textColor = colors.darkBrown2Color;
        
        _averageRatingStarColor = colors.redColor;
        _userRatingStarColor = colors.blueColor;
    }
    
    return self;
}

@end
