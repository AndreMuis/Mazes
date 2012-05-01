    //
//  GameViewController.m
//  iPad Mazes
//
//  Created by Andre Muis on 4/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GameViewController.h"

@implementation GameViewController

@synthesize topListsItem; 
@synthesize imageViewMazesBack; 
@synthesize lblTitle;
@synthesize imageViewHowToPlay; 
@synthesize btnHowToPlay;
@synthesize viewMapBorder; 
@synthesize mapView;
@synthesize viewMessageBorder;
@synthesize textViewMessage;
@synthesize viewMazeBorder;
@synthesize mazeView;
@synthesize popoverController;

- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	movements = [[NSMutableArray alloc] init];
		
	moveStepDurationAvg = [Constants instance].stepDurationAvgStart;
	turnStepDurationAvg = [Constants instance].stepDurationAvgStart;
	
	lblTitle.backgroundColor = [Styles instance].gameView.titleBackgroundColor;
	lblTitle.font = [Styles instance].gameView.titleFont;
	lblTitle.textColor = [Styles instance].gameView.titleTextColor;
	
	viewMapBorder.backgroundColor = [Styles instance].gameView.borderColor;
	mapView.backgroundColor = [Styles instance].map.backgroundColor;
	
	mapView.mapSegments = [[NSMutableArray alloc] init];
	
	viewMessageBorder.backgroundColor = [Styles instance].gameView.borderColor;
	
	textViewMessage.backgroundColor = [Styles instance].gameView.messageBackgroundColor;
	textViewMessage.font = [Styles instance].defaultFont;	
	textViewMessage.textColor = [Styles instance].gameView.messageTextColor;
	
	viewMazeBorder.backgroundColor = [Styles instance].gameView.borderColor;

	[mazeView setupOpenGLViewport];
	[mazeView translateDGLX: 0.0 DGLY: [Constants instance].eyeHeight DGLZ: 0.0];

	[mazeView setupOpenGLTextures];
	
	UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(handleTapFrom:)];
	tapRecognizer.cancelsTouchesInView = NO;
	[self.view addGestureRecognizer: tapRecognizer];
	
	UISwipeGestureRecognizer *swipeLeftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget: self action: @selector(handleSwipeFrom:)];
    swipeLeftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
	[self.view addGestureRecognizer: swipeLeftRecognizer];
	
	UISwipeGestureRecognizer *swipeRightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget: self action: @selector(handleSwipeFrom:)];
    swipeRightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
	[self.view addGestureRecognizer: swipeRightRecognizer];

	UISwipeGestureRecognizer *swipeDownRecognizer  = [[UISwipeGestureRecognizer alloc] initWithTarget: self action: @selector(handleSwipeFrom:)];
    swipeDownRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
	[self.view addGestureRecognizer: swipeDownRecognizer];
}

- (void)viewWillAppear: (BOOL)animated
{	
	[super viewWillAppear: animated];

	lblTitle.text = topListsItem.mazeName;
	
	NSNumber *free = (NSNumber *)[[[NSBundle mainBundle] infoDictionary] objectForKey: @"Free"];
	if ([free boolValue] == YES)
	{
		ADBannerView *banner = [Globals instance].bannerView;
		
		banner.delegate = self;
		banner.frame = CGRectMake(banner.frame.origin.x, [Styles instance].screen.height - [Styles instance].bannerView.height, banner.frame.size.width, banner.frame.size.height);
		
		[self.view addSubview: banner];
	}

	[self loadMaze];
}

- (void)loadMaze
{
	comm = [[Communication alloc] initWithDelegate: self Selector: @selector(loadMazeResponse) Action: @"GetMaze" WaitMessage: @"Loading"];
	
	[XML addNodeDoc: comm.requestDoc Parent: [XML getRootNodeDoc: comm.requestDoc] NodeName: @"MazeId" NodeValue: [NSString stringWithFormat: @"%d", self.topListsItem.mazeId]];
	
	[comm post];
}

- (void)loadMazeResponse
{
	if (comm.errorOccurred == NO)
	{
		[[Globals instance].mazeMain populateFromXML: comm.responseDoc];

		[self loadMazeLocations];
	}
}

