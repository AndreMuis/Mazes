//
//  MAActivityIndicatorStyle.m
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import "MAActivityIndicatorStyle.h"

#import "MAColors.h"

@implementation MAActivityIndicatorStyle

+ (MAActivityIndicatorStyle *)activityIndicatorStyle
{
    MAActivityIndicatorStyle *activityIndicatorStyle = [[MAActivityIndicatorStyle alloc] init];
    return activityIndicatorStyle;
}

- (id)init
{
    self = [super init];

    if (self)
    {
        MAColors *colors = [MAColors colors];
        
        _color = colors.lightGray1Color;
    }
                      
    return self;
}

@end
