//
//  EndAlertViewStyle.m
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EndAlertViewStyle.h"

@implementation EndAlertViewStyle

@synthesize textColor;

- (id)init
{
    self = [super init];
	
    if (self)
	{
        self.textColor = [Colors instance].whiteColor;
    }
    
    return self;
}

@end
