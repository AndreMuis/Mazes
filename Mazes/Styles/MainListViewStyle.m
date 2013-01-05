//
//  MainListViewStyle.m
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import "MainListViewStyle.h"

@implementation MainListViewStyle

- (id)init
{
    self = [super init];
	
    if (self)
	{
        self.tableBackgroundColor = [UIColor clearColor];
        self.textColor = [Colors shared].darkBrownColor;
    }
    
    return self;
}

@end
