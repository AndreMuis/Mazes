//
//  MAFloorPlanView.h
//  Mazes
//
//  Created by Andre Muis on 1/31/11.
//  Copyright 2011 Andre Muis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MALocation;
@class MAMaze;
@class MAWall;

@protocol MAFloorPlanViewDelegate;

@interface MAFloorPlanView : UIView

@property (readonly, assign, nonatomic) CGSize size;

@property (readonly, strong, nonatomic) MALocation *previousSelectedLocation;
@property (readonly, strong, nonatomic) MALocation *currentSelectedLocation;

@property (readonly, strong, nonatomic) MAWall *currentSelectedWall;

- (void)setupWithDelegate: (id<MAFloorPlanViewDelegate>)delegate
                     maze: (MAMaze *)maze;

- (void)updateSizeConstraints;

@end
