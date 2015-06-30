//
//  MAGameViewController.m
//  Mazes
//
//  Created by Andre Muis on 4/18/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import "MAGameViewController.h"

#import "MAActivityIndicatorStyle.h"
#import "MAColors.h"
#import "MAConstants.h"
#import "MALocation.h"
#import "MAGameScreenStyle.h"
#import "MAInfoPopupView.h"
#import "MAInstructionsViewController.h"
#import "MAMapStyle.h"
#import "MAMapView.h"
#import "MAMazeSummary.h"
#import "MARatingPopoverStyle.h"
#import "MARatingPopupView.h"
#import "MASoundManager.h"
#import "MASound.h"
#import "MAStyles.h"
#import "MATextureManager.h"
#import "MATopMazesViewController.h"
#import "MAUtilities.h"
#import "MAWall.h"
#import "MAWorldManager.h"
#import "MAWorld.h"

@interface MAGameViewController () <
    UIGestureRecognizerDelegate,
    UIAlertViewDelegate>

@property (readonly, strong, nonatomic) MAMazeManager *mazeManager;
@property (readonly, strong, nonatomic) MATextureManager *textureManager;
@property (readonly, strong, nonatomic) MASoundManager *soundManager;
@property (readonly, strong, nonatomic) MAStyles *styles;

@property (readwrite, strong, nonatomic) NSUUID *gameSessionUUID;

@property (strong, nonatomic) MALocation *previousLocation;
@property (strong, nonatomic) MALocation *currentLocation;

@property (assign, nonatomic) MADirectionType facingDirection;

@property (strong, nonatomic) NSDate *movementStartDate;

@property (strong, nonatomic) NSMutableArray *movements;
@property (assign, nonatomic) BOOL isMoving;

@property (assign, nonatomic) MADirectionType movementDirection;

@property (assign, nonatomic) int dLocX;
@property (assign, nonatomic) int dLocY;

@property (assign, nonatomic) float dglx_step;
@property (assign, nonatomic) float dglz_step;
@property (assign, nonatomic) float dTheta_step;

@property (assign, nonatomic) int steps;
@property (assign, nonatomic) int stepCount;

@property (assign, nonatomic) BOOL wallRemoved;
@property (assign, nonatomic) BOOL directionReversed;

@property (strong, nonatomic) UIPopoverController *instructionsPopoverController;

@property (weak, nonatomic) IBOutlet UIImageView *backImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *instructionsImageView;
@property (weak, nonatomic) IBOutlet UIButton *instructionsButton;

@property (weak, nonatomic) IBOutlet UIView *mapBorderView;
@property (weak, nonatomic) IBOutlet MAMapView *mapView;

@property (weak, nonatomic) IBOutlet UIView *messageBorderView;
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;

@property (weak, nonatomic) IBOutlet UIView *mazeBorderView;

@property (readonly, strong, nonatomic) UIAlertView *downloadMazeErrorAlertView;
@property (readonly, strong, nonatomic) UIAlertView *saveMazeStartedErrorAlertView;

@property (readonly, strong, nonatomic) UIAlertView *saveFoundMazeExitErrorAlertView;
@property (readonly, strong, nonatomic) UIAlertView *saveFoundMazeExitNoRetryErrorAlertView;

@property (readonly, strong, nonatomic) UIAlertView *saveMazeRatingErrorAlertView;

@end

@implementation MAGameViewController

