//
//  MapStyle.m
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MapStyle.h"

@implementation MapStyle

@synthesize length;
@synthesize wallWidth;
@synthesize squareWidth;
@synthesize backgroundColor;
@synthesize doNothingColor;
@synthesize startColor;
@synthesize endColor;
@synthesize startOverColor;
@synthesize teleportationColor;
@synthesize wallColor;
@synthesize noWallColor;
@synthesize invisibleColor;	

- (id)init
{
    self = [super init];
	
    if (self)
	{
        self.wallWidth = 3.0;
        self.squareWidth = 15.0;
        self.length = self.squareWidth * [Constants instance].columnsMax + self.wallWidth * ([Constants instance].columnsMax + 1); 
		
        self.backgroundColor = [[UIColor alloc] initWithRed: 0.81 green: 0.81 blue: 0.81 alpha: 1.0];
        
        self.doNothingColor =  [Colors instance].whiteColor;
        self.startColor = [Colors instance].greenColor;
        self.endColor = [Colors instance].redColor;
        self.startOverColor = [Colors instance].lightPurpleColor;
        self.teleportationColor = [Colors instance].lightOrangeColor;
        
        self.wallColor = [Colors instance].blackColor;
        self.noWallColor = [Colors instance].whiteColor;
        self.invisibleColor = [[UIColor alloc] initWithRed: 0.7 green: 0.7 blue: 0.7 alpha: 1.0];
    }
    
    return self;
}

@end
