//
//  MAMapNearbyWall.m
//  Mazes
//
//  Created by Andre Muis on 10/3/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import "MAMapNearbyWall.h"

@implementation MAMapNearbyWall

- (id)initWithRowDelta: (NSUInteger)rowDelta
           columnDelta: (NSUInteger)columnDelta
             direction: (MADirectionType)direction
         blockingWalls: (NSArray *)blockingWalls
{
    self = [super init];
    
    if (self)
    {
        _rowDelta = rowDelta;
        _columnDelta = columnDelta;
        _direction = direction;
        
        _blockingWalls = blockingWalls;
    }
    
    return self;
}

@end
