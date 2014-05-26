//
//  MAGameViewController.h
//  Mazes
//
//  Created by Andre Muis on 4/18/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Reachability/Reachability.h>

#import "MAConstants.h"
#import "MARatingView.h"
#import "MAWebServices.h"

typedef enum : int
{
	MAMovementBackward = 1,
	MAMovementForward = 2,
	MAMovementTurnLeft = 3,
	MAMovementTurnRight = 4
} MAMovementType;

@class MAEvent;
@class MALocation;
@class MAMainViewController;
@class MAMapView;
@class MAMazeManager;
@class MAMaze;
@class MAMazeSummary;
@class MAMazeView;
@class MASoundManager;
@class MATextureManager;
@class MATopMazesViewController;

@interface MAGameViewController : UIViewController

@property (readwrite, strong, nonatomic) MAMazeSummary *mazeSummary;
@property (readwrite, strong, nonatomic) MAMaze *maze;
@property (readwrite, strong, nonatomic) MAMainViewController *mainViewController;
@property (readwrite, strong, nonatomic) MATopMazesViewController *topMazesViewController;

@property (readwrite, weak, nonatomic) ADBannerView *bannerView;

@property (readwrite, weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

- (id)initWithReachability: (Reachability *)reachability
               webServices: (MAWebServices *)webServices
               mazeManager: (MAMazeManager *)mazeManager
            textureManager: (MATextureManager *)textureManager
              soundManager: (MASoundManager *)soundManager;

- (void)startSetup;

@end

















