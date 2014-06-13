//
//  MAMapNearbyLocation.h
//  Mazes
//
//  Created by Andre Muis on 10/4/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MAMapNearbyLocation : NSObject

@property (readonly, assign, nonatomic) NSUInteger rowDelta;
@property (readonly, assign, nonatomic) NSUInteger columnDelta;

@property (readonly, strong, nonatomic) NSArray *blockingWalls;

- (id)initWithRowDelta: (NSUInteger)rowDelta
           columnDelta: (NSUInteger)columnDelta
         blockingWalls: (NSArray *)blockingWalls;

@end
