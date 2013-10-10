//
//  MAUserCounter.m
//  Mazes
//
//  Created by Andre Muis on 9/16/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import "MAUserCounter.h"

@implementation MAUserCounter

- (id)init
{
    self = [super init];
	
	if (self)
	{
        _userCounterId = nil;
        _count = 0;
	}
	
    return self;
}

- (NSString *)description
{
    NSString *desc = [NSString stringWithFormat: @"<%@: %p; ", [self class], self];
    desc = [desc stringByAppendingFormat: @"userCounterId = %@; ", self.userCounterId];
    desc = [desc stringByAppendingFormat: @"count = %d>", self.count];
    
    return desc;
}

@end
