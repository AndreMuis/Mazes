//
//  MARatingPopoverStyle.m
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import "MARatingPopoverStyle.h"

#import "MAColors.h"

@implementation MARatingPopoverStyle

+ (MARatingPopoverStyle *)ratingPopoverStyle
{
    MARatingPopoverStyle *ratingPopoverStyle = [[MARatingPopoverStyle alloc] init];
    return ratingPopoverStyle;
}

- (id)init
{
    self = [super init];
	
    if (self)
	{
        MAColors *colors = [MAColors colors];

        _backgroundColor = colors.lightYellow2Color;
    }
  
    return self;
}

@end
