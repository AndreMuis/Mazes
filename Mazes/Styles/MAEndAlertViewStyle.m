//
//  MAEndAlertViewStyle.m
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import "MAEndAlertViewStyle.h"

#import "MAColors.h"

@implementation MAEndAlertViewStyle

- (id)initWithColors: (MAColors *)colors
{
    self = [super init];
	
    if (self)
	{
        _textColor = colors.whiteColor;
    }
    
    return self;
}

@end
