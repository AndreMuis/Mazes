//
//  MAFloorPlanViewController.h
//  Mazes
//
//  Created by Andre Muis on 5/27/14.
//  Copyright (c) 2014 Andre Muis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MALocation;
@class MAMaze;
@class MAWall;

@protocol MAFloorPlanViewDelegate;

@interface MAFloorPlanViewController : UIViewController

@property (readonly, assign, nonatomic) CGFloat minimumZoomScale;

@property (readonly, strong, nonatomic) MALocation *previousSelectedLocation;
@property (readonly, strong, nonatomic) MALocation *currentSelectedLocation;

@property (readonly, strong, nonatomic) MAWall *currentSelectedWall;

+ (MAFloorPlanViewController *)floorPlanViewControllerWithMaze: (MAMaze *)maze
                                         floorPlanViewDelegate: (id<MAFloorPlanViewDelegate>)floorPlanViewDelegate;

- (instancetype)initWithNibName: (NSString *)nibNameOrNil
                         bundle: (NSBundle *)nibBundleOrNil
                           maze: (MAMaze *)maze
          floorPlanViewDelegate: (id<MAFloorPlanViewDelegate>)floorPlanViewDelegate;

@end
