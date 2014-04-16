//
//  MAGameScreenStyle.m
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import "MAGameScreenStyle.h"

#import "MAColors.h"

@implementation MAGameScreenStyle

+ (MAGameScreenStyle *)gameScreenStyle
{
    MAGameScreenStyle *gameScreenStyle = [[MAGameScreenStyle alloc] init];
    return gameScreenStyle;
}

- (id)init
{
    self = [super init];
	
    if (self)
	{
        MAColors *colors = [MAColors colors];

        _titleBackgroundColor = [UIColor clearColor];
        _titleFont = [UIFont boldSystemFontOfSize: 19];
        _titleTextColor = colors.darkBrown1Color;
        
        _instructionsBackgroundColor = colors.lightYellow2Color;
        _instructionsTextColor = colors.darkBrown2Color;
        
        _borderColor = colors.lightBrownColor;
        
        _messageBackgroundColor = colors.lightYellow2Color;
        _messageTextColor = colors.darkBrown2Color;
    }
    
    return self;
}

@end
