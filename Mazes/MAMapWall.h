//
//  MAMapWall.h
//  Mazes
//
//  Created by Andre Muis on 10/3/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MAConstants.h"

@interface MAMapWall : NSObject

@property (readonly, assign, nonatomic) NSUInteger rowDelta;
@property (readonly, assign, nonatomic) NSUInteger columnDelta;
@property (readonly, assign, nonatomic) MADirectionType direction;

@property (readonly, strong, nonatomic) NSArray *blockingWalls;

- (id)initWithRowDelta: (NSUInteger)rowDelta
           columnDelta: (NSUInteger)columnDelta
             direction: (MADirectionType)direction
         blockingWalls: (NSArray *)blockingWalls;

@end
