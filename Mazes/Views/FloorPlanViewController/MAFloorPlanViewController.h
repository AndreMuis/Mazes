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

+ (MAFloorPlanViewController *)floorPlanViewControllerWithMaze: (MAMaze *)maze
                                         floorPlanViewDelegate: (id<MAFloorPlanViewDelegate>)floorPlanViewDelegate;

- (instancetype)initWithNibName: (NSString *)nibNameOrNil
                         bundle: (NSBundle *)nibBundleOrNil
                           maze: (MAMaze *)maze
          floorPlanViewDelegate: (id<MAFloorPlanViewDelegate>)floorPlanViewDelegate;

- (void)updateSize;

- (void)refreshUI;

@end
