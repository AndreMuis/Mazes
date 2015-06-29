//
//  MAWall.m
//  Mazes
//
//  Created by Andre Muis on 10/3/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import "MAWall.h"

@implementation MAWall

+ (instancetype)wallWithRow: (NSUInteger)row
                     column: (NSUInteger)column
                   position: (MAWallPositionType)position
{
    MAWall *wall = [[self alloc] initWithRow: row
                                      column: column
                                    position: position];
    
    return wall;
}

- (instancetype)initWithRow: (NSUInteger)row
                     column: (NSUInteger)column
                   position: (MAWallPositionType)position
{
    self = [super init];
    
    if (self)
    {
        _row = row;
        _column = column;
        _position = position;
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
        _position = [coder decodeIntegerForKey: @"position"];
    }
    
    return self;
}

- (void)encodeWithCoder: (NSCoder *)coder
{
    [coder encodeInteger: self.row forKey: @"row"];
    [coder encodeInteger: self.column forKey: @"column"];
    [coder encodeInteger: self.position forKey: @"position"];
}

- (NSString *)description
{
    NSString *desc = [NSString stringWithFormat: @"<%@: %p; ", [self class], self];
    desc = [desc stringByAppendingFormat: @"row = %d; ", (int)self.row];
    desc = [desc stringByAppendingFormat: @"column = %d; ", (int)self.column];
    desc = [desc stringByAppendingFormat: @"position = %d>", (int)self.position];
    
    return desc;
}

@end




















