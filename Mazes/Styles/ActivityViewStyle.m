//
//  ActivityViewStyle.m
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import "ActivityViewStyle.h"

#import "Colors.h"

@implementation ActivityViewStyle

- (id)init
{
    self = [super init];

    if (self)
	{
        self.color = [Colors shared].darkGrayColor;
    }
                      
    return self;
}

@end
