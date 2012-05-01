//
//  ActivityViewStyle.m
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ActivityViewStyle.h"

@implementation ActivityViewStyle

@synthesize messageFont;
@synthesize messageColor;
@synthesize paddingPrcnt;

- (id)init
{
    self = [super init];

    if (self)
	{
       	self.messageFont = [UIFont systemFontOfSize: 31.0];
        self.messageColor = [[UIColor alloc] initWithRed: 0.0 green: 0.0 blue: 0.0 alpha: 0.4];
        self.paddingPrcnt = 0.2;
    }
                      
    return self;
}

@end
