//
//  MAGridStyle.m
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import "MAGridStyle.h"

#import "MAColors.h"

@implementation MAGridStyle

- (id)initWithColors: (MAColors *)colors
{
    self = [super init];
	
    if (self)
	{
     	_segmentLengthShort = 15.0;
        _segmentLengthLong = 33.0;
        
        _textureHighlightWidth = 3.0;
        _locationHighlightWidth = 5.0;
        _wallHighlightWidth = 3.0;
        
        _borderColor = colors.darkGrayColor;
        _backgroundColor = [UIColor clearColor];
        
        _doNothingColor = colors.whiteColor;
        _startColor = colors.greenColor;
        _endColor = colors.redColor;
        _startOverColor = colors.purpleColor;
        _teleportationColor = colors.orangeColor;
        _messageColor = [[UIColor alloc] initWithRed: 0.85 green: 0.85 blue: 0.85 alpha: 1.0];
        
        _arrowColor = colors.blueColor;
        
        _textureHighlightColor = [[UIColor alloc] initWithRed: 1.0 green: 1.0 blue: 0.5 alpha: 1.0];
        _locationHighlightColor = colors.yellowColor;
        
        _teleportFontSize = 27.0;
        _teleportIdColor = colors.whiteOpaqueColor;
        
        _noWallColor = colors.whiteColor;
        _solidColor = colors.blueColor;
        _invisibleColor = [[UIColor alloc] initWithRed: 0.7 green: 0.7 blue: 0.7 alpha: 1.0];
        _fakeColor = colors.redColor;
        
        _cornerColor = colors.darkBlueColor;
    }
    
    return self;
}

@end
