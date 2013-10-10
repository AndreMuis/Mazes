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
#import "MAViewController.h"

typedef enum : int
{
	MAMovementBackward = 1,
	MAMovementForward = 2,
	MAMovementTurnLeft = 3,
	MAMovementTurnRight = 4
} MAMovementType;

@class MAConstants;
@class MAEvent;
@class MALocation;
@class MAMainViewController;
@class MAMapView;
@class MAMaze;
@class MAMazeView;
@class MASoundManager;
@class MAStyles;
@class MATextureManager;
@class MATopMazeItem;
@class MATopMazesViewController;

@interface MAGameViewController : MAViewController
    <UIGestureRecognizerDelegate,
    UIAlertViewDelegate,
    MARatingViewDelegate,
    UIPopoverControllerDelegate>

@property (strong, nonatomic) MAMaze *maze;
@property (strong, nonatomic) MAMainViewController *mainViewController;
@property (strong, nonatomic) MATopMazesViewController *topMazesViewController;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

- (id)initWithConstants: (MAConstants *)constants
           soundManager: (MASoundManager *)soundManager
                 styles: (MAStyles *)styles
         textureManager: (MATextureManager *)textureManager
             bannerView: (ADBannerView *)bannerView;

- (void)setup;

@end

















