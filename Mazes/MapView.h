//
//  MapView.h
//  Mazes
//
//  Created by Andre Muis on 1/30/11.
//  Copyright 2011 Andre Muis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Constants.h"

@class Maze;
@class Location;

@interface MapView : UIView 
{
    NSMutableArray *segments;
    
    UIImageView *directionArrowImageView;
}

@property (strong, nonatomic) Maze *maze;

@property (strong, nonatomic) Location *currLoc;
@property (assign, nonatomic) MADirectionType currDir;

- (void)drawSurroundings;
- (void)drawCornerWithLocation: (Location *)cornerLoc offset: (CGPoint)offset;

- (void)rotateCoordinatesX: (int)x y: (int)y dir: (int)dir rx: (int *)rx ry: (int *)ry rdir: (MADirectionType *)rdir;

- (void)addSegmentRect: (CGRect)rect color: (UIColor *)color;

- (void)clear;

@end
