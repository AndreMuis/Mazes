//
//  GridView.h
//  Mazes
//
//  Created by Andre Muis on 1/31/11.
//  Copyright 2011 Andre Muis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MAConstants.h"

@class MALocation;
@class MAMaze;

@interface GridView : UIView 

@property (strong, nonatomic) MAMaze *maze;
@property (strong, nonatomic) MALocation *currentLocation;
@property (strong, nonatomic) MALocation *currentWallLocation;
@property (assign, nonatomic) MADirectionType currentWallDirection;

@end