- (void)loadMazeLocations
{
	comm = [[Communication alloc] initWithDelegate: self Selector: @selector(loadMazeLocationsResponse) Action: @"GetLocations" WaitMessage: @"Loading"];
	
	[XML addNodeDoc: comm.requestDoc Parent: [XML getRootNodeDoc: comm.requestDoc] NodeName: @"MazeId" NodeValue: [NSString stringWithFormat: @"%d", self.topListsItem.mazeId]];
	
	[comm post];	
}

- (void)loadMazeLocationsResponse
{
	if (comm.errorOccurred == NO)
	{
		[[Globals instance].mazeMain.locations populateWithXML: comm.responseDoc];
		
		if (topListsItem.started == NO)
		{			
			[self setMazeStarted];
		}
		else 
		{
			[self Setup];
		}
	}
}

- (void)setMazeStarted
{
	comm = [[Communication alloc] initWithDelegate: self Selector: @selector(setMazeStartedResponse) Action: @"SetMazeStarted" WaitMessage: @"Saving Progress"];
	
	[XML addNodeDoc: comm.requestDoc Parent: [XML getRootNodeDoc: comm.requestDoc] NodeName: @"MazeId" NodeValue: [NSString stringWithFormat: @"%d", [Globals instance].mazeMain.mazeId]];
	[XML addNodeDoc: comm.requestDoc Parent: [XML getRootNodeDoc: comm.requestDoc] NodeName: @"UserId" NodeValue: UNIQUE_ID];
	
	[comm post];
}

- (void)setMazeStartedResponse
{
    [self Setup];
}

- (void)Setup
{
	[mazeView setupOpenGLVerticies];

	mazeView.GLX = 0.0;
	mazeView.GLY = 0.0;
	mazeView.GLZ = 0.0;
	mazeView.Theta = 0.0;
	
	prevLoc = nil;
	Location *startLoc = [[Globals instance].mazeMain.locations getLocationByType: [Constants instance].LocationType.Start];
	[self SetupNewLocation: startLoc];
	
	if ([Globals instance].mazeMain.backgroundSoundId != 0)
	{
		Sound *sound = [[Globals instance].sounds getSoundForId: [Globals instance].mazeMain.backgroundSoundId];
		[sound playWithNumberOfLoops: -1];
	}
	
	IsMoving = NO;
}

- (void)SetupNewLocation: (Location *)newLoc
{
	prevLoc = currLoc;
	
	currLoc = newLoc;
	currLoc.Visited = YES;

	[mazeView translateDGLX: -mazeView.GLX DGLY: 0.0 DGLZ: -mazeView.GLZ];
	
	float glx = [Constants instance].wallDepth / 2.0 + [Constants instance].wallWidth / 2.0 + (currLoc.x - 1) * [Constants instance].wallWidth;
	float glz = [Constants instance].wallDepth / 2.0 + [Constants instance].wallWidth / 2.0 + (currLoc.y - 1) * [Constants instance].wallWidth;
	
	[mazeView translateDGLX: glx DGLY: 0.0 DGLZ: glz];
	
	if (currLoc.type == [Constants instance].LocationType.Start || currLoc.type == [Constants instance].LocationType.Teleportation)
	{
		int theta = currLoc.direction;
		
		[mazeView rotateDTheta: -mazeView.Theta];
	
		[mazeView rotateDTheta: (float)theta];

		if (theta == 0)
			currDir = [Constants instance].Direction.North;
		else if (theta == 90)
			currDir = [Constants instance].Direction.East;
		else if (theta == 180)
			currDir = [Constants instance].Direction.South;
		else if (theta == 270)
			currDir = [Constants instance].Direction.West;
	}
	
	mapView.currLoc = currLoc;
	mapView.currDir = currDir;
	
	[mapView drawMap];
	
	[self displayMessage];

	[mazeView drawMaze];
}

