//
//  GameViewController.m
//  Mazes
//
//  Created by Andre Muis on 4/18/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import "GameViewController.h"

#import "ActivityViewStyle.h"
#import "AppDelegate.h"
#import "Colors.h"
#import "CurrentUser.h"
#import "MAEvents.h"
#import "MAEvent.h"
#import "MainListItem.h"
#import "MainListViewController.h"
#import "MainViewController.h"
#import "MapView.h"
#import "Maze.h"
#import "MazeUser.h"
#import "MazeView.h"
#import "RatingViewStyle.h"
#import "ServerQueue.h"
#import "Sounds.h"
#import "Sound.h"
#import "Textures.h"
#import "Utilities.h"

@implementation GameViewController

+ (GameViewController *)shared
{
	static GameViewController *instance = nil;
	
	@synchronized(self)
	{
		if (instance == nil)
		{
			instance = [[GameViewController alloc] initWithNibName: @"GameViewController" bundle: nil];
		}
	}
	
	return instance;
}

- (id)initWithNibName: (NSString *)nibNameOrNil bundle: (NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName: nibNameOrNil bundle: nibBundleOrNil];
    
    if (self)
    {
        self->operationQueue = [[NSOperationQueue alloc] init];
        
        self->getGameDataEvent = [[MAEvent alloc] initWithTarget: self
                                                          action: @selector(getGameData)
                                                    intervalSecs: [Constants shared].serverRetryDelaySecs
                                                         repeats: NO];

        self->saveMazeUserEvent = [[MAEvent alloc] initWithTarget: self
                                                           action: @selector(saveMazeUser)
                                                     intervalSecs: [Constants shared].serverRetryDelaySecs
                                                          repeats: NO];

        self->maze = nil;
        self->locations = nil;
        
        self->mazeUser = nil;
        
        self->movements = [[NSMutableArray alloc] init];
		
        self->moveStepDurationAvg = [Constants shared].stepDurationAvgStart;
        self->turnStepDurationAvg = [Constants shared].stepDurationAvgStart;
    }
    
    return self;
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	self.titleLabel.backgroundColor = [Styles shared].gameView.titleBackgroundColor;
	self.titleLabel.font = [Styles shared].gameView.titleFont;
	self.titleLabel.textColor = [Styles shared].gameView.titleTextColor;
	
	self.mapBorderView.backgroundColor = [Styles shared].gameView.borderColor;
	self.mapView.backgroundColor = [Styles shared].map.backgroundColor;
	
	self.messageBorderView.backgroundColor = [Styles shared].gameView.borderColor;
	
	self.messageTextView.backgroundColor = [Styles shared].gameView.messageBackgroundColor;
	self.messageTextView.font = [Styles shared].defaultFont;
	self.messageTextView.textColor = [Styles shared].gameView.messageTextColor;
	
	self.mazeBorderView.backgroundColor = [Styles shared].gameView.borderColor;

	[self.mazeView setupOpenGLViewport];
	[self.mazeView translateDGLX: 0.0 dGLY: [Constants shared].eyeHeight dGLZ: 0.0];

	[self.mazeView setupOpenGLTextures];
	
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
    
    self.activityIndicatorView.color = [Styles shared].activityView.color;
}

- (void)viewWillAppear: (BOOL)animated
{	
	[super viewWillAppear: animated];

    if (self->movingToParentViewController == YES)
    {
        self.titleLabel.text = self->maze.name;
        
        self.mazeView.userInteractionEnabled = NO;
        
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

        
        appDelegate.bannerView.frame = CGRectMake(appDelegate.bannerView.frame.origin.x,
                                                  self.view.frame.size.height - appDelegate.bannerView.frame.size.height,
                                                  appDelegate.bannerView.frame.size.width,
                                                  appDelegate.bannerView.frame.size.height);
        
        [self.view addSubview: appDelegate.bannerView];
        
        self.activityIndicatorView.hidden = NO;
        [self.activityIndicatorView startAnimating];
        
        [self getGameData];
    }
}

- (void)getGameData
{
    [self->operationQueue cancelAllOperations];
    
    [self->operationQueue addOperation: [[ServerOperations shared] getMazeOperationWithDelegate: self
                                                                                         mazeId: self.mazeId]];
    
    [self->operationQueue addOperation: [[ServerOperations shared] getLocationsOperationWithDelegate: self
                                                                                              mazeId: self.mazeId]];
    
    [self->operationQueue addOperation: [[ServerOperations shared] getMazeUserOperationWithDelegate: self
                                                                                             mazeId: self.mazeId
                                                                                             userId: [CurrentUser shared].id]];
}

