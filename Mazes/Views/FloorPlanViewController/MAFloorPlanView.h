//
//  MAFloorPlanView.h
//  Mazes
//
//  Created by Andre Muis on 1/31/11.
//  Copyright 2011 Andre Muis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MAMaze;

@protocol MAFloorPlanViewDelegate;

@interface MAFloorPlanView : UIView

@property (readonly, assign, nonatomic) CGSize size;

- (void)setupWithFloorPlanViewDelegate: (id<MAFloorPlanViewDelegate>)floorPlanViewDelegate
                                  maze: (MAMaze *)maze;

- (void)updateSizeConstraints;

- (void)refreshUI;

@end
