//
//  MARatingPopupStyle.m
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import "MARatingPopupStyle.h"

#import "MAColors.h"

@implementation MARatingPopupStyle

+ (MARatingPopupStyle *)ratingPopupStyle
{
    MARatingPopupStyle *ratingPopupStyle = [[MARatingPopupStyle alloc] init];
    return ratingPopupStyle;
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
