//
//  EndAlertViewStyle.m
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import "EndAlertViewStyle.h"

@implementation EndAlertViewStyle

- (id)init
{
    self = [super init];
	
    if (self)
	{
        self.textColor = [Colors shared].whiteColor;
    }
    
    return self;
}

@end
