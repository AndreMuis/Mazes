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

- (id)initWithConstants: (MAConstants *)constants colors: (MAColors *)colors
{
    self = [super init];
	
    if (self)
	{
        _wallWidth = 3.0;
        _squareWidth = 15.0;
        _length = _squareWidth * constants.columnsMax + _wallWidth * (constants.columnsMax + 1);
		
        _backgroundColor = [[UIColor alloc] initWithRed: 0.81 green: 0.81 blue: 0.81 alpha: 1.0];
        
        _doNothingColor = colors.whiteColor;
        _startColor = colors.greenColor;
        _endColor = colors.redColor;
        _startOverColor = colors.lightPurpleColor;
        _teleportationColor = colors.lightOrangeColor;
        
        _wallColor = colors.blackColor;
        _noWallColor = colors.whiteColor;
        _invisibleColor = [[UIColor alloc] initWithRed: 0.7 green: 0.7 blue: 0.7 alpha: 1.0];
    }
    
    return self;
}

@end
