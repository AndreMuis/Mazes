//
//  EditViewController.h
//  Mazes
//
//  Created by Andre Muis on 4/30/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Constants.h"
#import "Location.h"

@class GridView;
@class Maze;

@interface EditViewController : UIViewController <UIGestureRecognizerDelegate, UITableViewDelegate, UITextViewDelegate, UITextFieldDelegate, UIAlertViewDelegate, UIPopoverControllerDelegate>
{
	int selectedTabIndex;
	
	NSArray *locationActions;
	NSArray *locationActionLabels;

	NSArray *directionThetas;
	NSArray	*directionLabels;
	
	NSArray *wallTypes;
	NSArray	*wallTypeLabels;
	
	UIPopoverController *popoverControllerTextures;
	
	Location *currLoc, *prevLoc;
	
	Location *currWallLoc;
	MADirectionType currWallDir;
	
	NSMutableArray *locationsVisited;
}

@property (strong, nonatomic) Maze *maze;

@property (weak, nonatomic) IBOutlet UIButton *btnMain;
@property (weak, nonatomic) IBOutlet UIButton *btnLocation;
@property (weak, nonatomic) IBOutlet UIButton *btnWall;
@property (weak, nonatomic) IBOutlet UIButton *btnGraphics;
@property (weak, nonatomic) IBOutlet UIButton *btnAudio;

@property (weak, nonatomic) IBOutlet UIView *viewPlaceHolder;
@property (weak, nonatomic) IBOutlet UIView *viewMain;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewLocation;
@property (weak, nonatomic) IBOutlet UIView *viewWall;
@property (weak, nonatomic) IBOutlet UIView *viewGraphics;
@property (weak, nonatomic) IBOutlet UIView *viewAudio;

@property (weak, nonatomic) IBOutlet UITextField *textFieldName;
@property (weak, nonatomic) IBOutlet UISwitch *switchPublic;
@property (weak, nonatomic) IBOutlet UISwitch *switchTutorial;

@property (weak, nonatomic) IBOutlet UITableView *locationTypeTableView;
@property (weak, nonatomic) IBOutlet UITableView *directionTableView;

@property (weak, nonatomic) IBOutlet UITextView *textViewMessage;
@property (weak, nonatomic) IBOutlet UILabel *messageDisplaysLabel;

@property (weak, nonatomic) IBOutlet UITableView *wallTypeTableView;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewFloor;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewCeiling;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewWall;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewWallDefault;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewFloorDefault;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewCeilingDefault;

@property (weak, nonatomic) IBOutlet UITableView *tableViewBackgroundSound;

@property (weak, nonatomic) IBOutlet UIView *viewButtons;

@property (weak, nonatomic) IBOutlet UILabel *lblMessage1;
@property (weak, nonatomic) IBOutlet UILabel *lblMessage2;

@property (weak, nonatomic) IBOutlet GridView *gridView;

+ (EditViewController *)shared;

- (void)initTexturesPopover;

- (void)animateScrollView;

- (void)setup;

- (IBAction)btnMainTouchDown: (id)sender;
- (IBAction)btnLocationTouchDown: (id)sender;
- (IBAction)btnWallTochhDown: (id)sender;
- (IBAction)btnGraphicsTouchDown: (id)sender;
- (IBAction)btnAudioTouchDown: (id)sender;

- (void)setupTabBarWithSelectedIndex: (int)selectedIndex;

- (void)handleTapFrom: (UITapGestureRecognizer *)recognizer;
- (void)handleLongPressFrom: (UILongPressGestureRecognizer *)recognizer;

- (void)locationChangedToCoord: (CGPoint)coord;
- (BOOL)setNextLocationAsTeleportation;

- (void)resetCurrentLocation;

- (int)getNextTeleportId;

- (void)setupLocationActionTableViewLocationAction: (MALocationActionType)locationAction theta: (int)theta;
- (void)setupDirectionTableViewLocationAction: (MALocationActionType)locationAction theta: (int)theta;
- (void)setupMessageDisplaysLabelLocationAction: (MALocationActionType)locationAction;

- (void)setupWallTypeTableViewWallType: (int)wallType;

- (void)clearAccessoriesInTableView: (UITableView *)tableView;

- (BOOL)wallPassesTeleportationSurroundedCheck;
- (void)teleportationSurroundedAlert;

- (IBAction)switchPublicValueChanged: (id)sender;
- (BOOL)pathExists;
- (void)findExitLocation: (Location *)location; 

- (void)setupLocationPanel;

- (IBAction)btnFloorTouchDown;
- (IBAction)btnCeilingTouchDown;

- (void)setupWallPanel;

- (IBAction)btnWallTouchDown;

- (void)setupGraphicsPanel;

- (IBAction)btnWallDefaultTouchDown;
- (IBAction)btnFloorDefaultTouchDown;
- (IBAction)btnCeilingDefaultTouchDown;

- (IBAction)save: (id)sender;

- (void)createMaze;
- (void)createMazeResponse;

- (void)updateMaze;
- (void)updateMazeResponse;

- (void)setLocations;
- (void)setLocationsResponse;

- (void)setLocations;

- (BOOL)validate;

- (IBAction)delete: (id)sender;

- (void)deleteMaze;
- (void)deleteMazeResponse;

- (void)setupCreateView;

- (IBAction)btnMazesTouchDown: (id)sender;

- (void)stopBackgroundSound;

- (IBAction)swtichTutorialValueChanged: (id)sender;

- (void)showTutorialHelpForTopic: (NSString *)topic;

- (void)setTableView: (UITableView *)tableView disabled: (BOOL)disabled;

@end

