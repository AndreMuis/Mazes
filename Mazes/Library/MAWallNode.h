//
//  MAWallNode.h
//  Mazes
//
//  Created by Andre Muis on 6/28/15.
//  Copyright (c) 2015 Andre Muis. All rights reserved.
//

#import <SceneKit/SceneKit.h>

#import "MABoxNode.h"
#import "MAConstants.h"

@class MAWall;

@interface MAWallNode : MABoxNode

@property (readonly, assign, nonatomic) NSUInteger row;
@property (readonly, assign, nonatomic) NSUInteger column;
@property (readonly, assign, nonatomic) MAWallPositionType wallPosition;

+ (instancetype)wallWithWall: (MAWall *)wall
                         row: (NSUInteger)row
                      column: (NSUInteger)column
                wallPosition: (MAWallPositionType)position
                   wallWidth: (CGFloat)wallWidth;

- (instancetype)initWithRow: (NSUInteger)row
                     column: (NSUInteger)column
               wallPosition: (MAWallPositionType)wallPosition
                          x: (CGFloat)x
                          y: (CGFloat)y
                          z: (CGFloat)z
                      width: (CGFloat)width
                     height: (CGFloat)height
                     length: (CGFloat)length
                      color: (UIColor *)color
                    opacity: (CGFloat)opacity;

@end
