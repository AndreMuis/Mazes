//
//  MAColors.m
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import "MAColors.h"

@implementation MAColors

+ (MAColors *)colors
{
    MAColors *colors = [[MAColors alloc] init];
    return colors;
}

- (id)init
{
    self = [super init];
	
	if (self) 
	{
        _blackColor = [UIColor blackColor];
        
        _whiteColor  = [UIColor whiteColor];
        _whiteOpaqueColor = [UIColor colorWithWhite: 1.0 alpha: 0.75];
    
        _grayColor = [UIColor colorWithWhite: 0.5 alpha: 1.0];
        _lightGray1Color = [UIColor colorWithWhite: 0.6 alpha: 1.0];
        _lightGray2Color = [UIColor colorWithWhite: 0.7 alpha: 1.0];
        _lightGray3Color = [UIColor colorWithWhite: 0.8 alpha: 1.0];
        _lightGray4Color = [UIColor colorWithWhite: 0.85 alpha: 1.0];
        _lightGray5Color = [UIColor colorWithWhite: 0.9 alpha: 1.0];
        
        _brownColor = [UIColor colorWithRed: 0.6 green: 0.4 blue: 0.2 alpha: 1.0];
        _lightBrownColor = [UIColor colorWithRed: 0.89 green: 0.78 blue: 0.55 alpha: 1.0];
        _darkBrown1Color = [UIColor colorWithRed: 0.5 green: 0.25 blue: 0.0 alpha: 1.0];
        _darkBrown2Color = [UIColor colorWithRed: 0.3 green: 0.15 blue: 0.0 alpha: 1.0];
        
        _redColor = [UIColor redColor];
        _greenColor = [UIColor greenColor];
        
        _blueColor = [UIColor colorWithRed: 0.0 green: 0.0 blue: 1.0 alpha: 1.0];
        _darkBlueColor = [UIColor colorWithRed: 0.0 green: 0.0 blue: 0.60 alpha: 1.0];
        
        _yellowColor = [UIColor colorWithRed: 1.0 green: 1.0 blue: 0.0 alpha: 1.0];
        _lightYellow1Color = [UIColor colorWithRed: 1.0 green: 1.0 blue: 0.65 alpha: 1.0];
        _lightYellow2Color = [UIColor colorWithRed: 1.0 green: 1.0 blue: 0.9 alpha: 1.0];
        _darkYellowColor = [UIColor colorWithRed: 0.83 green: 0.83 blue: 0.54 alpha: 1.0];
        
        _orangeColor = [UIColor colorWithRed: 1.0 green: 0.5 blue: 0.0 alpha: 1.0];
        _lightOrange1Color = [UIColor colorWithRed: 1.0 green: 0.65 blue: 0.3 alpha: 1.0];
        _lightOrange2Color = [UIColor colorWithRed: 1.0 green: 0.80 blue: 0.45 alpha: 1.0];
        _lightOrange3Color = [UIColor colorWithRed: 1.0 green: 0.96 blue: 0.87 alpha: 1.0];
        
        _orangeRedColor = [UIColor colorWithRed: 1.0 green: 0.37 blue: 0.0 alpha: 1.0];
        
        _purpleColor = [UIColor colorWithRed: 0.5 green: 0.0 blue: 0.5 alpha: 1.0];
        _lightPurpleColor = [UIColor colorWithRed: 0.65 green: 0.3 blue: 0.65 alpha: 1.0];
    
        _backgroundColor = self.lightOrange3Color;
    }
	
    return self;
}

@end











