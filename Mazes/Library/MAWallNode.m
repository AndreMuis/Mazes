//
//  MAWallNode.m
//  Mazes
//
//  Created by Andre Muis on 6/28/15.
//  Copyright (c) 2015 Andre Muis. All rights reserved.
//

#import "MAWallNode.h"

#import "MAWall.h"

@implementation MAWallNode

+ (instancetype)wallWithWall: (MAWall *)wall
                         row: (NSUInteger)row
                      column: (NSUInteger)column
                wallPosition: (MAWallPositionType)wallPosition
                   wallWidth: (CGFloat)wallWidth
{
    CGFloat x = 0.0;
    CGFloat y = 0.0;
    CGFloat z = 0.0;
    CGFloat width = 0.0;
    CGFloat height = 0.0;
    CGFloat length = 0.0;
    
    switch (wallPosition)
    {
        case MAWallPositionTop:
            x = column + wallWidth / 2.0;
            y = wallWidth / 2.0;
            z = row - wallWidth / 2.0;
            width =  1.0 - wallWidth;
            height = 1.0;
            length = wallWidth;
            
            break;
            
        case MAWallPositionLeft:
            x = column - wallWidth / 2.0;
            y = wallWidth / 2.0;
            z = row + wallWidth / 2.0;
            width = wallWidth;
            height = 1.0;
            length = 1.0 - wallWidth;
            
            break;
            
        default:
            break;
    }
    
    UIColor *color = nil;
    CGFloat opacity = 0.0;

    if (wall == nil)
    {
        color = [UIColor grayColor];
        opacity = 0.8;
    }
    else
    {
        color = [UIColor blueColor];
        opacity = 1.0;
    }
    
    MAWallNode *wallNode = [[MAWallNode alloc] initWithRow: row
                                                    column: column
                                              wallPosition: wallPosition
                                                         x: x
                                                         y: y
                                                         z: z
                                                     width: width
                                                    height: height
                                                    length: length
                                                     color: color
                                                   opacity: opacity];

    return wallNode;
}

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
                    opacity: (CGFloat)opacity
{
    self = [super initWithX: x
                          y: y
                          z: z
                      width: width
                     height: height
                     length: length
                      color: color
                    opacity: opacity];

    if (self)
    {
        _row = row;
        _column = column;
        _wallPosition = wallPosition;
    }
    
    return self;
}

@end


                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
