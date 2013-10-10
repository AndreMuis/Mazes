//
//  MACoordinate.m
//  Mazes
//
//  Created by Andre Muis on 10/3/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import "MACoordinate.h"

@implementation MACoordinate

- (id)init
{
    self = [super init];
	
	if (self)
	{
        _row = 0;
        _column = 0;
	}
	
    return self;
}

- (id)initWithCoder: (NSCoder *)coder
{
    self = [super init];
    
    if (self)
    {
        _row = [coder decodeIntegerForKey: @"row"];
        _column = [coder decodeIntegerForKey: @"column"];
    }
    
    return self;
}

- (void)encodeWithCoder: (NSCoder *)coder
{
    [coder encodeInteger: self.row forKey: @"row"];
    [coder encodeInteger: self.column forKey: @"column"];
}

- (NSString *)description
{
    NSString *desc = [NSString stringWithFormat: @"<%@: %p; ", [self class], self];
    desc = [desc stringByAppendingFormat: @"row = %d; ", self.row];
    desc = [desc stringByAppendingFormat: @"column = %d>", self.column];
    
    return desc;
}

@end
