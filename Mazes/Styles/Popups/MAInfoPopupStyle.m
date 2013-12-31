//
//  MAInfoPopupStyle.m
//  Mazes
//
//  Created by Andre Muis on 10/20/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import "MAInfoPopupStyle.h"

#import "MAColors.h"

@implementation MAInfoPopupStyle

- (id)initWithColors: (MAColors *)colors
{
    self = [super init];
	
    if (self)
	{
        _textColor = colors.darkBrown1Color;
        _font = [UIFont boldSystemFontOfSize: 20.0];
    }
    
    return self;
}

@end