- (void)handleTapFrom: (UITapGestureRecognizer *)recognizer 
{
	CGPoint location = [recognizer locationInView: self.view];
	
	if (CGRectContainsPoint(mazeView.frame, location) == YES)
	{
		[movements addObject: [NSNumber numberWithInt: [Constants instance].Movement.Forward]];
	}
	
	[self processMovements];
}

- (void)handleSwipeFrom: (UISwipeGestureRecognizer *)recognizer 
{
	CGPoint location = [recognizer locationInView: self.view];		
	
	if (CGRectContainsPoint(mazeView.frame, location) == YES)
	{
		if (recognizer.direction == UISwipeGestureRecognizerDirectionDown)
		{
			[movements addObject: [NSNumber numberWithInt: [Constants instance].Movement.Backward]];
		}
		else if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft)
		{
			[movements addObject: [NSNumber numberWithInt: [Constants instance].Movement.TurnLeft]];
		}
		else if (recognizer.direction == UISwipeGestureRecognizerDirectionRight)
		{
			[movements addObject: [NSNumber numberWithInt: [Constants instance].Movement.TurnRight]];
		}
	}
	
	[self processMovements];
}

- (void)processMovements
{
	if (IsMoving == NO && movements.count > 0)
	{
		IsMoving = YES;
		
		NSNumber *movement = [movements objectAtIndex: 0];
		[movements removeObjectAtIndex: 0];
		
		if ([movement integerValue] == [Constants instance].Movement.Backward || [movement integerValue] == [Constants instance].Movement.Forward)
		{
			[self moveForwardBackward: [movement integerValue]];
		}
		else if ([movement integerValue] == [Constants instance].Movement.TurnLeft || [movement integerValue] == [Constants instance].Movement.TurnRight)
		{
			[self turn: [movement integerValue]];
		}
	}	
}

// MOVE FORWARD / BACKWARD

- (void)moveForwardBackward: (int)movement 
{
	float dglx = 0.0, dglz = 0.0;

	dLocX = 0; 
	dLocY = 0; 

	if (movement == [Constants instance].Movement.Forward)
	{
		if (currDir == [Constants instance].Direction.North)
		{
			dLocX = 0;
			dLocY = -1;
			
			dglx = 0.0;
			dglz = -[Constants instance].wallWidth;
			
			movementDir = [Constants instance].Direction.North;
		}
		else if (currDir == [Constants instance].Direction.East)
		{
			dLocX = 1;
			dLocY = 0;
			
			dglx = [Constants instance].wallWidth;
			dglz = 0.0;
			
			movementDir = [Constants instance].Direction.East;
		}
		else if (currDir == [Constants instance].Direction.South)
		{
			dLocX = 0;
			dLocY = 1;
			
			dglx = 0.0;
			dglz = [Constants instance].wallWidth;
			
			movementDir = [Constants instance].Direction.South;
		}
		else if (currDir == [Constants instance].Direction.West)
		{
			dLocX = -1;
			dLocY = 0;
			
			dglx = -[Constants instance].wallWidth;
			dglz = 0.0;
			
			movementDir = [Constants instance].Direction.West;
		}
	}
	else if (movement == [Constants instance].Movement.Backward)
	{
		if (currDir == [Constants instance].Direction.North)
		{
			dLocX = 0;
			dLocY = 1;
			
			dglx = 0.0;
			dglz = [Constants instance].wallWidth;
			
			movementDir = [Constants instance].Direction.South;
		}
		else if (currDir == [Constants instance].Direction.East)
		{
			dLocX = -1;
			dLocY = 0;
			
			dglx = -[Constants instance].wallWidth;
			dglz = 0.0;

			movementDir = [Constants instance].Direction.West;
		}
		else if (currDir == [Constants instance].Direction.South)
		{
			dLocX = 0;
			dLocY = -1;
			
			dglx = 0.0;
			dglz = -[Constants instance].wallWidth;
			
			movementDir = [Constants instance].Direction.North;
		}
		else if (currDir == [Constants instance].Direction.West)
		{
			dLocX = 1;
			dLocY = 0;
			
			dglx = [Constants instance].wallWidth;
			dglz = 0.0;
			
			movementDir = [Constants instance].Direction.East;
		}
	}
	
	int wallType = [[Globals instance].mazeMain.locations getWallTypeLocX: currLoc.x LocY: currLoc.y Direction: movementDir];
	
	// Animate Movement
	
	stepCount = 1;
	steps = (int)([Constants instance].movementDuration / moveStepDurationAvg);
	
	// steps must be even for bounce back
	if (steps % 2 == 1)
		steps = steps + 1;
	
	dglx_step = dglx / (float)steps;
	dglz_step = dglz / (float)steps;
	
	wallRemoved = NO;
	directionReversed = NO;

	//NSLog(@"x = %f, z = %f", mazeView.GLX, mazeView.GLZ);	
	
	//NSLog(@"step duration avg = %f", moveStepDurationAvg);
	
	movementStartDate = [[NSDate alloc] init];
	if (wallType == [Constants instance].WallType.None || wallType == [Constants instance].WallType.Invisible || wallType == [Constants instance].WallType.Fake)
		[self moveStep: nil];
	else if (wallType == [Constants instance].WallType.Solid)
		[self moveEnd];
}

