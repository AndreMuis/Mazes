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

@interface GameViewController : MAViewController
    <MAServerOperationsGetMazeDelegate,
    MAServerOperationsGetLocationsDelegate,
    MAServerOperationsGetMazeUserDelegate,
    UIGestureRecognizerDelegate,
    UIAlertViewDelegate,
    UIPopoverControllerDelegate>
{
    NSOperationQueue *operationQueue;
    
    Maze *maze;
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
		
	UIAlertView *endAlertView;
}

@property (weak, nonatomic) MainListItem *mainListItem;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewMazesBack;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewHowToPlay;

@property (weak, nonatomic) IBOutlet UIButton *btnHowToPlay;

@property (weak, nonatomic) IBOutlet UIView *viewMapBorder;
@property (weak, nonatomic) IBOutlet MapView *mapView;

@property (weak, nonatomic) IBOutlet UIView *viewMessageBorder;
@property (weak, nonatomic) IBOutlet UITextView *textViewMessage;

@property (weak, nonatomic) IBOutlet UIView *viewMazeBorder;
@property (weak, nonatomic) IBOutlet MazeView *mazeView;

@property (strong, nonatomic) UIPopoverController *popoverController2;

+ (GameViewController *)shared;

- (void)setupOperationQueue;

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

- (void)setMazeFinished;
- (void)setMazeFinishedResponse;

- (void)displayMessage;
- (void)clearMessage;

- (void)showEndAlert;
- (void)dismissEndAlertView;

- (IBAction)btnMazesBackTouchDown: (id)sender;
- (IBAction)btnMazesBackTouchUpInside: (id)sender;

- (void)goBack;

- (IBAction)btnHowToPlayTouchDown: (id)sender;
- (IBAction)btnHowToPlayTouchUpInside: (id)sender;

- (void)displayHelp;

@end
