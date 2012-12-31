//
//  GridView.h
//  Mazes
//
//  Created by Andre Muis on 1/31/11.
//  Copyright 2011 Andre Muis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Location;
@class Maze;

@interface GridView : UIView 

@property (strong, nonatomic) Maze *maze;
@property (strong, nonatomic) Location *currLoc;
@property (strong, nonatomic) Location *currWallLoc;
@property (assign, nonatomic) int currWallDir;

@end
