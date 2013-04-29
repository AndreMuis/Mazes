//
//  GridView.h
//  Mazes
//
//  Created by Andre Muis on 1/31/11.
//  Copyright 2011 Andre Muis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Constants.h"

@class Location;
@class Maze;

@interface GridView : UIView 

@property (strong, nonatomic) Maze *maze;
@property (strong, nonatomic) Location *currentLocation;
@property (strong, nonatomic) Location *currentWallLocation;
@property (assign, nonatomic) MADirectionType currentWallDirection;

@end
