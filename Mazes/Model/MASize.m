//
//  MASize.m
//  Mazes
//
//  Created by Andre Muis on 10/3/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import "MASize.h"

@implementation MASize

- (id)init
{
    self = [super init];
	
	if (self)
	{
        _rows = 0;
        _columns = 0;
	}
	
    return self;
}

- (NSString *)description
{
    NSString *desc = [NSString stringWithFormat: @"<%@: %p; ", [self class], self];
    desc = [desc stringByAppendingFormat: @"rows = %d; ", self.rows];
    desc = [desc stringByAppendingFormat: @"columns = %d>", self.columns];

    return desc;
}

@end