- (void)serverOperationsGetMaze: (Maze *)aMaze error: (NSError *)error
{
    if (error == nil)
    {
        self->maze = aMaze;

        [self setup];
    }
    else
    {
        if ([[MAEvents shared] hasEvent: self->getGameDataEvent] == NO)
        {
            [[MAEvents shared] addEvent: self->getGameDataEvent];
        }
    }
}

- (void)serverOperationsGetLocations: (NSArray *)aLocations error: (NSError *)error
{
    if (error == nil)
    {
        self->locations = aLocations;
        
        [self setup];
    }
    else
    {
        if ([[MAEvents shared] hasEvent: self->getGameDataEvent] == NO)
        {
            [[MAEvents shared] addEvent: self->getGameDataEvent];
        }
    }
}

- (void)serverOperationsGetMazeUser: (MazeUser *)aMazeUser error: (NSError *)error
{
    if (error == nil)
    {
        self->mazeUser = aMazeUser;
        
        [self setup];
    }
    else
    {
        if ([[MAEvents shared] hasEvent: self->getGameDataEvent] == NO)
        {
            [[MAEvents shared] addEvent: self->getGameDataEvent];
        }
    }
}

- (void)setup
{
    //NSLog(@"maze = %@", self->maze);
    //NSLog(@"locations = %@", self->locations);
    //NSLog(@"mazeUser = %@", self->mazeUser);
    //NSLog(@"sounds = %d", [Sounds shared].count);
    //NSLog(@"textures = %d", [Textures shared].count);
    
    if (self->maze != nil && self->locations != nil && self->mazeUser != nil && [Sounds shared].count > 0 && [Textures shared].count > 0)
    {
        [self->maze.locations populateWithArray: self->locations];
        
        if ([[MAEvents shared] hasEvent: self->getGameDataEvent] == YES)
        {
            [[MAEvents shared] removeEvent: self->getGameDataEvent];
        }
        
        if (self->operationQueue.operationCount != 0)
        {
            [Utilities logWithClass: [self class] format: @"Operation queue should be empty. Operation count = %d", self->operationQueue.operationCount];
        }
        
        if (self->mazeUser.started == NO)
        {
            self->mazeUser.started = YES;

            [[ServerQueue shared] addObject: self->mazeUser];
        }
        
        self.activityIndicatorView.hidden = YES;
        [self.activityIndicatorView stopAnimating];
        
     
        self.mapView.maze = self->maze;
        
        
        self.mazeView.userInteractionEnabled = YES;
        
        self.mazeView.maze = self->maze;
        
        [self.mazeView setupOpenGLVerticies];

        self.mazeView.glX = 0.0;
        self.mazeView.glY = 0.0;
        self.mazeView.glZ = 0.0;
        self.mazeView.theta = 0.0;
        
        
        prevLoc = nil;
        Location *startLoc = [self->maze.locations getLocationByAction: MALocationActionStart];
        [self setupNewLocation: startLoc];
        
        if (self->maze.backgroundSoundId != 0)
        {
            Sound *sound = [[Sounds shared] soundWithId: self->maze.backgroundSoundId];
            [sound playWithNumberOfLoops: -1];
        }
        
        isMoving = NO;
    }
}

- (void)setupNewLocation: (Location *)newLoc
{
	prevLoc = currLoc;
	
	currLoc = newLoc;
	currLoc.visited = YES;

	[self.mazeView translateDGLX: -self.mazeView.glX dGLY: 0.0 dGLZ: -self.mazeView.glZ];
	
	float glX = [Constants shared].wallDepth / 2.0 + [Constants shared].wallWidth / 2.0 + (currLoc.x - 1) * [Constants shared].wallWidth;
	float glZ = [Constants shared].wallDepth / 2.0 + [Constants shared].wallWidth / 2.0 + (currLoc.y - 1) * [Constants shared].wallWidth;
	
	[self.mazeView translateDGLX: glX dGLY: 0.0 dGLZ: glZ];
	
	if (currLoc.action == MALocationActionStart || currLoc.action == MALocationActionTeleport)
	{
		int theta = currLoc.direction;
		
		[self.mazeView rotateDTheta: -self.mazeView.theta];
	
		[self.mazeView rotateDTheta: (float)theta];

        switch (theta)
        {
            case 0:
                currDir = MADirectionNorth;
                break;

            case 90:
                currDir = MADirectionEast;
                break;
                
            case 180:
                currDir = MADirectionSouth;
                break;
                
            case 270:
                currDir = MADirectionWest;
                break;
                
            default:
                [Utilities logWithClass: [self class] format: @"theta set to an illegal value: %d", theta];
                break;
        }
	}
	
	self.mapView.currLoc = currLoc;
	self.mapView.currDir = currDir;
	
	[self.mapView drawSurroundings];
	
	[self displayMessage];

	[self.mazeView drawMaze];
}

