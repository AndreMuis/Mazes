//
//  MAPopupStyle.m
//  Mazes
//
//  Created by Andre Muis on 10/20/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import "MAPopupStyle.h"

#import "MAColors.h"

@implementation MAPopupStyle

+ (MAPopupStyle *)popupStyle
{
    MAPopupStyle *popupStyle = [[MAPopupStyle alloc] init];
    return popupStyle;
}

- (id)init
{
    self = [super init];
	
    if (self)
	{
        MAColors *colors = [MAColors colors];

        _translucentBackgroundColor = [UIColor colorWithWhite: 0.0 alpha: 0.15];

        _backgroundColor = colors.lightYellow1Color;
        
        _cornerRadius = 20.0;
        _borderWidth = 7.0;
        _borderColor = colors.orangeColor;
        
        _initialScale = 0.001;
        
        _initialAnimationDuration = 0.5;
        _otherAnimationDuration = 0.2;
        
        _bounceScalePercent = 0.2;
    }
    
    return self;
}

@end