- (void)moveStep: (NSTimer *)timer
{
	[mazeView translateDGLX: dglx_step DGLY: 0.0 DGLZ: dglz_step];
	[mazeView drawMaze];	

	int wallType = [[Globals instance].mazeMain.locations getWallTypeLocX: currLoc.x LocY: currLoc.y Direction: movementDir];
	
	if (wallType == [Constants instance].WallType.Fake && stepCount >= steps * [Constants instance].fakeMovementPrcnt && wallRemoved == NO)
	{
		[[Globals instance].mazeMain.locations setWallTypeLocX: currLoc.x LocY: currLoc.y Direction: movementDir Type: [Constants instance].WallType.None];
		[mazeView setupOpenGLVerticies];
		[mazeView drawMaze];	
		
		wallRemoved = YES;
	}
	else if (wallType == [Constants instance].WallType.Invisible && stepCount >= steps / 2 && directionReversed == NO)
	{
		dglx_step = -dglx_step; 
		dglz_step = -dglz_step; 
		
		directionReversed = YES;
	}	
		
	if (stepCount < steps)	
	{
		stepCount = stepCount + 1;
		
		[NSTimer scheduledTimerWithTimeInterval: moveStepDurationAvg / 1000.0 target: self selector: @selector(moveStep:) userInfo: nil repeats: NO];
	}
	else
	{
		[self moveEnd];
	}
}

- (void)moveEnd
{
	NSDate *end = [NSDate date];

	float moveDuration = [end timeIntervalSinceDate: movementStartDate];
	
	int wallType = [[Globals instance].mazeMain.locations getWallTypeLocX: currLoc.x LocY: currLoc.y Direction: movementDir];
	
	if (wallType == [Constants instance].WallType.None || wallType == [Constants instance].WallType.Fake)
	{
		prevLoc = currLoc;
		
		currLoc = [[Globals instance].mazeMain.locations getLocationByX: currLoc.x + dLocX Y: currLoc.y + dLocY];
		currLoc.Visited = YES;
		
		moveStepDurationAvg = moveDuration / steps;
		
		mapView.currLoc = currLoc;
		mapView.currDir = currDir;
		
		[mapView drawMap];
		
		[self locationChanged];
	}
	else if (wallType == [Constants instance].WallType.Invisible)
	{
		[movements removeAllObjects];	

		[[Globals instance].mazeMain.locations setWallHitLocX: currLoc.x LocY: currLoc.y Direction: movementDir];

		mapView.currLoc = currLoc;
		mapView.currDir = currDir;
		
		[mapView drawMap];
		
		moveStepDurationAvg = moveDuration / steps;
	}

	//NSLog(@"x = %f, z = %f", mazeView.GLX, mazeView.GLZ);	
	
	//NSLog(@"movement steps = %d", steps);
	//NSLog(@"movement duration = %g", moveDuration);
	//NSLog(@"movement duration (60 fps) = %f", (1.0 / 60.0) * steps);
	//NSLog(@"step duration avg = %f", moveStepDurationAvg);	
	//NSLog(@" ");
	
	IsMoving = NO;
	[self processMovements];			
	
	return;	
}

