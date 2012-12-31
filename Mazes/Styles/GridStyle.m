//
//  GridStyle.m
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import "GridStyle.h"

@implementation GridStyle

- (id)init
{
    self = [super init];
	
    if (self)
	{
     	self.segmentLengthShort = 15.0;
        self.segmentLengthLong = 33.0;
        
        self.textureHighlightWidth = 3.0;
        self.locationHighlightWidth = 5.0;
        self.wallHighlightWidth = 3.0;
        
        self.borderColor = [Colors shared].darkGrayColor;
        self.backgroundColor = [Colors shared].transparentColor;
        
        self.doNothingColor = [Colors shared].whiteColor;
        self.startColor = [Colors shared].greenColor;
        self.endColor = [Colors shared].redColor;
        self.startOverColor = [Colors shared].purpleColor;
        self.teleportationColor = [Colors shared].orangeColor;
        self.messageColor = [[UIColor alloc] initWithRed: 0.85 green: 0.85 blue: 0.85 alpha: 1.0];
        
        self.arrowColor = [Colors shared].blueColor;
        
        self.textureHighlightColor = [[UIColor alloc] initWithRed: 1.0 green: 1.0 blue: 0.5 alpha: 1.0];
        self.locationHighlightColor = [Colors shared].yellowColor;
        
        self.teleportFontSize = 27.0;
        self.teleportIdColor = [Colors shared].whiteOpaqueColor;
        
        self.noWallColor = [Colors shared].whiteColor;
        self.solidColor = [Colors shared].blueColor;
        self.invisibleColor = [[UIColor alloc] initWithRed: 0.7 green: 0.7 blue: 0.7 alpha: 1.0];
        self.fakeColor = [Colors shared].redColor;
        
        self.cornerColor = [Colors shared].darkBlueColor;   
    }
    
    return self;
}

@end
