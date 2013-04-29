//
//  GameViewController.h
//  Mazes
//
//  Created by Andre Muis on 4/18/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Constants.h"
#import "MAViewController.h"
#import "RatingView.h"
#import "ServerOperations.h"

typedef enum : int
{
	MAMovementBackward = 1,
	MAMovementForward = 2,
	MAMovementTurnLeft = 3,
	MAMovementTurnRight = 4
} MAMovementType;

@class Location;
@class MainListItem;
@class MapView;
@class Maze;
@class MazeView;
@class MAEvent;

@interface GameViewController : MAViewController
    <MAServerOperationsGetMazeDelegate,
    MAServerOperationsGetMazeUserDelegate,
    UIGestureRecognizerDelegate,
    UIAlertViewDelegate,
    MARatingViewDelegate,
    UIPopoverControllerDelegate>

@property (assign, nonatomic) int mazeId;

@property (weak, nonatomic) IBOutlet UIImageView *backImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *instructionsImageView;
@property (weak, nonatomic) IBOutlet UIButton *instructionsButton;

@property (weak, nonatomic) IBOutlet UIView *mapBorderView;
@property (weak, nonatomic) IBOutlet MapView *mapView;

@property (weak, nonatomic) IBOutlet UIView *messageBorderView;
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;

@property (weak, nonatomic) IBOutlet UIView *mazeBorderView;
@property (weak, nonatomic) IBOutlet MazeView *mazeView;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

+ (GameViewController *)shared;

- (void)getGameData;

- (void)setup;

- (IBAction)backButtonTouchDown: (id)sender;
- (IBAction)backButtonTouchUpInside: (id)sender;

- (IBAction)instructionsButtonTouchDown: (id)sender;
- (IBAction)instructionsButtonTouchUpInside: (id)sender;

@end

















