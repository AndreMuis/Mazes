//
//  MAMainScreenStyle.m
//  Mazes
//
//  Created by Andre Muis on 12/28/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import "MAMainScreenStyle.h"

@implementation MAMainScreenStyle

+ (MAMainScreenStyle *)mainScreenStyle
{
    MAMainScreenStyle *mainScreenStyle = [[MAMainScreenStyle alloc] init];
    return mainScreenStyle;
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        _transitionDuration = 0.5;
    }
    
    return self;
}

@end