// TURN

- (void)turn: (int)movement
{
	float dTheta = 0.0;
	
	if (movement == [Constants instance].Movement.TurnLeft)
	{
		dTheta = -90.0;

		if (currDir == [Constants instance].Direction.North) 
			currDir = [Constants instance].Direction.West;
		else if (currDir == [Constants instance].Direction.West) 
			currDir = [Constants instance].Direction.South;
		else if (currDir == [Constants instance].Direction.South) 
			currDir = [Constants instance].Direction.East;
		else if (currDir == [Constants instance].Direction.East) 
			currDir = [Constants instance].Direction.North;
	}
	else if (movement == [Constants instance].Movement.TurnRight)
	{
		dTheta = 90.0;

		if (currDir == [Constants instance].Direction.North) 
			currDir = [Constants instance].Direction.East;
		else if (currDir == [Constants instance].Direction.East) 
			currDir = [Constants instance].Direction.South;
		else if (currDir == [Constants instance].Direction.South) 
			currDir = [Constants instance].Direction.West;
		else if (currDir == [Constants instance].Direction.West) 
			currDir = [Constants instance].Direction.North;
	}
	
	stepCount = 1;
	steps = (int)([Constants instance].movementDuration / turnStepDurationAvg);
	
	dTheta_step = dTheta / (float)steps;

	//NSLog(@"theta = %f", mazeView.Theta);	
	
	//NSLog(@"step duration avg = %f", turnStepDurationAvg);
		
	movementStartDate = [[NSDate alloc] init];
	
	[self turnStep: nil];
}

- (void)turnStep: (NSTimer *)timer
{
	[mazeView rotateDTheta: dTheta_step];
	[mazeView drawMaze];
	
	if (stepCount < steps)	
	{
		stepCount = stepCount + 1;
		
		[NSTimer scheduledTimerWithTimeInterval: turnStepDurationAvg / 1000.0 target: self selector: @selector(turnStep:) userInfo: nil repeats: NO];
	}
	else
	{
		[self turnEnd];
	}	
}

- (void)turnEnd
{
	NSDate *end = [NSDate date];
	
	float turnDuration = [end timeIntervalSinceDate: movementStartDate];
	
	turnStepDurationAvg = turnDuration / steps;
	
	//NSLog(@"theta = %f", mazeView.Theta);	
	
	//NSLog(@"turn steps = %d", steps);
	//NSLog(@"turn duration = %g", turnDuration);
	//NSLog(@"turn duration (60 fps) = %f", (1.0 / 60.0) * steps);
	//NSLog(@"step duration avg = %f", turnStepDurationAvg);	
	//NSLog(@" ");	
	
	mapView.currLoc = currLoc;
	mapView.currDir = currDir;
	
	[mapView drawMap];
	
	IsMoving = NO;
	[self processMovements];
}

- (void)locationChanged
{
	if (currLoc.type == [Constants instance].LocationType.End)
	{
		[movements removeAllObjects];
		
		[self setMazeFinished];
	}
	else if (currLoc.type == [Constants instance].LocationType.StartOver)
	{
		[movements removeAllObjects];
		
		[Utilities ShowAlertWithDelegate: self Message: currLoc.message CancelButtonTitle: @"Start Over" OtherButtonTitle: @"" Tag: 1 Bounds: CGRectZero];
	}
	else if (currLoc.type == [Constants instance].LocationType.Teleportation)
	{
		[movements removeAllObjects];
		
		Location *teleportLoc = [[Globals instance].mazeMain.locations getLocationByX: currLoc.teleportX Y: currLoc.teleportY];
		[self SetupNewLocation: teleportLoc];
	}
	else 
	{
		[self displayMessage];
	}
}

