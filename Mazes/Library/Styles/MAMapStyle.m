//
//  MAMapStyle.m
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import "MAMapStyle.h"

#import "MAColors.h"
#import "MAConstants.h"

@implementation MAMapStyle

- (id)initWithColors: (MAColors *)colors
{
    self = [super init];
	
    if (self)
	{
        _wallWidth = 3.0;
        _squareWidth = 15.0;
        _length = _squareWidth * MAColumnsMax + _wallWidth * (MAColumnsMax + 1);
		
        _backgroundColor = colors.lightGray3Color;
        
        _doNothingColor = colors.whiteColor;
        _startColor = colors.greenColor;
        _endColor = colors.redColor;
        _startOverColor = colors.lightPurpleColor;
        _teleportationColor = colors.lightOrange1Color;
        
        _wallColor = colors.blackColor;
        _noWallColor = colors.whiteColor;
        _invisibleColor = colors.lightGray2Color;
    }
    
    return self;
}

@end
