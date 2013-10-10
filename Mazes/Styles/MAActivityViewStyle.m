//
//  MAActivityViewStyle.m
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import "MAActivityViewStyle.h"

#import "MAColors.h"

@implementation MAActivityViewStyle

- (id)initWithColors: (MAColors *)colors
{
    self = [super init];

    if (self)
	{
        _color = colors.darkGrayColor;
    }
                      
    return self;
}

@end
