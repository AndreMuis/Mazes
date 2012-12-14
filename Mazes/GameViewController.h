//
//  GameViewController.h
//  iPad_Mazes
//
//  Created by Andre Muis on 4/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Globals.h"
#import "Communication.h"
#import "Maze.h"
#import "TopListsViewController.h"
#import "MazeView.h"
#import "MapView.h"
#import "TopListsItem.h"
#import "RatingView.h"

@interface GameViewController : UIViewController <UIGestureRecognizerDelegate, UIAlertViewDelegate, UIPopoverControllerDelegate, ADBannerViewDelegate>
{
	Communication *comm;
	
	TopListsItem *topListsItem;

	Location *prevLoc, *currLoc;
	int currDir;
	
	NSDate *movementStartDate;
		
	NSMutableArray *movements;
	BOOL IsMoving;
	
	int movementDir;
	
	int dLocX, dLocY;
	float dglx_step, dglz_step, dTheta_step;
	
	int steps, stepCount;
	float moveStepDurationAvg, turnStepDurationAvg;
	
	BOOL wallRemoved, directionReversed;
		
	UIImageView *imageViewMazesBack;
	
	UILabel *lblTitle;
	
	UIImageView *imageViewHowToPlay;
	
	UIButton *btnHowToPlay;
	
	UIView *viewMapBorder;
	MapView *mapView;
	
	UIView *viewMessageBorder;
	UITextView *textViewMessage;	
	
	UIView *viewMazeBorder;
	MazeView *mazeView;
		
	UIAlertView *endAlertView;
	
	UIPopoverController	*popoverController;
}

@property (nonatomic, retain) TopListsItem *topListsItem;

@property (nonatomic, retain) IBOutlet UIImageView *imageViewMazesBack;

@property (nonatomic, retain) IBOutlet UILabel *lblTitle;

@property (nonatomic, retain) IBOutlet UIImageView *imageViewHowToPlay;

@property (nonatomic, retain) IBOutlet UIButton *btnHowToPlay;

@property (nonatomic, retain) IBOutlet UIView *viewMapBorder;
@property (nonatomic, retain) IBOutlet MapView *mapView;

@property (nonatomic, retain) IBOutlet UIView *viewMessageBorder;
@property (nonatomic, retain) IBOutlet UITextView *textViewMessage;

@property (nonatomic, retain) IBOutlet UIView *viewMazeBorder;
@property (nonatomic, retain) IBOutlet MazeView *mazeView;

@property (nonatomic, retain) UIPopoverController *popoverController;

- (void)loadMaze;
- (void)loadMazeResponse;
- (void)loadMazeLocations;
- (void)loadMazeLocationsResponse;

- (void)setMazeStarted;
- (void)setMazeStartedResponse;

- (void)Setup;
- (void)SetupNewLocation: (Location *)newLoc;

- (void)handleTapFrom: (UITapGestureRecognizer *)recognizer;
- (void)handleSwipeFrom: (UISwipeGestureRecognizer *)recognizer;

- (void)processMovements;

- (void)moveForwardBackward: (int)movement;
- (void)moveStep: (NSTimer *) timer;
- (void)moveEnd;

- (void)turn: (int)movement;
- (void)turnStep: (NSTimer *)timer;
- (void)turnEnd;

- (void)locationChanged;

- (void)setMazeFinished;
- (void)setMazeFinishedResponse;

- (void)displayMessage;
- (void)clearMessage;

- (void)ShowEndAlert;
- (void)dismissEndAlertView;

- (IBAction)btnMazesBackTouchDown: (id)sender;
- (IBAction)btnMazesBackTouchUpInside: (id)sender;

- (void)goBack;

- (IBAction)btnHowToPlayTouchDown: (id)sender;
- (IBAction)btnHowToPlayTouchUpInside: (id)sender;

- (void)displayHelp;

@end
