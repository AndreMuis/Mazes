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

typedef enum
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
    MAServerOperationsGetLocationsDelegate,
    MAServerOperationsGetMazeUserDelegate,
    UIGestureRecognizerDelegate,
    UIAlertViewDelegate,
    MARatingViewDelegate,
    UIPopoverControllerDelegate>
{
    NSOperationQueue *operationQueue;
    
    MAEvent *getGameDataEvent;
    MAEvent *saveMazeUserEvent;
    
    Maze *maze;
    NSArray *locations;
    
    MazeUser *mazeUser;
    
	Location *prevLoc;
	Location *currLoc;

	MADirectionType currDir;
	
	NSDate *movementStartDate;
		
	NSMutableArray *movements;
	BOOL isMoving;
	
	MADirectionType movementDir;
	
	int dLocX;
	int dLocY;

	float dglx_step;
	float dglz_step;
	float dTheta_step;
	
	int steps;
	int stepCount;

	float moveStepDurationAvg;
	float turnStepDurationAvg;
	
	BOOL wallRemoved;
	BOOL directionReversed;

    UIAlertView *startOverAlertView;
	UIAlertView *endAlertView;
}

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

@property (strong, nonatomic) UIPopoverController *popoverController2;

+ (GameViewController *)shared;

- (void)getGameData;

- (void)setup;
- (void)setupNewLocation: (Location *)newLoc;

- (void)handleTapFrom: (UITapGestureRecognizer *)recognizer;
- (void)handleSwipeFrom: (UISwipeGestureRecognizer *)recognizer;

- (void)processMovements;

- (void)moveForwardBackward: (MAMovementType)movement;
- (void)moveStep: (NSTimer *) timer;
- (void)moveEnd;

- (void)turn: (MAMovementType)movement;
- (void)turnStep: (NSTimer *)timer;
- (void)turnEnd;

- (void)locationChanged;

- (void)displayMessage;
- (void)clearMessage;

- (void)showEndAlert;
- (void)dismissEndAlertView;

- (IBAction)backButtonTouchDown: (id)sender;
- (IBAction)backButtonTouchUpInside: (id)sender;

- (void)goBack;

- (IBAction)instructionsButtonTouchDown: (id)sender;
- (IBAction)instructionsButtonTouchUpInside: (id)sender;

- (void)displayHelp;

@end

