- (id)initWithMazeManager: (MAMazeManager *)mazeManager
           textureManager: (MATextureManager *)textureManager
             soundManager: (MASoundManager *)soundManager
{
    self = [[MAGameViewController alloc] initWithNibName: NSStringFromClass([self class])
                                                  bundle: nil];
    
    if (self)
    {
        _mazeManager = mazeManager;
        _textureManager = textureManager;
        _soundManager = soundManager;
        _styles = [MAStyles styles];
    
        _gameSessionUUID = nil;
        
        _world = nil;
        
        _movements = [[NSMutableArray alloc] init];
        
        _downloadMazeErrorAlertView = [[UIAlertView alloc] initWithTitle: @""
                                                                 message: @""
                                                                delegate: self
                                                       cancelButtonTitle: @"Cancel"
                                                       otherButtonTitles: @"Retry", nil];
        
        _saveMazeStartedErrorAlertView = [[UIAlertView alloc] initWithTitle: @""
                                                                    message: @""
                                                                   delegate: self
                                                          cancelButtonTitle: @"Cancel"
                                                          otherButtonTitles: @"Retry", nil];

        
        _saveFoundMazeExitErrorAlertView = [[UIAlertView alloc] initWithTitle: @""
                                                                      message: @""
                                                                     delegate: self
                                                            cancelButtonTitle: @"Cancel"
                                                            otherButtonTitles: @"Retry", nil];
        
        _saveFoundMazeExitNoRetryErrorAlertView = [[UIAlertView alloc] initWithTitle: @""
                                                                             message: @""
                                                                            delegate: nil
                                                                   cancelButtonTitle: @"OK"
                                                                   otherButtonTitles: nil];

        
        _saveMazeRatingErrorAlertView = [[UIAlertView alloc] initWithTitle: @""
                                                                   message: @""
                                                                  delegate: nil
                                                         cancelButtonTitle: @"OK"
                                                         otherButtonTitles: nil];
    }
    
    return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.titleLabel.backgroundColor = self.styles.gameScreen.titleBackgroundColor;
    self.titleLabel.font = self.styles.gameScreen.titleFont;
    self.titleLabel.textColor = self.styles.gameScreen.titleTextColor;
    
    self.mapBorderView.backgroundColor = self.styles.gameScreen.borderColor;
    
    self.messageBorderView.backgroundColor = self.styles.gameScreen.borderColor;
    
    self.messageTextView.backgroundColor = self.styles.gameScreen.messageBackgroundColor;
    self.messageTextView.font = self.styles.defaultFont;
    self.messageTextView.textColor = self.styles.gameScreen.messageTextColor;
    
    self.mazeBorderView.backgroundColor = self.styles.gameScreen.borderColor;

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
    
    self.activityIndicatorView.color = self.styles.activityIndicator.color;
}

- (void)viewWillAppear: (BOOL)animated
{    
    [super viewWillAppear: animated];

    self.gameSessionUUID = [NSUUID UUID];
    
    self.activityIndicatorView.hidden = NO;
    [self.activityIndicatorView startAnimating];
    
    [self startSetup];
}

- (void)viewWillDisappear: (BOOL)animated
{
    [super viewWillDisappear: animated];
    
    [self.movements removeAllObjects];
    
    if (self.instructionsPopoverController.popoverVisible == YES)
    {
        [self.instructionsPopoverController dismissPopoverAnimated: YES];
    }
}

- (void)viewDidDisappear: (BOOL)animated
{
    self.gameSessionUUID = nil;

    self.world = nil;
    self.mazeSummary = nil;
    
    [self.mapView clear];
    
    [super viewDidDisappear: animated];
}

#pragma mark - ADBannerViewDelegate

#pragma mark -

- (void)startSetup
{
    if (self.mazeSummary != nil && self.soundManager.count >= 1 && self.textureManager.count >= 1)
    {
        self.titleLabel.text = self.mazeSummary.name;
        
        [self downloadMaze];
    }
}

- (void)downloadMaze
{
    /*
    [self.webServices getMazeWithMazeId: self.mazeSummary.mazeId
                            sessionUUID: self.gameSessionUUID
                      completionHandler: ^(MAMaze *maze, NSUUID *gameSessionUUID, NSError *error)
    {
        if ([gameSessionUUID isEqual: self.gameSessionUUID] == YES)
        {
            if (error == nil)
            {
                self.maze = maze;
                [self saveMazeStarted];
            }
            else
            {
                NSString *requestErrorMessage = [MAUtilities requestErrorMessageWithRequestDescription: MARequestDescriptionDownloadMaze
                                                                                          reachability: self.reachability
                                                                                          userCanRetry: YES];
                self.downloadMazeErrorAlertView.message = requestErrorMessage;

                [self.downloadMazeErrorAlertView show];
            }
        }
    }];
    */
}

- (void)saveMazeStarted
{
    /*
    if (self.mazeSummary.userStarted == NO)
    {
        [self.webServices saveStartedWithUserName: self.webServices.loggedInUser.userName
                                           mazeId: self.maze.mazeId
                                      sessionUUID: self.gameSessionUUID
                                completionHandler: ^(NSUUID *gameSessionUUID, NSError *error)
         {
             if ([gameSessionUUID isEqual: self.gameSessionUUID] == YES)
             {
                 if (error == nil)
                 {
                     [self finishSetup];
                 }
                 else
                 {
                     NSString *requestErrorMessage = [MAUtilities requestErrorMessageWithRequestDescription: MARequestDescriptionSaveMazeProgress
                                                                                               reachability: self.reachability
                                                                                               userCanRetry: YES];
                     self.saveMazeStartedErrorAlertView.message = requestErrorMessage;

                     [self.saveMazeStartedErrorAlertView show];
                 }
             }
         }];
    }
    else
    {
        [self finishSetup];
    }
    */
}

