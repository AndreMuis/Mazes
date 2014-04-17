//
//  MADesignViewController.h
//  Mazes
//
//  Created by Andre Muis on 4/30/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MAConstants.h"
#import "MALocation.h"

@class MACreateViewController;
@class MAEventManager;
@class MAEvent;
@class MAFloorPlanView;
@class MAMainViewController;
@class MAMazeManager;
@class MAMaze;
@class MASettings;
@class MASoundManager;
@class MATextureManager;
@class MATopMazesViewController;
@class MAWebServices;

@interface MADesignViewController : UIViewController <
    UIGestureRecognizerDelegate,
    UITableViewDelegate,
    UITextViewDelegate,
    UITextFieldDelegate,
    UIAlertViewDelegate,
    UIPopoverControllerDelegate>

@property (readwrite, strong, nonatomic) MAMaze *maze;

@property (readwrite, strong, nonatomic) MAMainViewController *mainViewController;
@property (readwrite, strong, nonatomic) MACreateViewController *createViewController;
@property (readwrite, strong, nonatomic) MATopMazesViewController *topMazesViewController;

@property (weak, nonatomic) IBOutlet UIButton *mainButton;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;
@property (weak, nonatomic) IBOutlet UIButton *wallButton;
@property (weak, nonatomic) IBOutlet UIButton *graphicsButton;
@property (weak, nonatomic) IBOutlet UIButton *audioButton;

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIView *mainView;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UISwitch *publicSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *tutorialSwitch;

@property (weak, nonatomic) IBOutlet UIScrollView *locationScrollView;
@property (weak, nonatomic) IBOutlet UITableView *locationTypeTableView;
@property (weak, nonatomic) IBOutlet UITableView *directionTableView;
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;
@property (weak, nonatomic) IBOutlet UILabel *messageDisplaysLabel;
@property (weak, nonatomic) IBOutlet UIButton *floorTextureButton;
@property (weak, nonatomic) IBOutlet UIButton *ceilingTextureButton;

@property (weak, nonatomic) IBOutlet UIView *wallView;
@property (weak, nonatomic) IBOutlet UITableView *wallTypeTableView;
@property (weak, nonatomic) IBOutlet UIButton *wallTextureButton;

@property (weak, nonatomic) IBOutlet UIView *graphicsView;
@property (weak, nonatomic) IBOutlet UIButton *defaultWallTextureButton;
@property (weak, nonatomic) IBOutlet UIButton *defaultFloorTextureButton;
@property (weak, nonatomic) IBOutlet UIButton *defaultCeilingTextureButton;

@property (weak, nonatomic) IBOutlet UIView *audioView;
@property (weak, nonatomic) IBOutlet UITableView *backgroundSoundTableView;

@property (weak, nonatomic) IBOutlet UIView *buttonsView;

@property (weak, nonatomic) IBOutlet UILabel *message1Label;
@property (weak, nonatomic) IBOutlet UILabel *message2Label;

@property (weak, nonatomic) IBOutlet MAFloorPlanView *floorPlanView;

- (id)initWithWebServices: (MAWebServices *)webServices
             eventManager: (MAEventManager *)eventManager
              mazeManager: (MAMazeManager *)mazeManager
             soundManager: (MASoundManager *)soundManager
           textureManager: (MATextureManager *)textureManager;

- (IBAction)mainButtonTouchDown: (id)sender;
- (IBAction)locationButtonTouchDown: (id)sender;
- (IBAction)wallButtonTouchDown: (id)sender;
- (IBAction)graphicsButtonTouchDown: (id)sender;
- (IBAction)audioButtonTouchDown: (id)sender;

- (IBAction)saveButtonTouchDown: (id)sender;
- (IBAction)mazesButtonTouchDown: (id)sender;
- (IBAction)resetButtonTouchDown: (id)sender;

- (IBAction)switchPublicValueChanged: (id)sender;

- (IBAction)floorTextureButtonTouchDown: (id)sender;
- (IBAction)floorTextureResetButtonTouchDown: (id)sender;

- (IBAction)ceilingTextureButtonTouchDown: (id)sender;
- (IBAction)ceilingTextureResetButtonTouchDown: (id)sender;

- (IBAction)wallTextureButtonTouchDown: (id)sender;
- (IBAction)wallTextureResetButtonTouchDown: (id)sender;

- (IBAction)defaultWallTextureButtonTouchDown: (id)sender;
- (IBAction)defaultFloorTextureButtonTouchDown: (id)sender;
- (IBAction)defaultCeilingTextureButtonTouchDown: (id)sender;

- (IBAction)swtichTutorialValueChanged: (id)sender;

@end











