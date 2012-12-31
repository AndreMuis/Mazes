//
//  Colors.m
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import "Colors.h"

@implementation Colors

+ (Colors *)shared
{
	static Colors *shared = nil;
	
	@synchronized(self)
	{
		if (shared == nil)
		{
			shared = [[Colors alloc] init];
		}
	}
	
	return shared;
}

- (id)init
{
    self = [super init];
	
	if (self) 
	{
        _transparentColor = [[UIColor alloc] initWithRed: 1.0 green: 1.0 blue: 1.0 alpha: 0.0];
        
        _blackColor = [[UIColor alloc] initWithRed: 0.0 green: 0.0 blue: 0.0 alpha: 1.0];
        
        _whiteColor  = [[UIColor alloc] initWithRed: 1.0 green: 1.0 blue: 1.0 alpha: 1.0];
        _whiteOpaqueColor = [[UIColor alloc] initWithRed: 1.0 green: 1.0 blue: 1.0 alpha: 0.75];
        
        _lightGrayColor = [[UIColor alloc] initWithRed: 0.9 green: 0.9 blue: 0.9 alpha: 1.0];
        _darkGrayColor = [[UIColor alloc] initWithRed: 0.6 green: 0.6 blue: 0.6 alpha: 1.0];
        
        _darkBrownColor = [[UIColor alloc] initWithRed: 0.3 green: 0.15 blue: 0.0 alpha: 1.0];
        
        _redColor = [[UIColor alloc] initWithRed: 1.0 green: 0.0 blue: 0.0 alpha: 1.0];
        _greenColor = [[UIColor alloc] initWithRed: 0.0 green: 1.0 blue: 0.0 alpha: 1.0];
        
        _blueColor = [[UIColor alloc] initWithRed: 0.0 green: 0.0 blue: 1.0 alpha: 1.0];
        _darkBlueColor = [[UIColor alloc] initWithRed: 0.0 green: 0.0 blue: 0.60 alpha: 1.0];
        
        _lightYellowColor = [[UIColor alloc] initWithRed: 1.0 green: 1.0 blue: 0.9 alpha: 1.0];
        _yellowColor = [[UIColor alloc] initWithRed: 1.0 green: 1.0 blue: 0.0 alpha: 1.0];
        _darkYellowColor = [[UIColor alloc] initWithRed: 0.8 green: 0.8 blue: 0.6 alpha: 1.0];
        
        _orangeColor = [[UIColor alloc] initWithRed: 1.0 green: 0.5 blue: 0.0 alpha: 1.0];
        _lightOrangeColor = [[UIColor alloc] initWithRed: 1.0 green: 0.65 blue: 0.3 alpha: 1.0];
        _orangeRedColor = [[UIColor alloc] initWithRed: 1.0 green: 0.37 blue: 0.0 alpha: 1.0];
        
        _purpleColor = [[UIColor alloc] initWithRed: 0.5 green: 0.0 blue: 0.5 alpha: 1.0];
        _lightPurpleColor = [[UIColor alloc] initWithRed: 0.65 green: 0.3 blue: 0.65 alpha: 1.0];
    }
	
    return self;
}

@end
