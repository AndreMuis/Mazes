//
//  MAWall.h
//  Mazes
//
//  Created by Andre Muis on 10/3/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MAConstants.h"

@interface MAWall : NSObject <NSCoding>

@property (readonly, assign, nonatomic) NSUInteger row;
@property (readonly, assign, nonatomic) NSUInteger column;
@property (readonly, assign, nonatomic) MAWallPositionType position;

+ (instancetype)wallWithRow: (NSUInteger)row
                     column: (NSUInteger)column
                   position: (MAWallPositionType)position;

- (instancetype)initWithRow: (NSUInteger)row
                     column: (NSUInteger)column
                   position: (MAWallPositionType)position;

@end
