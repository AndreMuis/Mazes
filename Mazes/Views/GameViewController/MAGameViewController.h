//
//  MAGameViewController.h
//  Mazes
//
//  Created by Andre Muis on 4/18/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MAConstants.h"
#import "MARatingView.h"

typedef NS_ENUM(NSUInteger, MAMovementType)
{
    MAMovementBackward = 1,
    MAMovementForward = 2,
    MAMovementTurnLeft = 3,
    MAMovementTurnRight = 4
};

@class MAEvent;
@class MALocation;
@class MAMapView;
@class MAMazeManager;
@class MAMazeSummary;
@class MASoundManager;
@class MATextureManager;
@class MATopMazesViewController;
@class MAWorld;

@interface MAGameViewController : UIViewController

@property (readwrite, strong, nonatomic) MAMazeSummary *mazeSummary;
@property (readwrite, strong, nonatomic) MAWorld *world;
@property (readwrite, strong, nonatomic) MATopMazesViewController *topMazesViewController;

@property (readwrite, weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

- (id)initWithMazeManager: (MAMazeManager *)mazeManager
           textureManager: (MATextureManager *)textureManager
             soundManager: (MASoundManager *)soundManager;

- (void)startSetup;

@end

