- (void)setMazeFinished
{
	comm = [[Communication alloc] initWithDelegate: self Selector: @selector(setMazeFinishedResponse) Action: @"SetMazeFinished" WaitMessage: @"Saving Progress"];

	[XML addNodeDoc: comm.requestDoc Parent: [XML getRootNodeDoc: comm.requestDoc] NodeName: @"MazeId" NodeValue: [NSString stringWithFormat: @"%d", [Globals instance].mazeMain.mazeId]];
	[XML addNodeDoc: comm.requestDoc Parent: [XML getRootNodeDoc: comm.requestDoc] NodeName: @"UserId" NodeValue: UNIQUE_ID];

	[comm post];
}

- (void)setMazeFinishedResponse
{
	if (comm.errorOccurred == NO)
    {
		[self ShowEndAlert];
    }
}

- (void)displayMessage
{
	if (currLoc.type != [Constants instance].LocationType.Teleportation || (currLoc.type == [Constants instance].LocationType.Teleportation && prevLoc.type == [Constants instance].LocationType.Teleportation))
	{
		if ([currLoc.message isEqualToString: @""] == NO)
		{
			if ([textViewMessage.text isEqualToString: @""])
			{
				textViewMessage.text = currLoc.message;
			}
			else
			{
				textViewMessage.text = [currLoc.message stringByAppendingFormat: @"\n\n%@", textViewMessage.text];
				
				textViewMessage.contentOffset = CGPointZero; 
			}
		}
	}
}

- (void)clearMessage
{
	textViewMessage.text = @"";
}

- (void)ShowEndAlert
{
	NSString *cancelButtonTitle = @"";
	if (topListsItem.userRating == 0.0)
	{
		cancelButtonTitle = @"Don't Rate";
	}
	else 
	{
		cancelButtonTitle = @"OK";
	}
		
	endAlertView = [[UIAlertView alloc] initWithTitle: @"" message: currLoc.message delegate: self cancelButtonTitle: cancelButtonTitle otherButtonTitles: nil];
	endAlertView.tag = 2;

	[endAlertView show];	
}

- (void)willPresentAlertView: (UIAlertView *)alertView
{
	RatingView *ratingView = nil;
	
	if (alertView.tag == 2 && topListsItem.userRating == 0.0)
	{
		[Globals instance].gameViewController = self;
		
		UIView *buttonView = [alertView.subviews objectAtIndex: 3];

		// add rating view
		float ratingViewX = 20.0;
		float ratingViewY = buttonView.frame.origin.y - 2.0;
		float ratingViewWidth = alertView.frame.size.width - 2.0 * ratingViewX;		
		float ratingViewHeight = 45.0;
		
		ratingView = [[RatingView alloc] init];
		
		ratingView.frame = CGRectMake(ratingViewX, ratingViewY, ratingViewWidth, ratingViewHeight);
		ratingView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent: 0.0];
		
		ratingView.MazeId = topListsItem.mazeId;
		ratingView.Mode = [Constants instance].RatingMode.RecordEnd;
		ratingView.Rating = topListsItem.userRating;
		
		[alertView addSubview: ratingView];
		
		// add rating label
		float labelX = 0.0;
		float labelY = ratingView.frame.origin.y + ratingView.frame.size.height + 5.0;
		float labelWidth = alertView.frame.size.width;		
		float labelHeight = 20.0;
		
		UILabel *ratingLabel = [[UILabel alloc] initWithFrame: CGRectMake(labelX, labelY, labelWidth, labelHeight)];
		ratingLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent: 0.0];
		[ratingLabel setTextAlignment: UITextAlignmentCenter];
		[ratingLabel setTextColor: [Styles instance].endAlertView.textColor];
		ratingLabel.font = [UIFont systemFontOfSize: 14.0];  
		ratingLabel.text = @"Click a star above to rate.";

		[alertView addSubview: ratingLabel];
		
		float buttonViewY = ratingLabel.frame.origin.y + ratingLabel.frame.size.height + 22.0;
		float addedHeight = buttonViewY - buttonView.frame.origin.y;
		
		buttonView.frame = CGRectMake(buttonView.frame.origin.x, buttonViewY, buttonView.frame.size.width, buttonView.frame.size.height);
				
		alertView.frame = CGRectMake(alertView.frame.origin.x, alertView.frame.origin.y - addedHeight / 2.0, alertView.frame.size.width, alertView.frame.size.height + addedHeight);
	}
}

