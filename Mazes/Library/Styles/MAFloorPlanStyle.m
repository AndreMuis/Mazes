//
//  MAFloorPlanStyle.m
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import "MAFloorPlanStyle.h"

#import "MAColors.h"

@implementation MAFloorPlanStyle

+ (MAFloorPlanStyle *)floorPlanStyle
{
    MAFloorPlanStyle *floorPlanStyle = [[MAFloorPlanStyle alloc] init];
    return floorPlanStyle;
}

- (id)init
{
    self = [super init];
	
    if (self)
	{
        MAColors *colors = [MAColors colors];

        _borderColor = colors.lightGray1Color;

     	_segmentLengthShort = 16.0;
        _segmentLengthLong = 34.0;
        
        _doNothingColor = colors.whiteColor;
        _startColor = colors.greenColor;
        _endColor = colors.redColor;
        _startOverColor = colors.purpleColor;
        _teleportationColor = colors.orangeColor;
        _messageColor = colors.lightGray4Color;
        
        _arrowColor = colors.blueColor;
        
        _teleportFont = [UIFont boldSystemFontOfSize: 27.0];
        _teleportIdColor = colors.whiteTranslucentColor;
        
        _noWallColor = colors.whiteColor;
        _solidColor = colors.blueColor;
        _invisibleColor = colors.lightGray2Color;
        _fakeColor = colors.redColor;
        
        _highlightColor = colors.yellowColor;
        _textureHighlightColor = colors.darkGreenColor;

        _locationHighlightWidth = 5.0;
        _wallHighlightWidth = 3.0;

        _cornerColor = colors.darkBlueColor;
    }
    
    return self;
}

@end
