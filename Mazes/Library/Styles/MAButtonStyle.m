//
//  MAButtonStyle.m
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import "MAButtonStyle.h"

#import "MAColors.h"

@implementation MAButtonStyle

+ (MAButtonStyle *)buttonStyle
{
    MAButtonStyle *buttonStyle = [[MAButtonStyle alloc] init];
    return buttonStyle;
}

- (id)init
{
    self = [super init];

    if (self)
    {
        MAColors *colors = [MAColors colors];
        
        _backgroundColor = colors.lightYellow1Color;
        _borderWidth = 3.0;
        _borderColor = colors.lightOrange1Color;
        _cornerRadius = 8.0;
        
        _titleColor = colors.blueColor;
        _titleFont = [UIFont boldSystemFontOfSize: 17.0];
        
        _activityIndicatorStyle = UIActivityIndicatorViewStyleWhiteLarge;
        _translucentOverlayViewBackgroundColor = colors.blackTranslucent1Color;
    }
    
    return self;
}

@end
