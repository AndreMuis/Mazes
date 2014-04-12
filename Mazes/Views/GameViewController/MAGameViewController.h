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
@class MAStyles;
@class MATextureManager;
@class MATopMazesViewController;

@interface MAGameViewController : UIViewController
    <UIGestureRecognizerDelegate,
    MARatingViewDelegate,
    UIPopoverControllerDelegate>

@property (strong, nonatomic) MAMazeSummary *mazeSummary;
@property (strong, nonatomic) MAMaze *maze;
@property (strong, nonatomic) MAMainViewController *mainViewController;
@property (strong, nonatomic) MATopMazesViewController *topMazesViewController;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

- (id)initWithWebServices: (MAWebServices *)webServices
              mazeManager: (MAMazeManager *)mazeManager
           textureManager: (MATextureManager *)textureManager
             soundManager: (MASoundManager *)soundManager
                   styles: (MAStyles *)styles
               bannerView: (ADBannerView *)bannerView;

- (void)setup;

@end

















