//
//  MAEditViewStyle.m
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import "MAEditViewStyle.h"

#import "MAColors.h"

@implementation MAEditViewStyle

- (id)initWithColors: (MAColors *)colors
{
    self = [super init];
	
    if (self)
	{
        _panelBackgroundColor = [[UIColor alloc] initWithRed: 1.0 green: 0.96 blue: 0.65 alpha: 1.0];
        _tabDarkColor = [[UIColor alloc] initWithRed: 0.96 green: 0.87 blue: 0.0 alpha: 1.0];
        
        _tableHeaderBackgroundColor = colors.orangeRedColor;
        _tableHeaderTextColor = [UIColor whiteColor];
        _tableHeaderTextAlignment = NSTextAlignmentCenter;
        _tableHeaderFont = [UIFont boldSystemFontOfSize: 18];
        
        _tableViewBackgroundColor = colors.whiteColor;
        _tableViewDisabledBackgroundColor = [[UIColor alloc] initWithRed: 0.9 green: 0.9 blue: 0.9 alpha: 1.0]; // light gray
		
        _tableViewBackgroundSoundRows = 4;
        
        _texturesViewBackgroundColor = colors.lightYellowColor;
        _texturesPopoverWidth = 700.0;
        _texturesPopoverHeight = 700.0;
        _textureImageLength = 100.0;
        _texturesPerRow = 5;
        
        _buttonsViewBackgroundColor = [[UIColor alloc] initWithRed: 1.0 green: 0.96 blue: 0.65 alpha: 1.0];
        
        _messageBackgroundColor = [UIColor clearColor];
        _messageTextColor = colors.darkBlueColor;
    }
    
    return self;
}

@end
