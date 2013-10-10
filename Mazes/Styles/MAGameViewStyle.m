//
//  MAGameViewStyle.m
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import "MAGameViewStyle.h"

#import "MAColors.h"

@implementation MAGameViewStyle

- (id)initWithColors: (MAColors *)colors
{
    self = [super init];
	
    if (self)
	{
        _titleBackgroundColor = [UIColor clearColor];
        _titleFont = [UIFont boldSystemFontOfSize: 19];
        _titleTextColor = [[UIColor alloc] initWithRed: 0.5 green: 0.25 blue: 0.0 alpha: 1.0]; // brown
        
        _helpBackgroundColor = colors.lightYellowColor;
        _helpTextColor = colors.darkBrownColor;
        
        _borderColor = [[UIColor alloc] initWithRed: 227.0 / 256.0 green: 200.0 / 256.0 blue: 142.0 / 256.0 alpha: 1.0];
        _messageBackgroundColor = colors.lightYellowColor;
        _messageTextColor = colors.darkBrownColor;
    }
    
    return self;
}

@end
