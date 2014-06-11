//
//  MAMapLocation.m
//  Mazes
//
//  Created by Andre Muis on 10/4/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import "MAMapLocation.h"

@implementation MAMapLocation

- (id)initWithRowDelta: (NSUInteger)rowDelta
           columnDelta: (NSUInteger)columnDelta
         blockingWalls: (NSArray *)blockingWalls
{
    self = [super init];
    
    if (self)
    {
        _rowDelta = rowDelta;
        _columnDelta = columnDelta;
        
        _blockingWalls = blockingWalls;
    }
    
    return self;
}

@end
