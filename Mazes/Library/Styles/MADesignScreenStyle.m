//
//  MADesignScreenStyle.m
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import "MADesignScreenStyle.h"

#import "MAColors.h"

@implementation MADesignScreenStyle

+ (MADesignScreenStyle *)designScreenStyle
{
    MADesignScreenStyle *designScreenStyle = [[MADesignScreenStyle alloc] init];
    return designScreenStyle;
}

- (id)init
{
    self = [super init];
	
    if (self)
	{
        MAColors *colors = [MAColors colors];
        
        _panelBackgroundColor = colors.lightYellow1Color;
        _tabDarkColor = colors.darkYellowColor;
        
        _tableHeaderBackgroundColor = colors.orangeRedColor;
        _tableHeaderTextColor = colors.whiteColor;
        _tableHeaderTextAlignment = NSTextAlignmentCenter;
        _tableHeaderFont = [UIFont boldSystemFontOfSize: 18];
        
        _tableViewBackgroundColor = colors.whiteColor;
        _tableViewDisabledBackgroundColor = colors.lightGray5Color;
		
        _tableViewBackgroundSoundRows = 4;
        
        _texturesViewBackgroundColor = colors.lightYellow2Color;
        _texturesPopoverWidth = 700.0;
        _texturesPopoverHeight = 750.0;
        _textureImageLength = 100.0;
        _texturesPerRow = 5;
        
        _buttonsViewBackgroundColor = colors.lightYellow1Color;
        
        _messageBackgroundColor = [UIColor clearColor];
        _messageTextColor = colors.darkBlueColor;
    }
    
    return self;
}

@end