- (void)handleTapFrom: (UITapGestureRecognizer *)recognizer 
{
	CGPoint location = [recognizer locationInView: self.view];
	
	if (CGRectContainsPoint(self.mazeView.frame, location) == YES)
	{
		[movements addObject: [NSNumber numberWithInt: MAMovementForward]];
	}
	
	[self processMovements];
}

- (void)handleSwipeFrom: (UISwipeGestureRecognizer *)recognizer 
{
	CGPoint location = [recognizer locationInView: self.view];		
	
	if (CGRectContainsPoint(self.mazeView.frame, location) == YES)
	{
		if (recognizer.direction == UISwipeGestureRecognizerDirectionDown)
		{
			[movements addObject: [NSNumber numberWithInt: MAMovementBackward]];
		}
		else if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft)
		{
			[movements addObject: [NSNumber numberWithInt: MAMovementTurnLeft]];
		}
		else if (recognizer.direction == UISwipeGestureRecognizerDirectionRight)
		{
			[movements addObject: [NSNumber numberWithInt: MAMovementTurnRight]];
		}
	}
	
	[self processMovements];
}

- (void)processMovements
{
	if (isMoving == NO && movements.count > 0)
	{
		isMoving = YES;
		
		NSNumber *movement = [movements objectAtIndex: 0];
		[movements removeObjectAtIndex: 0];
		
		if ([movement integerValue] == MAMovementBackward || [movement integerValue] == MAMovementForward)
		{
			[self moveForwardBackward: [movement integerValue]];
		}
		else if ([movement integerValue] == MAMovementTurnLeft || [movement integerValue] == MAMovementTurnRight)
		{
			[self turn: [movement integerValue]];
		}
	}	
}

// MOVE FORWARD / BACKWARD

- (void)moveForwardBackward: (MAMovementType)movement
{
	float dglx = 0.0, dglz = 0.0;

	dLocX = 0; 
	dLocY = 0; 

	if (movement == MAMovementForward)
	{
		if (currDir == MADirectionNorth)
		{
			dLocX = 0;
			dLocY = -1;
			
			dglx = 0.0;
			dglz = -[Constants shared].wallWidth;
			
			movementDir = MADirectionNorth;
		}
		else if (currDir == MADirectionEast)
		{
			dLocX = 1;
			dLocY = 0;
			
			dglx = [Constants shared].wallWidth;
			dglz = 0.0;
			
			movementDir = MADirectionEast;
		}
		else if (currDir == MADirectionSouth)
		{
			dLocX = 0;
			dLocY = 1;
			
			dglx = 0.0;
			dglz = [Constants shared].wallWidth;
			
			movementDir = MADirectionSouth;
		}
		else if (currDir == MADirectionWest)
		{
			dLocX = -1;
			dLocY = 0;
			
			dglx = -[Constants shared].wallWidth;
			dglz = 0.0;
			
			movementDir = MADirectionWest;
		}
	}
	else if (movement == MAMovementBackward)
	{
		if (currDir == MADirectionNorth)
		{
			dLocX = 0;
			dLocY = 1;
			
			dglx = 0.0;
			dglz = [Constants shared].wallWidth;
			
			movementDir = MADirectionSouth;
		}
		else if (currDir == MADirectionEast)
		{
			dLocX = -1;
			dLocY = 0;
			
			dglx = -[Constants shared].wallWidth;
			dglz = 0.0;

			movementDir = MADirectionWest;
		}
		else if (currDir == MADirectionSouth)
		{
			dLocX = 0;
			dLocY = -1;
			
			dglx = 0.0;
			dglz = -[Constants shared].wallWidth;
			
			movementDir = MADirectionNorth;
		}
		else if (currDir == MADirectionWest)
		{
			dLocX = 1;
			dLocY = 0;
			
			dglx = [Constants shared].wallWidth;
			dglz = 0.0;
			
			movementDir = MADirectionEast;
		}
	}
	
	MAWallType wallType = [self->maze.locations getWallTypeLocX: currLoc.x locY: currLoc.y direction: movementDir];
	
	// Animate Movement
	
	stepCount = 1;
	steps = (int)([Constants shared].movementDuration / moveStepDurationAvg);
	
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
	if (wallType == MAWallNone || wallType == MAWallInvisible || wallType == MAWallFake)
    {
		[self moveStep: nil];
    }
	else if (wallType == MAWallSolid)
    {
		[self moveEnd];
    }
}

