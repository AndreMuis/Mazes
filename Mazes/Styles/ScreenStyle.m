//
//  ScreenStyle.m
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ScreenStyle.h"

@implementation ScreenStyle

@synthesize width;
@synthesize height;

- (id)init
{
    self = [super init];
	
    if (self)
	{
        self.width = [Globals shared].appDelegate.window.screen.bounds.size.width;
        self.height = [Globals shared].appDelegate.window.screen.bounds.size.height;
    }
	
    return self;
}

@end
