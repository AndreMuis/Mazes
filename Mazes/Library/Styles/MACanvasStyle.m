//
//  MACanvasStyle.m
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import "MACanvasStyle.h"

#import "MAColors.h"

@implementation MACanvasStyle

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
        
        _borderColor = colors.lightGray1Color;
        _backgroundColor = [UIColor clearColor];
        
        _doNothingColor = colors.whiteColor;
        _startColor = colors.greenColor;
        _endColor = colors.redColor;
        _startOverColor = colors.purpleColor;
        _teleportationColor = colors.orangeColor;
        _messageColor = colors.lightGray4Color;
        
        _arrowColor = colors.blueColor;
        
        _textureHighlightColor = colors.lightYellow1Color;
        _locationHighlightColor = colors.yellowColor;
        
        _teleportFontSize = 27.0;
        _teleportIdColor = colors.whiteOpaqueColor;
        
        _noWallColor = colors.whiteColor;
        _solidColor = colors.blueColor;
        _invisibleColor = colors.lightGray2Color;
        _fakeColor = colors.redColor;
        
        _cornerColor = colors.darkBlueColor;
    }
    
    return self;
}

@end
