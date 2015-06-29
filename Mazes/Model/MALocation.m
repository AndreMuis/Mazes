//
//  MALocation.m
//  Mazes
//
//  Created by Andre Muis on 10/4/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import "MALocation.h"

#import "MATextureManager.h"
#import "MATexture.h"
#import "MAWorld.h"

@implementation MALocation

+ (instancetype)locationWithRow: (NSUInteger)row
                         column: (NSUInteger)column
{
    MALocation *location = [[self alloc] initWithRow: row
                                              column: column];
    
    return location;
}

- (instancetype)initWithRow: (NSUInteger)row
                     column: (NSUInteger)column
{
    self = [super init];
    
    if (self)
    {
        _row = row;
        _column = column;
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
    desc = [desc stringByAppendingFormat: @"row = %d; ", (int)self.row];
    desc = [desc stringByAppendingFormat: @"column = %d; ", (int)self.column];
    
    return desc;
}

@end
















