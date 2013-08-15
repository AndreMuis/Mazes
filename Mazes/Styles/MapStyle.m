//
//  MapStyle.m
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import "MapStyle.h"

@implementation MapStyle

- (id)init
{
    self = [super init];
	
    if (self)
	{
        self.wallWidth = 3.0;
        self.squareWidth = 15.0;
        self.length = self.squareWidth * [MAConstants shared].columnsMax + self.wallWidth * ([MAConstants shared].columnsMax + 1);
		
        self.backgroundColor = [[UIColor alloc] initWithRed: 0.81 green: 0.81 blue: 0.81 alpha: 1.0];
        
        self.doNothingColor =  [Colors shared].whiteColor;
        self.startColor = [Colors shared].greenColor;
        self.endColor = [Colors shared].redColor;
        self.startOverColor = [Colors shared].lightPurpleColor;
        self.teleportationColor = [Colors shared].lightOrangeColor;
        
        self.wallColor = [Colors shared].blackColor;
        self.noWallColor = [Colors shared].whiteColor;
        self.invisibleColor = [[UIColor alloc] initWithRed: 0.7 green: 0.7 blue: 0.7 alpha: 1.0];
    }
    
    return self;
}

@end
