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

@property (strong, nonatomic) Maze *maze;

@property (strong, nonatomic) Location *currLoc;
@property (assign, nonatomic) MADirectionType currDir;

- (void)drawSurroundings;

- (void)clear;

@end
