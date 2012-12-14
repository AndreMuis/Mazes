//
//  Colors.m
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Colors.h"

@implementation Colors

@synthesize transparentColor;
@synthesize blackColor; 
@synthesize whiteColor;
@synthesize whiteOpaqueColor; 
@synthesize lightGrayColor;
@synthesize darkGrayColor;
@synthesize darkBrownColor; 
@synthesize redColor;
@synthesize greenColor; 
@synthesize blueColor;
@synthesize darkBlueColor; 
@synthesize lightYellowColor; 
@synthesize yellowColor;
@synthesize darkYellowColor; 
@synthesize orangeColor;
@synthesize lightOrangeColor; 
@synthesize orangeRedColor;
@synthesize purpleColor;
@synthesize lightPurpleColor;

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
        transparentColor = [[UIColor alloc] initWithRed: 1.0 green: 1.0 blue: 1.0 alpha: 0.0];	
        
        blackColor = [[UIColor alloc] initWithRed: 0.0 green: 0.0 blue: 0.0 alpha: 1.0];		
        
        whiteColor  = [[UIColor alloc] initWithRed: 1.0 green: 1.0 blue: 1.0 alpha: 1.0];
        whiteOpaqueColor = [[UIColor alloc] initWithRed: 1.0 green: 1.0 blue: 1.0 alpha: 0.75];
        
        lightGrayColor = [[UIColor alloc] initWithRed: 0.9 green: 0.9 blue: 0.9 alpha: 1.0];
        darkGrayColor = [[UIColor alloc] initWithRed: 0.6 green: 0.6 blue: 0.6 alpha: 1.0];
        
        darkBrownColor = [[UIColor alloc] initWithRed: 0.3 green: 0.15 blue: 0.0 alpha: 1.0];
        
        redColor = [[UIColor alloc] initWithRed: 1.0 green: 0.0 blue: 0.0 alpha: 1.0];
        greenColor = [[UIColor alloc] initWithRed: 0.0 green: 1.0 blue: 0.0 alpha: 1.0];
        
        blueColor = [[UIColor alloc] initWithRed: 0.0 green: 0.0 blue: 1.0 alpha: 1.0];
        darkBlueColor = [[UIColor alloc] initWithRed: 0.0 green: 0.0 blue: 0.60 alpha: 1.0];
        
        lightYellowColor = [[UIColor alloc] initWithRed: 1.0 green: 1.0 blue: 0.9 alpha: 1.0];
        yellowColor = [[UIColor alloc] initWithRed: 1.0 green: 1.0 blue: 0.0 alpha: 1.0];
        darkYellowColor = [[UIColor alloc] initWithRed: 0.8 green: 0.8 blue: 0.6 alpha: 1.0];
        
        orangeColor = [[UIColor alloc] initWithRed: 1.0 green: 0.5 blue: 0.0 alpha: 1.0];
        lightOrangeColor = [[UIColor alloc] initWithRed: 1.0 green: 0.65 blue: 0.3 alpha: 1.0];
        orangeRedColor = [[UIColor alloc] initWithRed: 1.0 green: 0.37 blue: 0.0 alpha: 1.0];
        
        purpleColor = [[UIColor alloc] initWithRed: 0.5 green: 0.0 blue: 0.5 alpha: 1.0];
        lightPurpleColor = [[UIColor alloc] initWithRed: 0.65 green: 0.3 blue: 0.65 alpha: 1.0];
    }
	
    return self;
}

@end
