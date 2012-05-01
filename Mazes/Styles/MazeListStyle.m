//
//  MazeListStyle.m
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MazeListStyle.h"

@implementation MazeListStyle

@synthesize tableBackgroundColor;
@synthesize textColor;

- (id)init
{
    self = [super init];
	
    if (self)
	{
        self.tableBackgroundColor = [Colors instance].transparentColor;
        self.textColor = [Colors instance].darkBrownColor;
    }
    
    return self;
}

@end