- (void)moveStep: (NSTimer *)timer
{
	[self.mazeView translateDGLX: dglx_step dGLY: 0.0 dGLZ: dglz_step];
	[self.mazeView drawMaze];

	MAWallType wallType = [self->maze.locations getWallTypeLocX: currLoc.x locY: currLoc.y direction: movementDir];
	
	if (wallType == MAWallFake && stepCount >= steps * [Constants shared].fakeMovementPrcnt && wallRemoved == NO)
	{
		[self->maze.locations setWallTypeLocX: currLoc.x locY: currLoc.y direction: movementDir type: MAWallNone];
		[self.mazeView setupOpenGLVerticies];
		[self.mazeView drawMaze];
		
		wallRemoved = YES;
	}
	else if (wallType == MAWallInvisible && stepCount >= steps / 2 && directionReversed == NO)
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
	
	MAWallType wallType = [self->maze.locations getWallTypeLocX: currLoc.x locY: currLoc.y direction: movementDir];
	
	if (wallType == MAWallNone || wallType == MAWallFake)
	{
		prevLoc = currLoc;
		
		currLoc = [self->maze.locations getLocationByX: currLoc.x + dLocX y: currLoc.y + dLocY];
		currLoc.Visited = YES;
		
		moveStepDurationAvg = moveDuration / steps;
		
		self.mapView.currLoc = currLoc;
		self.mapView.currDir = currDir;
		
		[self.mapView drawSurroundings];
		
		[self locationChanged];
	}
	else if (wallType == MAWallInvisible)
	{
		[movements removeAllObjects];	

		[self->maze.locations setWallHitLocX: currLoc.x locY: currLoc.y direction: movementDir];

		self.mapView.currLoc = currLoc;
		self.mapView.currDir = currDir;
		
		[self.mapView drawSurroundings];
		
		moveStepDurationAvg = moveDuration / steps;
	}

	//NSLog(@"x = %f, z = %f", mazeView.GLX, mazeView.GLZ);	
	
	//NSLog(@"movement steps = %d", steps);
	//NSLog(@"movement duration = %g", moveDuration);
	//NSLog(@"movement duration (60 fps) = %f", (1.0 / 60.0) * steps);
	//NSLog(@"step duration avg = %f", moveStepDurationAvg);	
	//NSLog(@" ");
	
	isMoving = NO;
	[self processMovements];			
	
	return;	
}

// TURN

- (void)turn: (MAMovementType)movement
{
	float dTheta = 0.0;
	
	if (movement == MAMovementTurnLeft)
	{
		dTheta = -90.0;

		if (currDir == MADirectionNorth)
			currDir = MADirectionWest;
		else if (currDir == MADirectionWest)
			currDir = MADirectionSouth;
		else if (currDir == MADirectionSouth)
			currDir = MADirectionEast;
		else if (currDir == MADirectionEast)
			currDir = MADirectionNorth;
	}
	else if (movement == MAMovementTurnRight)
	{
		dTheta = 90.0;

		if (currDir == MADirectionNorth)
			currDir = MADirectionEast;
		else if (currDir == MADirectionEast)
			currDir = MADirectionSouth;
		else if (currDir == MADirectionSouth)
			currDir = MADirectionWest;
		else if (currDir == MADirectionWest)
			currDir = MADirectionNorth;
	}
	
	stepCount = 1;
	steps = (int)([Constants shared].movementDuration / turnStepDurationAvg);
	
	dTheta_step = dTheta / (float)steps;

	//NSLog(@"theta = %f", mazeView.Theta);	
	
	//NSLog(@"step duration avg = %f", turnStepDurationAvg);
		
	movementStartDate = [[NSDate alloc] init];
	
	[self turnStep: nil];
}

- (void)turnStep: (NSTimer *)timer
{
	[self.mazeView rotateDTheta: dTheta_step];
	[self.mazeView drawMaze];
	
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
	
	self.mapView.currLoc = currLoc;
	self.mapView.currDir = currDir;
	
	[self.mapView drawSurroundings];
	
	isMoving = NO;
	[self processMovements];
}

