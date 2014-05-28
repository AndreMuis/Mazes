//
//  MAFloorPlanViewController.h
//  Mazes
//
//  Created by Andre Muis on 5/27/14.
//  Copyright (c) 2014 Andre Muis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MAMaze;

@protocol MAFloorPlanViewDelegate;

@interface MAFloorPlanViewController : UIViewController

- (void)setupWithFloorPlanViewDelegate: (id<MAFloorPlanViewDelegate>)floorPlanViewDelegate
                                  maze: (MAMaze *)maze;

- (void)refresh;

@end
