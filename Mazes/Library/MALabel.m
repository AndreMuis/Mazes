//
//  MALabel.m
//  Mazes
//
//  Created by Andre Muis on 4/17/14.
//  Copyright (c) 2014 Andre Muis. All rights reserved.
//

#import "MALabel.h"

@interface MALabel ()

@property (readonly, assign, nonatomic) UIEdgeInsets edgeInsets;

@end

@implementation MALabel

- (id)initWithFrame: (CGRect)frame edgeInsets: (UIEdgeInsets)edgeInsets
{
    self = [super initWithFrame: frame];
    
    if (self)
    {
        _edgeInsets = edgeInsets;
    }

    return self;
}

- (void)drawTextInRect: (CGRect)rect
{
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.edgeInsets)];
}

@end
