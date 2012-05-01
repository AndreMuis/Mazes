//
//  BannerViewStyle.m
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BannerViewStyle.h"

@implementation BannerViewStyle

@synthesize height;

- (id)init
{
    self = [super init];
	
    if (self)
	{
        self.height = 66.0;
    }
    
    return self;
}

@end