- (void)alertView: (UIAlertView *)alertView didDismissWithButtonIndex: (NSInteger)buttonIndex
{
	if (alertView.tag == 1)
	{
		Location *startLoc = [[Globals instance].mazeMain.locations getLocationByType: [Constants instance].LocationType.Start];
		[self SetupNewLocation: startLoc];
	}
	else if (alertView.tag == 2)
	{		
		[self goBack];
	}
}

- (void)dismissEndAlertView
{
	[endAlertView dismissWithClickedButtonIndex: 0 animated: YES];
}

// Back Button

- (IBAction)btnMazesBackTouchDown: (id)sender
{
	imageViewMazesBack.image = [UIImage imageNamed: @"btnMazesBackOrange.png"];
}

- (IBAction)btnMazesBackTouchUpInside: (id)sender
{
	imageViewMazesBack.image = [UIImage imageNamed: @"btnMazesBackBlue.png"];
	
	[self goBack];
}

- (void)goBack
{
	if ([Globals instance].mazeMain.backgroundSoundId != 0)
	{
		Sound *sound = [[Globals instance].sounds getSoundForId: [Globals instance].mazeMain.backgroundSoundId];
		[sound stop];	
	}
	
	[[Globals instance].topListsViewController loadMazeList];
	
	[[self navigationController] popViewControllerAnimated: YES];
}

// How To Play Button

- (IBAction)btnHowToPlayTouchDown: (id)sender
{
	imageViewHowToPlay.image = [UIImage imageNamed: @"btnHowToPlayOrange.png"];
}

- (IBAction)btnHowToPlayTouchUpInside: (id)sender
{
	imageViewHowToPlay.image = [UIImage imageNamed: @"btnHowToPlayBlue.png"];
	
	[self displayHelp];
}

- (void)displayHelp
{
	if (self.popoverController.popoverVisible == YES)
	{
		[self.popoverController dismissPopoverAnimated: YES];  
		return;
	}
	
	UIViewController *vcHelp = [[UIViewController alloc] initWithNibName: @"GameHelpViewController" bundle: nil];
	vcHelp.view.backgroundColor = [Styles instance].gameView.helpBackgroundColor;
	
	UILabel *label = (UILabel *)[vcHelp.view.subviews objectAtIndex: 0];
	label.textColor = [Styles instance].gameView.helpTextColor;
	
	UIPopoverController *pcPopover = [[UIPopoverController alloc] initWithContentViewController: vcHelp];

	pcPopover.popoverContentSize = CGSizeMake(vcHelp.view.frame.size.width, vcHelp.view.frame.size.height);

	pcPopover.delegate = self;

	self.popoverController = pcPopover;

	[self.popoverController presentPopoverFromRect: btnHowToPlay.frame inView: self.view permittedArrowDirections: UIPopoverArrowDirectionAny animated: YES];
}

- (void)bannerView: (ADBannerView *)banner didFailToReceiveAdWithError: (NSError *)error
{
	NSLog(@"%@", [error localizedDescription]);
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
	
	NSLog(@"Maze View Controller received a memory warning.");
}

- (void)viewWillDisappear: (BOOL)animated
{
	[super viewWillDisappear: animated];

	[[Globals instance].mazeMain reset];
	
	// reset GL coordinates
	[mazeView translateDGLX: -mazeView.GLX DGLY: 0.0 DGLZ: -mazeView.GLZ];
	[mazeView rotateDTheta: -mazeView.Theta];
	
	[movements removeAllObjects];

	if (self.popoverController.popoverVisible == YES)
		[self.popoverController dismissPopoverAnimated: YES];
	
	NSNumber *free = (NSNumber *)[[[NSBundle mainBundle] infoDictionary] objectForKey: @"Free"];
	if ([free boolValue] == YES)
	{
		[Globals instance].bannerView.delegate = nil;
		[[Globals instance].bannerView removeFromSuperview];
	}	
}

- (void)viewDidUnload 
{
	[super viewDidUnload];
	
	[mazeView deleteTextures];
}

@end





