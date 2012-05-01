//
//  GridStyle.m
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GridStyle.h"

@implementation GridStyle

@synthesize segmentLengthShort;
@synthesize segmentLengthLong;
@synthesize textureHighlightWidth;
@synthesize locationHighlightWidth;
@synthesize wallHighlightWidth;
@synthesize borderColor;
@synthesize backgroundColor;
@synthesize doNothingColor;
@synthesize startColor;
@synthesize endColor;
@synthesize startOverColor;
@synthesize teleportationColor;
@synthesize messageColor;
@synthesize arrowColor;
@synthesize textureHighlightColor;
@synthesize locationHighlightColor;
@synthesize teleportFontSize;
@synthesize teleportIdColor;
@synthesize noWallColor;
@synthesize solidColor;
@synthesize invisibleColor;
@synthesize fakeColor;	
@synthesize cornerColor;

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
        
        self.borderColor = [Colors instance].darkGrayColor;
        self.backgroundColor = [Colors instance].transparentColor;
        
        self.doNothingColor = [Colors instance].whiteColor;
        self.startColor = [Colors instance].greenColor;
        self.endColor = [Colors instance].redColor;
        self.startOverColor = [Colors instance].purpleColor;
        self.teleportationColor = [Colors instance].orangeColor;
        self.messageColor = [[UIColor alloc] initWithRed: 0.85 green: 0.85 blue: 0.85 alpha: 1.0];
        
        self.arrowColor = [Colors instance].blueColor;
        
        self.textureHighlightColor = [[UIColor alloc] initWithRed: 1.0 green: 1.0 blue: 0.5 alpha: 1.0];
        self.locationHighlightColor = [Colors instance].yellowColor;
        
        self.teleportFontSize = 27.0;
        self.teleportIdColor = [Colors instance].whiteOpaqueColor;
        
        self.noWallColor = [Colors instance].whiteColor;
        self.solidColor = [Colors instance].blueColor;
        self.invisibleColor = [[UIColor alloc] initWithRed: 0.7 green: 0.7 blue: 0.7 alpha: 1.0];
        self.fakeColor = [Colors instance].redColor;
        
        self.cornerColor = [Colors instance].darkBlueColor;   
    }
    
    return self;
}

@end
