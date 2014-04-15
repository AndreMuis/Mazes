//
//  MAFoundExitPopupStyle.m
//  Mazes
//
//  Created by Andre Muis on 10/20/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import "MAFoundExitPopupStyle.h"

#import "MAColors.h"

@implementation MAFoundExitPopupStyle

+ (MAFoundExitPopupStyle *)foundExitPopupStyle
{
    MAFoundExitPopupStyle *foundExitPopupStyle = [[MAFoundExitPopupStyle alloc] init];
    return foundExitPopupStyle;
}

- (id)init
{
    self = [super init];
	
    if (self)
	{
        MAColors *colors = [MAColors colors];

        _ratingStarColor = colors.blueColor;
        
        _textColor = colors.darkBrown1Color;
        _font = [UIFont boldSystemFontOfSize: 20.0];
    }
    
    return self;
}

@end
