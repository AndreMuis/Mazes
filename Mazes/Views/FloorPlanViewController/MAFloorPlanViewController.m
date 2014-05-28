//
//  MAFloorPlanViewController.m
//  Mazes
//
//  Created by Andre Muis on 5/27/14.
//  Copyright (c) 2014 Andre Muis. All rights reserved.
//

#import "MAFloorPlanViewController.h"

#import "MAFloorPlanView.h"
#import "MAFloorPlanViewDelegate.h"
#import "MAMaze.h"

@interface MAFloorPlanViewController ()

@property (weak, nonatomic) IBOutlet MAFloorPlanView *floorPlanView;

@end

@implementation MAFloorPlanViewController

- (void)setupWithFloorPlanViewDelegate: (id<MAFloorPlanViewDelegate>)floorPlanViewDelegate
                                  maze: (MAMaze *)maze;
{
    [self.floorPlanView setupWithFloorPlanViewDelegate: floorPlanViewDelegate
                                                  maze: maze];
}

- (void)refresh
{
    [self.floorPlanView refresh];
}

@end