- (void)finishSetup
{
    self.mapView.world = self.world;

    self.previousLocation = nil;

    self.isMoving = NO;

    self.activityIndicatorView.hidden = YES;
    [self.activityIndicatorView stopAnimating];
}

- (void)setupNewLocation: (MALocation *)newLocation
{
    self.previousLocation = self.currentLocation;
    
    self.currentLocation = newLocation;

    self.mapView.currentLocation = self.currentLocation;
    self.mapView.facingDirection = self.facingDirection;
    
    [self.mapView drawSurroundings];
}

- (void)handleTapFrom: (UITapGestureRecognizer *)recognizer 
{
    [self processMovements];
}

- (void)handleSwipeFrom: (UISwipeGestureRecognizer *)recognizer 
{
    [self processMovements];
}

- (void)processMovements
{
    if (self.isMoving == NO && self.movements.count > 0)
    {
        self.isMoving = YES;
        
        NSNumber *movement = [self.movements objectAtIndex: 0];
        [self.movements removeObjectAtIndex: 0];
        
        if ([movement integerValue] == MAMovementBackward || [movement integerValue] == MAMovementForward)
        {
            [self moveForwardBackward: (int)[movement integerValue]];
        }
        else if ([movement integerValue] == MAMovementTurnLeft || [movement integerValue] == MAMovementTurnRight)
        {
            [self turn: (int)[movement integerValue]];
        }
    }    
}

// MOVE FORWARD / BACKWARD

- (void)moveForwardBackward: (MAMovementType)movement
{
    float dglx = 0.0;
    float dglz = 0.0;

    self.dLocX = 0;
    self.dLocY = 0;

    if (movement == MAMovementForward)
    {
        if (self.facingDirection == MADirectionNorth)
        {
            self.dLocX = 0;
            self.dLocY = -1;
            
            dglx = 0.0;
            dglz = -MAWallWidth;
            
            self.movementDirection = MADirectionNorth;
        }
        else if (self.facingDirection == MADirectionEast)
        {
            self.dLocX = 1;
            self.dLocY = 0;
            
            dglx = MAWallWidth;
            dglz = 0.0;
            
            self.movementDirection = MADirectionEast;
        }
        else if (self.facingDirection == MADirectionSouth)
        {
            self.dLocX = 0;
            self.dLocY = 1;
            
            dglx = 0.0;
            dglz = MAWallWidth;
            
            self.movementDirection = MADirectionSouth;
        }
        else if (self.facingDirection == MADirectionWest)
        {
            self.dLocX = -1;
            self.dLocY = 0;
            
            dglx = -MAWallWidth;
            dglz = 0.0;
            
            self.movementDirection = MADirectionWest;
        }
    }
    else if (movement == MAMovementBackward)
    {
        if (self.facingDirection == MADirectionNorth)
        {
            self.dLocX = 0;
            self.dLocY = 1;
            
            dglx = 0.0;
            dglz = MAWallWidth;
            
            self.movementDirection = MADirectionSouth;
        }
        else if (self.facingDirection == MADirectionEast)
        {
            self.dLocX = -1;
            self.dLocY = 0;
            
            dglx = -MAWallWidth;
            dglz = 0.0;

            self.movementDirection = MADirectionWest;
        }
        else if (self.facingDirection == MADirectionSouth)
        {
            self.dLocX = 0;
            self.dLocY = -1;
            
            dglx = 0.0;
            dglz = -MAWallWidth;
            
            self.movementDirection = MADirectionNorth;
        }
        else if (self.facingDirection == MADirectionWest)
        {
            self.dLocX = 1;
            self.dLocY = 0;
            
            dglx = MAWallWidth;
            dglz = 0.0;
            
            self.movementDirection = MADirectionEast;
        }
    }
    
    // Animate Movement
    
    self.stepCount = 1;
    self.steps = 0;
    
    // steps must be even for bounce back
    if (self.steps % 2 == 1)
    {
        self.steps = self.steps + 1;
    }
    
    self.dglx_step = dglx / (float)self.steps;
    self.dglz_step = dglz / (float)self.steps;
    
    self.wallRemoved = NO;
    self.directionReversed = NO;

    self.movementStartDate = [[NSDate alloc] init];
}

