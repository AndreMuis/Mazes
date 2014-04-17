//
//  MACreateScreenStyle.m
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import "MACreateScreenStyle.h"

#import "MAColors.h"

@implementation MACreateScreenStyle

+ (MACreateScreenStyle *)createScreenStyle
{
    MACreateScreenStyle *createScreenStyle = [[MACreateScreenStyle alloc] init];
    return createScreenStyle;
}

- (id)init
{
    self = [super init];

    if (self)
	{
        MAColors *colors = [MAColors colors];
        
        _pickerWidth = 100.0;
        _pickerBackgroundColor = colors.lightOrange2Color;
        _pickerBorderColor = colors.lightOrange1Color;
        _pickerBorderWidth = 2.0;
        
        _pickerRowHeight = 44.0;
        _pickerRowBackgroundColor = colors.whiteColor;
        _pickerRowTextColor = [UIColor blackColor];
        _pickerRowFont = [UIFont boldSystemFontOfSize: 20];
    }
                      
    return self;
}

@end
