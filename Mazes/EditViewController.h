//
//  EditViewController.h
//  iPad_Mazes
//
//  Created by Andre Muis on 4/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Communication.h"
#import "Maze.h"
#import "Textures.h"
#import "Sounds.h"
#import "TopListsViewController.h"
#import "GridView.h"
#import "TexturesViewController.h"

@interface EditViewController : UIViewController <UIGestureRecognizerDelegate, UITableViewDelegate, UITextViewDelegate, UITextFieldDelegate, UIAlertViewDelegate, UIPopoverControllerDelegate>
{
	Communication *comm;

	int selectedTabIndex;
	
	UIButton *btnMain;
	UIButton *btnLocation;
	UIButton *btnWall;
	UIButton *btnGraphics;
	UIButton *btnAudio;
	
	UIView *viewPlaceHolder;
	UIView *viewMain;
	UIScrollView *scrollViewLocation;
	UIView *viewWall;
	UIView *viewGraphics;
	UIView *viewAudio;
	
	UITextField *textFieldName;
	UISwitch *switchPublic;
	UISwitch *switchTutorial;
	
	NSArray *locationTypes;
	NSArray *locationTypeLabels;

	NSArray *directionThetas;
	NSArray	*directionLabels;
	
	NSArray *wallTypes;
	NSArray	*wallTypeLabels;

	UITableView *LocationTypeTableView;
	UITableView *DirectionTableView;

	UITextView *textViewMessage;
	UILabel *MessageDisplaysLabel;

	UITableView *WallTypeTableView;

	UIImageView *imageViewFloor;
	UIImageView *imageViewCeiling;
	
	UIImageView *imageViewWall;
	
	UIImageView *imageViewWallDefault;
	UIImageView *imageViewFloorDefault;
	UIImageView *imageViewCeilingDefault;

	UITableView	*tableViewBackgroundSound;
	
	UIPopoverController *popoverControllerTextures;
	
	UIView *viewButtons;
	
	UILabel *lblMessage1, *lblMessage2;
	
    GridView *gridView;
	
	Location *currLoc, *prevLoc;
	
	Location *currWallLoc;
	int currWallDir;
	
	NSMutableArray *locationsVisited;
}

@property (nonatomic, retain) IBOutlet UIButton *btnMain;
@property (nonatomic, retain) IBOutlet UIButton *btnLocation;
@property (nonatomic, retain) IBOutlet UIButton *btnWall;
@property (nonatomic, retain) IBOutlet UIButton *btnGraphics;
@property (nonatomic, retain) IBOutlet UIButton *btnAudio;

@property (nonatomic, retain) IBOutlet UIView *viewPlaceHolder;
@property (nonatomic, retain) IBOutlet UIView *viewMain;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollViewLocation;
@property (nonatomic, retain) IBOutlet UIView *viewWall;
@property (nonatomic, retain) IBOutlet UIView *viewGraphics;
@property (nonatomic, retain) IBOutlet UIView *viewAudio;

@property (nonatomic, retain) IBOutlet UITextField *textFieldName;
@property (nonatomic, retain) IBOutlet UISwitch *switchPublic;
@property (nonatomic, retain) IBOutlet UISwitch *switchTutorial;

@property (nonatomic, retain) IBOutlet UITableView *LocationTypeTableView;
@property (nonatomic, retain) IBOutlet UITableView *DirectionTableView;

@property (nonatomic, retain) IBOutlet UITextView *textViewMessage;
@property (nonatomic, retain) IBOutlet UILabel *MessageDisplaysLabel;

@property (nonatomic, retain) IBOutlet UITableView *WallTypeTableView;

@property (nonatomic, retain) IBOutlet UIImageView *imageViewFloor;
@property (nonatomic, retain) IBOutlet UIImageView *imageViewCeiling;

@property (nonatomic, retain) IBOutlet UIImageView *imageViewWall;

@property (nonatomic, retain) IBOutlet UIImageView *imageViewWallDefault;
@property (nonatomic, retain) IBOutlet UIImageView *imageViewFloorDefault;
@property (nonatomic, retain) IBOutlet UIImageView *imageViewCeilingDefault;

@property (nonatomic, retain) IBOutlet UITableView *tableViewBackgroundSound;

@property (nonatomic, retain) IBOutlet UIView *viewButtons;

@property (nonatomic, retain) IBOutlet UILabel *lblMessage1;
@property (nonatomic, retain) IBOutlet UILabel *lblMessage2;

@property (nonatomic, retain) IBOutlet GridView *gridView;

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

- (void)ResetCurrentLocation;

- (int)GetNextTeleportId;

- (void)SetupLocationTypeTableViewLocationType: (int)locationType Theta: (int)theta;
- (void)SetupDirectionTableViewLocationType: (int)locationType Theta: (int)theta;
- (void)SetupMessageDisplaysLabelLocationType: (int)locationType;

- (void)SetupWallTypeTableViewWallType: (int)wallType;

- (void)clearAccessoriesInTableView: (UITableView *)tableView;

- (BOOL)WallPassesTeleportationSurroundedCheck;
- (void)TeleportationSurroundedAlert;

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

- (IBAction)Save: (id)sender;

- (void)createMaze;
- (void)createMazeResponse;

- (void)updateMaze;
- (void)updateMazeResponse;

- (void)setLocations;
- (void)setLocationsResponse;

- (void)setLocations;

- (BOOL)validate;

- (IBAction)Delete: (id)sender;

- (void)deleteMaze;
- (void)deleteMazeResponse;

- (void)setupCreateView;

- (IBAction)btnMazesTouchDown: (id)sender;

- (void)stopBackgroundSound;

- (IBAction)swtichTutorialValueChanged: (id)sender;

- (void)showTutorialHelpForTopic: (NSString *)topic;

- (void)setTableView: (UITableView *)tableView Disabled: (BOOL)disabled;

@end