- (void)moveStep: (NSTimer *)timer
{
    if (self.stepCount < self.steps)
    {
        self.stepCount = self.stepCount + 1;
    }
    else
    {
        [self moveEnd];
    }
}

- (void)moveEnd
{
    self.previousLocation = self.currentLocation;

    self.currentLocation = [self.world locationWithRow: self.currentLocation.row + self.dLocY
                                                column: self.currentLocation.column + self.dLocX];
    
    self.mapView.currentLocation = self.currentLocation;
    self.mapView.facingDirection = self.facingDirection;
    
    [self.mapView drawSurroundings];
    
    [self locationChanged];

    self.isMoving = NO;
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

        switch (self.facingDirection)
        {
            case MADirectionNorth:
                self.facingDirection = MADirectionWest;
                break;
                    
            case MADirectionWest:
                self.facingDirection = MADirectionSouth;
                break;
                
            case MADirectionSouth:
                self.facingDirection = MADirectionEast;
                break;
                
            case MADirectionEast:
                self.facingDirection = MADirectionNorth;
                break;
                
            default:
                [MAUtilities logWithClass: [self class]
                                  message: @"facingDirection set to an illegal value."
                               parameters: @{@"self.facingDirection" : @(self.facingDirection)}];
                break;
        }
    }
    else if (movement == MAMovementTurnRight)
    {
        dTheta = 90.0;

        switch (self.facingDirection)
        {
            case MADirectionNorth:
                self.facingDirection = MADirectionEast;
                break;
                
            case MADirectionEast:
                self.facingDirection = MADirectionSouth;
                break;
                
            case MADirectionSouth:
                self.facingDirection = MADirectionWest;
                break;
                
            case MADirectionWest:
                self.facingDirection = MADirectionNorth;
                break;
                
            default:
                [MAUtilities logWithClass: [self class]
                                  message: @"facingDirection set to an illegal value."
                               parameters: @{@"self.facingDirection" : @(self.facingDirection)}];
                break;
        }
    }
    
    self.stepCount = 1;
    self.steps = 0;
    
    self.dTheta_step = dTheta / (float)self.steps;

    self.movementStartDate = [[NSDate alloc] init];
    
    [self turnStep: nil];
}

- (void)turnStep: (NSTimer *)timer
{
    if (self.stepCount < self.steps)
    {
        self.stepCount = self.stepCount + 1;
    }
    else
    {
        [self turnEnd];
    }    
}

- (void)turnEnd
{
    self.mapView.currentLocation = self.currentLocation;
    self.mapView.facingDirection = self.facingDirection;
    
    [self.mapView drawSurroundings];
    
    self.isMoving = NO;
    [self processMovements];
}

- (void)locationChanged
{
}

- (void)saveFoundMazeExit
{
    /*
    [self.webServices saveFoundExitWithUserName: self.webServices.loggedInUser.userName
                                         mazeId: self.maze.mazeId
                                       mazeName: self.maze.name
                                    sessionUUID: self.gameSessionUUID
                              completionHandler: ^(NSString *mazeName, NSUUID *gameSessionUUID, NSError *error)
    {
        if ([gameSessionUUID isEqual: self.gameSessionUUID] == YES)
        {
            if (error == nil)
            {
                [self showEndAlert];
            }
            else
            {
                NSString *requestErrorMessage = [MAUtilities requestErrorMessageWithRequestDescription: MARequestDescriptionSaveMazeProgress
                                                                                          reachability: self.reachability
                                                                                          userCanRetry: YES];
                self.saveFoundMazeExitErrorAlertView.message = requestErrorMessage;

                [self.saveFoundMazeExitErrorAlertView show];
            }
        }
        else
        {
            if (error == nil)
            {
                ;
            }
            else
            {
                NSString *requestErrorMessage = [MAUtilities requestErrorMessageWithRequestDescription: MARequestDescriptionSaveMazeProgressNoRetry
                                                                                          reachability: self.reachability
                                                                                          userCanRetry: NO];
                
                requestErrorMessage = [NSString stringWithFormat: requestErrorMessage, mazeName];
                self.saveFoundMazeExitNoRetryErrorAlertView.message = requestErrorMessage;

                [self.saveFoundMazeExitNoRetryErrorAlertView show];
            }
        }
    }];
    */
}

