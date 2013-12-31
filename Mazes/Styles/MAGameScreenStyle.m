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

- (id)initWithColors: (MAColors *)colors
{
    self = [super init];
	
    if (self)
	{
        _titleBackgroundColor = [UIColor clearColor];
        _titleFont = [UIFont boldSystemFontOfSize: 19];
        _titleTextColor = colors.darkBrown1Color;
        
        _helpBackgroundColor = colors.lightYellow2Color;
        _helpTextColor = colors.darkBrown2Color;
        
        _borderColor = colors.lightBrownColor;
        
        _messageBackgroundColor = colors.lightYellow2Color;
        _messageTextColor = colors.darkBrown2Color;
    }
    
    return self;
}

@end
