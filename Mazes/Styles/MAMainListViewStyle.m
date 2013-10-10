//
//  MAMainListViewStyle.m
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import "MAMainListViewStyle.h"

#import "MAColors.h"

@implementation MAMainListViewStyle

- (id)initWithColors: (MAColors *)colors
{
    self = [super init];
	
    if (self)
	{
        _tableBackgroundColor = [UIColor clearColor];
        _textColor = colors.darkBrownColor;
    }
    
    return self;
}

@end