- (void)showEndAlert
{
    MAInfoPopupView *infoPopupView = [MAInfoPopupView infoPopupViewWithParentView: self.view
                                                                          message: @""
                                                                cancelButtonTitle: @"OK"];

    [infoPopupView showWithDismissedHandler: ^
    {
        if (self.mazeSummary.rating == -1.0)
        {
            
        }
        else
        {
            [self goBack];
        }
    }];
}

- (void)ratingView: (MARatingView *)ratingView ratingChanged: (float)newRating
{
    /*
    if (newRating != self.mazeSummary.rating)
    {
        [self.webServices saveMazeRatingWithUserName: self.webServices.loggedInUser.userName
                                              mazeId: self.maze.mazeId
                                            mazeName: self.maze.name
                                              rating: newRating
                                   completionHandler: ^(NSString *mazeName, NSError *error)
        {
            if (error == nil)
            {
                ;
            }
            else
            {
                NSString *requestErrorMessage = [MAUtilities requestErrorMessageWithRequestDescription: MARequestDescriptionSaveMazeRating
                                                                                          reachability: self.reachability
                                                                                          userCanRetry: NO];
                
                requestErrorMessage = [NSString stringWithFormat: requestErrorMessage, mazeName];
                self.saveMazeRatingErrorAlertView.message = requestErrorMessage;
                
                [self.saveMazeRatingErrorAlertView show];
            }
        }];
    }
    */
}

#pragma mark - UIAlertViewDelegate

- (void)alertView: (UIAlertView *)alertView didDismissWithButtonIndex: (NSInteger)buttonIndex
{
    if (alertView == self.downloadMazeErrorAlertView)
    {
        switch (buttonIndex)
        {
            case 0:
                [self goBack];
                break;
            case 1:
                [self downloadMaze];
            default:
                break;
        }
    }
    else if (alertView == self.saveMazeStartedErrorAlertView)
    {
        switch (buttonIndex)
        {
            case 0:
                [self goBack];
                break;
            case 1:
                [self saveMazeStarted];
            default:
                break;
        }
    }
    else if (alertView == self.saveFoundMazeExitErrorAlertView)
    {
        switch (buttonIndex)
        {
            case 0:
                [self goBack];
                break;
            case 1:
                [self saveFoundMazeExit];
            default:
                break;
        }
    }
    else if (alertView == self.saveFoundMazeExitNoRetryErrorAlertView)
    {
        ;
    }
    else
    {
        [MAUtilities logWithClass: [self class]
                          message: @"alertView not handled."
                       parameters: @{@"alertView" : alertView}];
    }
}

// Back Button

- (IBAction)backButtonTouchDown: (id)sender
{
    self.backImageView.image = [UIImage imageNamed: @"BackButtonOrangeHighlighted.png"];
}

- (IBAction)backButtonTouchUpInside: (id)sender
{
    self.backImageView.image = [UIImage imageNamed: @"BackButtonBlueUnhighlighted.png"];
    
    [self goBack];
}

- (void)goBack
{
    self.activityIndicatorView.hidden = YES;
    [self.activityIndicatorView stopAnimating];
}

// How To Play Button

- (IBAction)instructionsButtonTouchDown: (id)sender
{
    self.instructionsImageView.image = [UIImage imageNamed: @"InstructionsButtonOrangeHighlighted.png"];
}

- (IBAction)instructionsButtonTouchUpInside: (id)sender
{
    self.instructionsImageView.image = [UIImage imageNamed: @"InstructionsButtonBlueUnhighlighted.png"];
    
    [self displayInstructions];
}

- (void)displayInstructions
{
    MAInstructionsViewController *viewController = [[MAInstructionsViewController alloc] initWithNibName: @"MAInstructionsViewController" bundle: nil];

    self.instructionsPopoverController = [[UIPopoverController alloc] initWithContentViewController: viewController];

    self.instructionsPopoverController.popoverContentSize = viewController.view.frame.size;

    [self.instructionsPopoverController presentPopoverFromRect: self.instructionsButton.frame
                                                        inView: self.view
                                      permittedArrowDirections: UIPopoverArrowDirectionAny animated: YES];
}

@end




















