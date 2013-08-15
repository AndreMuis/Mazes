//
//  MapView.h
//  Mazes
//
//  Created by Andre Muis on 1/30/11.
//  Copyright 2011 Andre Muis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MAConstants.h"

@class MALocation;
@class MAMaze;

@interface MapView : UIView 

@property (strong, nonatomic) MAMaze *maze;

@property (strong, nonatomic) MALocation *currLoc;
@property (assign, nonatomic) MADirectionType currDir;

- (void)drawSurroundings;

- (void)clear;

@end
