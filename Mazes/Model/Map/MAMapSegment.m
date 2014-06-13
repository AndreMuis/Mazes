//
//  MAMapSegment.m
//  Mazes
//
//  Created by Andre Muis on 6/12/14.
//  Copyright (c) 2014 Andre Muis. All rights reserved.
//

#import "MAMapSegment.h"

@implementation MAMapSegment

- (id)initWithFrame: (CGRect)frame color: (UIColor *)color
{
    self = [super init];
    
    if (self)
    {
        _frame = frame;
        _color = color;
    }
    
    return self;
}

@end