- (void)locationChanged
{
	if (currLoc.action == MALocationActionEnd)
	{
		[movements removeAllObjects];
		
        if (self->mazeUser.finished == NO)
        {
            self->mazeUser.finished = YES;
            
            [[ServerQueue shared] addObject: self->mazeUser];
        }
        
        [self showEndAlert];
	}
	else if (currLoc.action == MALocationActionStartOver)
	{
		[movements removeAllObjects];
		
        self->startOverAlertView = [[UIAlertView alloc] initWithTitle: @""
                                                              message: currLoc.message
                                                             delegate: self
                                                    cancelButtonTitle: @"Start Over"
                                                    otherButtonTitles: nil];
        [self->startOverAlertView show];
	}
	else if (currLoc.action == MALocationActionTeleport)
	{
		[movements removeAllObjects];
		
		Location *teleportLoc = [self->maze.locations getLocationByX: currLoc.teleportX y: currLoc.teleportY];
		[self setupNewLocation: teleportLoc];
	}
	else 
	{
		[self displayMessage];
	}
}

- (void)displayMessage
{
	if (currLoc.action != MALocationActionTeleport || (currLoc.action == MALocationActionTeleport && prevLoc.action == MALocationActionTeleport))
	{
		if ([currLoc.message isEqualToString: @""] == NO)
		{
			if ([self.messageTextView.text isEqualToString: @""])
			{
				self.messageTextView.text = currLoc.message;
			}
			else
			{
				self.messageTextView.text = [currLoc.message stringByAppendingFormat: @"\n\n%@", self.messageTextView.text];
				
				self.messageTextView.contentOffset = CGPointZero; 
			}
		}
	}
}

- (void)clearMessage
{
	self.messageTextView.text = @"";
}

- (void)showEndAlert
{
	NSString *cancelButtonTitle = @"";
	if (self->mazeUser.rating == 0.0)
	{
		cancelButtonTitle = @"Don't Rate";
	}
	else 
	{
		cancelButtonTitle = @"OK";
	}
		
	self->endAlertView = [[UIAlertView alloc] initWithTitle: @""
                                                    message: currLoc.message
                                                   delegate: self
                                          cancelButtonTitle: cancelButtonTitle
                                          otherButtonTitles: nil];

	[endAlertView show];
}

- (void)willPresentAlertView: (UIAlertView *)alertView
{
	if (alertView == self->endAlertView && self->mazeUser.rating == 0.0)
	{
		UIView *buttonView = [alertView.subviews objectAtIndex: 3];

		// add rating view
		float ratingViewX = 20.0;
		float ratingViewY = buttonView.frame.origin.y - 2.0;
		float ratingViewWidth = alertView.frame.size.width - 2.0 * ratingViewX;		
		float ratingViewHeight = 45.0;
		
		RatingView *ratingView = [[RatingView alloc] init];
		
		ratingView.frame = CGRectMake(ratingViewX, ratingViewY, ratingViewWidth, ratingViewHeight);
		ratingView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent: 0.0];
		
        [ratingView setupWithDelegate: self
                               rating: self->mazeUser.rating
                                 type: MARatingViewSelectable
                            starColor: [Styles shared].ratingView.mazeFinishedStarColor];
        
		[alertView addSubview: ratingView];
		
		// add rating label
		float labelX = 0.0;
		float labelY = ratingView.frame.origin.y + ratingView.frame.size.height + 5.0;
		float labelWidth = alertView.frame.size.width;		
		float labelHeight = 20.0;
		
		UILabel *ratingLabel = [[UILabel alloc] initWithFrame: CGRectMake(labelX, labelY, labelWidth, labelHeight)];
		ratingLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent: 0.0];
		[ratingLabel setTextAlignment: NSTextAlignmentCenter];
		[ratingLabel setTextColor: [Styles shared].endAlertView.textColor];
		ratingLabel.font = [UIFont systemFontOfSize: 14.0];  
		ratingLabel.text = @"Click a star above to rate.";

		[alertView addSubview: ratingLabel];
		
		float buttonViewY = ratingLabel.frame.origin.y + ratingLabel.frame.size.height + 22.0;
		float addedHeight = buttonViewY - buttonView.frame.origin.y;
		
		buttonView.frame = CGRectMake(buttonView.frame.origin.x, buttonViewY, buttonView.frame.size.width, buttonView.frame.size.height);
				
		alertView.frame = CGRectMake(alertView.frame.origin.x, alertView.frame.origin.y - addedHeight / 2.0, alertView.frame.size.width, alertView.frame.size.height + addedHeight);
	}
}

