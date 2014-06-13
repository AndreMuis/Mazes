//
//  MAMapView.h
//  Mazes
//
//  Created by Andre Muis on 1/30/11.
//  Copyright 2011 Andre Muis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MAConstants.h"

@class MALocation;
@class MAMaze;

@interface MAMapView : UIView 

@property (strong, nonatomic) MAMaze *maze;

@property (strong, nonatomic) MALocation *currentLocation;
@property (assign, nonatomic) MADirectionType facingDirection;

- (void)drawSurroundings;

- (void)clear;

@end