- (void)ratingView: (RatingView *)ratingView ratingChanged: (float)newRating
{
    if (newRating != self->mazeUser.rating)
    {
        self->mazeUser.rating = newRating;
        
        [[ServerQueue shared] addObject: self->mazeUser];
    }
    
    [self dismissEndAlertView];
}

- (void)alertView: (UIAlertView *)alertView didDismissWithButtonIndex: (NSInteger)buttonIndex
{
	if (alertView == self->startOverAlertView)
	{
		Location *startLoc = [self->maze.locations getLocationByAction: MALocationActionStart];
		[self setupNewLocation: startLoc];
	}
	else if (alertView == self->endAlertView)
	{		
		[self goBack];
	}
}

- (void)dismissEndAlertView
{
	[endAlertView dismissWithClickedButtonIndex: 0 animated: YES];
}

// Back Button

- (IBAction)backButtonTouchDown: (id)sender
{
	self.backImageView.image = [UIImage imageNamed: @"btnMazesBackOrange.png"];
}

- (IBAction)backButtonTouchUpInside: (id)sender
{
	self.backImageView.image = [UIImage imageNamed: @"btnMazesBackBlue.png"];
	
	[self goBack];
}

- (void)goBack
{
	if (self->maze.backgroundSoundId != 0)
	{
		Sound *sound = [[Sounds shared] soundWithId: self->maze.backgroundSoundId];
		[sound stop];	
	}
	
    [self->operationQueue cancelAllOperations];
    [[MAEvents shared] removeEvent: self->saveMazeUserEvent];
    
    self.activityIndicatorView.hidden = YES;
    [self.activityIndicatorView stopAnimating];
    
	[[MainViewController shared] transitionFromViewController: self
                                             toViewController: [MainListViewController shared]
                                                   transition: MATransitionFlipFromRight];
}

// How To Play Button

- (IBAction)instructionsButtonTouchDown: (id)sender
{
	self.instructionsImageView.image = [UIImage imageNamed: @"btnHowToPlayOrange.png"];
}

- (IBAction)instructionsButtonTouchUpInside: (id)sender
{
	self.instructionsImageView.image = [UIImage imageNamed: @"btnHowToPlayBlue.png"];
	
	[self displayHelp];
}

- (void)displayHelp
{
	if (self.popoverController2.popoverVisible == YES)
	{
		[self.popoverController2 dismissPopoverAnimated: YES];
		return;
	}
	
	UIViewController *vcHelp = [[UIViewController alloc] initWithNibName: @"GameHelpViewController" bundle: nil];
	vcHelp.view.backgroundColor = [Styles shared].gameView.helpBackgroundColor;
	
	UILabel *label = (UILabel *)[vcHelp.view.subviews objectAtIndex: 0];
	label.textColor = [Styles shared].gameView.helpTextColor;
	
	UIPopoverController *pcPopover = [[UIPopoverController alloc] initWithContentViewController: vcHelp];

	pcPopover.popoverContentSize = CGSizeMake(vcHelp.view.frame.size.width, vcHelp.view.frame.size.height);

	pcPopover.delegate = self;

	self.popoverController2 = pcPopover;

	[self.popoverController2 presentPopoverFromRect: self.instructionsButton.frame
                                             inView: self.view
                           permittedArrowDirections: UIPopoverArrowDirectionAny animated: YES];
}

- (void)viewWillDisappear: (BOOL)animated
{
	[super viewWillDisappear: animated];

	// reset GL coordinates
	[self.mazeView translateDGLX: -self.mazeView.glX dGLY: 0.0 dGLZ: -self.mazeView.glZ];
	[self.mazeView rotateDTheta: -self.mazeView.theta];
	
	[movements removeAllObjects];

	if (self.popoverController2.popoverVisible == YES)
    {
		[self.popoverController2 dismissPopoverAnimated: YES];
    }
}

- (void)viewDidDisappear: (BOOL)animated
{
    if (self->movingToParentViewController)
    {
        self->maze = nil;
        self->mazeUser = nil;
        
        [self.mapView clear];
        [self clearMessage];
        [self.mazeView clearMaze];
    }
    
    [super viewDidDisappear: animated];
}

- (void)viewDidUnload
{
	[self.mazeView deleteTextures];

	[super viewDidUnload];
}

@end





