//
//  EditViewController.m
//  Mazes
//
//  Created by Andre Muis on 4/30/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import "EditViewController.h"

#import "CreateViewController.h"
#import "GridView.h"

#import "MAEvents.h"
#import "MAEvent.h"
#import "MALocation.h"
#import "MAMaze.h"
#import "MASoundManager.h"
#import "MASound.h"
#import "MATextureManager.h"
#import "MATexture.h"
#import "MATopMazesViewController.h"
#import "MAUtilities.h"

#import "Settings.h"
#import "TexturesViewController.h"

@interface EditViewController ()

@property (strong, nonatomic) NSOperationQueue *operationQueue;
    
@property (strong, nonatomic) MAEvent *saveMazeEvent;
@property (strong, nonatomic) MAEvent *deleteMazeEvent;
    
@property (assign, nonatomic) int selectedTabIndex;
	
@property (strong, nonatomic) NSArray *locationActions;
@property (strong, nonatomic) NSArray *locationActionLabels;
    
@property (strong, nonatomic) NSArray *directionThetas;
@property (strong, nonatomic) NSArray *directionLabels;
	
@property (strong, nonatomic) NSArray *wallTypes;
@property (strong, nonatomic) NSArray *wallTypeLabels;
	
@property (strong, nonatomic) UIPopoverController *popoverControllerTextures;
	
@property (strong, nonatomic) MALocation *currentLocation;
@property (strong, nonatomic) MALocation *previousLocation;
	
@property (strong, nonatomic) MALocation *currentWallLocation;
@property (assign, nonatomic) MADirectionType currentWallDirection;
	
@property (strong, nonatomic) NSMutableArray *locationsVisited;

@end

@implementation EditViewController

+ (EditViewController *)shared
{
	static EditViewController *instance = nil;
	
	@synchronized(self)
	{
		if (instance == nil)
		{
			instance = [[EditViewController alloc] initWithNibName: @"EditViewController" bundle: nil];
		}
	}
	
	return instance;
}

- (id)initWithNibName: (NSString *)nibNameOrNil bundle: (NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName: nibNameOrNil bundle: nibBundleOrNil];
    
    if (self)
    {
        _operationQueue = [[NSOperationQueue alloc] init];
        
        _saveMazeEvent = [[MAEvent alloc] initWithTarget: self
                                                  action: @selector(saveMaze)
                                            intervalSecs: [MAConstants
                                                           shared].serverRetryDelaySecs
                                                 repeats: NO];

        _deleteMazeEvent = [[MAEvent alloc] initWithTarget: self
                                                    action: @selector(deleteMaze)
                                              intervalSecs: [MAConstants shared].serverRetryDelaySecs
                                                   repeats: NO];
        
        _maze = nil;
    }
    
    return self;
}

- (void)viewDidLoad 
{
    [super viewDidLoad];

	self.view.frame = [MATopMazesViewController shared].view.frame;
    
	self.mainView.frame = CGRectMake(0.0, 0.0, self.contentView.frame.size.width, self.contentView.frame.size.height);
	self.mainView.backgroundColor = [Styles shared].editView.panelBackgroundColor;
	[self.contentView addSubview: self.mainView];
    
	self.locationScrollView.contentSize = self.locationScrollView.frame.size;
	self.locationScrollView.frame = CGRectMake(0.0, 0.0, self.contentView.frame.size.width, self.contentView.frame.size.height);
	self.locationScrollView.backgroundColor = [Styles shared].editView.panelBackgroundColor;
	[self.contentView addSubview: self.locationScrollView];
	
	self.wallView.frame = CGRectMake(0.0, 0.0, self.contentView.frame.size.width, self.contentView.frame.size.height);
	self.wallView.backgroundColor = [Styles shared].editView.panelBackgroundColor;
	[self.contentView addSubview: self.wallView];
	
	self.graphicsView.frame = CGRectMake(0.0, 0.0, self.contentView.frame.size.width, self.contentView.frame.size.height);
	self.graphicsView.backgroundColor = [Styles shared].editView.panelBackgroundColor;
	[self.contentView addSubview: self.graphicsView];
	
	self.audioView.frame = CGRectMake(0.0, 0.0, self.contentView.frame.size.width, self.contentView.frame.size.height);
	self.audioView.backgroundColor = [Styles shared].editView.panelBackgroundColor;
	[self.contentView addSubview: self.audioView];

	self.locationActions = @[@(MALocationActionDoNothing), @(MALocationActionStart), @(MALocationActionEnd), @(MALocationActionStartOver), @(MALocationActionTeleport)];
    self.locationActionLabels = @[@"Do Nothing", @"Start", @"End", @"Start Over", @"Teleportation"];
	
	self.directionThetas = @[@(0), @(90), @(180), @(270)];
    self.directionLabels = @[@"North", @"East", @"South", @"West"];
	
	self.wallTypes = @[@(MAWallNone), @(MAWallSolid), @(MAWallInvisible), @(MAWallFake)];
    self.wallTypeLabels = @[@"No Wall", @"Solid", @"Invisible", @"Fake"];
	
	// set table row heights
	[self.locationTypeTableView setRowHeight: (self.locationTypeTableView.frame.size.height - self.locationTypeTableView.sectionHeaderHeight) / self.locationActions.count];
	
	[self.directionTableView setRowHeight: (self.directionTableView.frame.size.height - self.directionTableView.sectionHeaderHeight) / self.directionThetas.count];

	[self.wallTypeTableView setRowHeight: (self.wallTypeTableView.frame.size.height - self.wallTypeTableView.sectionHeaderHeight) / self.wallTypes.count];
	
	[self.backgroundSoundTableView setRowHeight: (self.backgroundSoundTableView.frame.size.height - self.backgroundSoundTableView.sectionHeaderHeight) / [Styles shared].editView.tableViewBackgroundSoundRows];

	self.messageDisplaysLabel.backgroundColor = [Styles shared].editView.panelBackgroundColor;
	
	[self initTexturesPopover];
	
	self.buttonsView.backgroundColor = [Styles shared].editView.viewButtonsBackgroundColor;
	
	self.message1Label.backgroundColor = [Styles shared].editView.messageBackgroundColor;
	self.message1Label.textColor = [Styles shared].editView.messageTextColor;
	
	self.message2Label.backgroundColor = [Styles shared].editView.messageBackgroundColor;
	self.message2Label.textColor = [Styles shared].editView.messageTextColor;
	
    self.gridView.maze = [EditViewController shared].maze;
    
	UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(handleTapFrom:)];
	tapRecognizer.cancelsTouchesInView = NO;
	tapRecognizer.numberOfTapsRequired = 1;
	tapRecognizer.numberOfTouchesRequired = 1;   
	[self.view addGestureRecognizer: tapRecognizer];
	
	UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget: self action: @selector(handleLongPressFrom:)];
	//longPressRecognizer.numberOfTapsRequired = 1;   // documentation says default is 1 which doesn't do anything, value is actually 0
	longPressRecognizer.cancelsTouchesInView = NO;
	longPressRecognizer.numberOfTouchesRequired = 1;   
	longPressRecognizer.minimumPressDuration = 0.4;
	[self.view addGestureRecognizer: longPressRecognizer];

	self.locationsVisited = [[NSMutableArray alloc] init];
	
	[self setup];
}

- (void)initTexturesPopover
{
	TexturesViewController *texturesViewController = [[TexturesViewController alloc] init];
	
	self.popoverControllerTextures = [[UIPopoverController alloc] initWithContentViewController: texturesViewController];
	
	self.popoverControllerTextures.popoverContentSize = CGSizeMake([Styles shared].editView.popoverTexturesWidth, [Styles shared].editView.popoverTexturesHeight);
    self.popoverControllerTextures.delegate = self;
}

- (void)viewWillAppear: (BOOL)animated
{
	[super viewWillAppear: animated];
	
	[self.gridView setNeedsDisplay];
}

- (void)setup
{
	[self setupTabBarWithSelectedIndex: 1];
	
	[self setTableView: self.locationTypeTableView disabled: YES];
	[self clearAccessoriesInTableView: self.locationTypeTableView];
	
	[self setTableView: self.directionTableView disabled: YES];
	[self clearAccessoriesInTableView: self.directionTableView];
		
	[self setTableView: self.wallTypeTableView disabled: YES];
	[self clearAccessoriesInTableView: self.wallTypeTableView];
	
	[self.backgroundSoundTableView reloadData];
	
	self.messageTextView.editable = NO;
	self.messageTextView.text = @"";
	
	self.messageDisplaysLabel.text = @"";
	
	self.nameTextField.text = self.maze.name;
	
	self.publicSwitch.on = self.maze.public;
		
	self.tutorialSwitch.on = [Settings shared].useTutorial;
	
	self.currentLocation = nil;
	self.previousLocation = nil;
	
    self.currentWallLocation = nil;
	self.gridView.currentWallLocation = self.currentWallLocation;
	
    self.currentWallDirection = MADirectionUnknown;
	self.gridView.currentWallDirection = self.currentWallDirection;
	
	[self setupLocationPanel];
	[self setupWallPanel];
	[self setupGraphicsPanel];
	
	[self.locationsVisited removeAllObjects];
	
	[self showTutorialHelpForTopic: @"Start"];	
}

//
//   TAB BAR
//

- (IBAction)mainButtonTouchDown: (id)sender
{
	[self setupTabBarWithSelectedIndex: 1];
}

- (IBAction)locationButtonTouchDown: (id)sender
{
	[self setupTabBarWithSelectedIndex: 2];
}

- (IBAction)wallButtonTochhDown: (id)sender
{
	[self setupTabBarWithSelectedIndex: 3];
}

- (IBAction)graphicsButtonTouchDown: (id)sender
{
	[self setupTabBarWithSelectedIndex: 4];
}

- (IBAction)audioButtonTouchDown: (id)sender
{
	[self setupTabBarWithSelectedIndex: 5];
}

- (void)setupTabBarWithSelectedIndex: (int)selectedIndex
{
	self.mainButton.backgroundColor = [Styles shared].editView.tabDarkColor;
	self.locationButton.backgroundColor = [Styles shared].editView.tabDarkColor;
	self.wallButton.backgroundColor = [Styles shared].editView.tabDarkColor;
	self.graphicsButton.backgroundColor = [Styles shared].editView.tabDarkColor;
	self.audioButton.backgroundColor = [Styles shared].editView.tabDarkColor;

	if (selectedIndex == 1)
	{
		self.mainButton.backgroundColor = [Styles shared].editView.panelBackgroundColor;
		
		[self.contentView bringSubviewToFront: self.mainView];
	}
	else if (selectedIndex == 2)
	{
		self.locationButton.backgroundColor = [Styles shared].editView.panelBackgroundColor;
		
		[self.contentView bringSubviewToFront: self.locationScrollView];
	}
	else if (selectedIndex == 3)
	{
		self.wallButton.backgroundColor = [Styles shared].editView.panelBackgroundColor;
		
		[self.contentView bringSubviewToFront: self.wallView];
	}
	else if (selectedIndex == 4)
	{
		self.graphicsButton.backgroundColor = [Styles shared].editView.panelBackgroundColor;
		
		[self.contentView bringSubviewToFront: self.graphicsView];
	}
	else if (selectedIndex == 5)
	{
		self.audioButton.backgroundColor = [Styles shared].editView.panelBackgroundColor;
		
		[self.contentView bringSubviewToFront: self.audioView];
	}
    else
    {
        [MAUtilities logWithClass: [self class] format: @"Selected index set to an illegal value: %d", selectedIndex];
    }
}

//
//   USER TAPS SCREEN
//

- (void)handleTapFrom: (UITapGestureRecognizer *)recognizer 
{
	CGPoint touchPoint = [recognizer locationInView: self.gridView];

	MAMazeObjectType segType = 0;
	MALocation *location = [self.maze gridWallLocationWithSegType: &segType
                                                       touchPoint: touchPoint
                                                             rows: self.maze.rows
                                                          columns: self.maze.columns];

	if (location != nil)
	{
		self.currentWallLocation = location;
		self.gridView.currentWallLocation = self.currentWallLocation;
		
		[self setupTabBarWithSelectedIndex: 3];
		
		if (segType == MAMazeObjectWallNorth)
        {
			self.currentWallDirection = MADirectionNorth;
        }
		else if (segType == MAMazeObjectWallWest)
        {
			self.currentWallDirection = MADirectionWest;
        }
	
		self.gridView.currentWallDirection = self.currentWallDirection;
		
		if ([self.maze isInnerWallWithLocation: location
                                          rows: self.maze.rows
                                       columns: self.maze.columns
                                       wallDir: self.currentWallDirection] == YES)
		{
			[self setTableView: self.wallTypeTableView disabled:	NO];
			
			MAWallType oldWallType = [self.maze wallTypeWithLocationX: self.currentWallLocation.xx
                                                            locationY: self.currentWallLocation.yy
                                                            direction: self.currentWallDirection];
			
			MAWallType newWallType = 0;
			if (oldWallType == MAWallNone)
            {
				newWallType = MAWallSolid;
            }
			else
            {
				newWallType = MAWallNone;
            }
            
			[self.maze setWallTypeWithLocationX: self.currentWallLocation.xx
                                      locationY: self.currentWallLocation.yy
                                      direction: self.currentWallDirection
                                           type: newWallType];
			
			if ([self wallPassesTeleportationSurroundedCheck] == NO)
			{
				newWallType = oldWallType;
				
				[self.maze setWallTypeWithLocationX: self.currentWallLocation.xx
                                          locationY: self.currentWallLocation.yy
                                          direction: self.currentWallDirection
                                               type: newWallType];
				
				[self teleportationSurroundedAlert];
			}
			
			[self setupWallTypeTableViewWallType: newWallType];
			
			[self showTutorialHelpForTopic: @"WallTypes"];
		}
		else 
		{
			[self setTableView: self.wallTypeTableView disabled:	YES];

			int wallType = [self.maze wallTypeWithLocationX: self.currentWallLocation.xx
                                                  locationY: self.currentWallLocation.yy
                                                  direction: self.currentWallDirection];

			[self setupWallTypeTableViewWallType: wallType];
		}
		
		[self setupWallPanel];

		[self.gridView setNeedsDisplay];
	}		
}

- (void)handleLongPressFrom: (UILongPressGestureRecognizer *)recognizer 
{
	if (recognizer.state == UIGestureRecognizerStateBegan)
	{
		CGPoint touchPoint = [recognizer locationInView: self.gridView];

		MALocation *location = [self.maze gridLocationWithTouchPoint: touchPoint
                                                                rows: self.maze.rows
                                                             columns: self.maze.columns];
		
		if (location != nil)
		{			
			[self locationChangedToCoord: CGPointMake(location.xx, location.yy)];
		}
	}
}	

- (void)locationChangedToCoord: (CGPoint)coord
{
	[self setTableView: self.locationTypeTableView disabled: NO];
	
	MALocation *newLocation = [self.maze locationWithLocationX: coord.x locationY: coord.y];
	
	BOOL setAsTeleportation = [self setNextLocationAsTeleportation];
	
	if (setAsTeleportation == YES && [self.maze isSurroundedByWallsWithLocation: newLocation] == YES)
	{
		[self teleportationSurroundedAlert];
		return;
	}
		
	self.previousLocation = self.currentLocation;
	self.currentLocation = newLocation;
		
	[self setupTabBarWithSelectedIndex: 2];
		
	if (setAsTeleportation == YES)
	{
		[self resetCurrentLocation];
		
		self.previousLocation.teleportX = self.currentLocation.xx;
		self.previousLocation.teleportY = self.currentLocation.yy;
				
		self.currentLocation.action = MALocationActionTeleport;
		self.currentLocation.teleportId = self.previousLocation.teleportId;
		self.currentLocation.teleportX = self.previousLocation.xx;
		self.currentLocation.teleportY = self.previousLocation.yy;
		
		[self showTutorialHelpForTopic: @"TeleportDirection"];
	}
	else 
	{
		[self showTutorialHelpForTopic: @"LocationTypes"];	
	}
		
	[self setupLocationActionTableViewLocationAction: self.currentLocation.action
                                               theta: self.currentLocation.direction];
	
	self.messageTextView.editable = YES;
	
	// set Message
	[self.messageTextView resignFirstResponder];
	self.messageTextView.text = self.currentLocation.message;

	[self setupLocationPanel];
	
	self.gridView.currentLocation = self.currentLocation;
	[self.gridView setNeedsDisplay];
}

- (BOOL)setNextLocationAsTeleportation
{
	if (self.currentLocation != nil && self.currentLocation.action == MALocationActionTeleport && self.currentLocation.teleportX == 0 && self.currentLocation.teleportY == 0)
    {
		return YES;
	}
    else
    {
		return NO;
    }
}

//
//	LOCATION TYPES
//

- (UIView *)tableView: (UITableView *)tableView viewForHeaderInSection: (NSInteger)section 
{
	UIView *headerView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, tableView.bounds.size.width, tableView.sectionHeaderHeight)];

	UILabel *headerLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, tableView.bounds.size.width, tableView.sectionHeaderHeight)];
	
	headerLabel.backgroundColor = [Styles shared].editView.tableHeaderBackgroundColor;
	headerLabel.font = [Styles shared].editView.tableHeaderFont;
	headerLabel.textColor = [Styles shared].editView.tableHeaderTextColor;
	headerLabel.textAlignment = [Styles shared].editView.tableHeaderTextAlignment;
	
	if (tableView == self.locationTypeTableView)
	{
		headerLabel.text = @"Location Type";
	}
	else if (tableView == self.directionTableView)
	{
		headerLabel.text = @"Direction";
	}
	else if (tableView == self.wallTypeTableView)
	{
		headerLabel.text = @"Wall Type";
	}
	else if (tableView == self.backgroundSoundTableView)
	{
		headerLabel.text = @"Background";
	}
    else
    {
        [MAUtilities logWithClass: [self class] format: @"Table view not handled: %@", tableView];
    }
	
	[headerView addSubview: headerLabel];
	
	return headerView;
}

- (NSInteger)numberOfSectionsInTableView: (UITableView *)tableView 
{
	if (tableView == self.locationTypeTableView || tableView == self.directionTableView || tableView == self.wallTypeTableView || tableView == self.backgroundSoundTableView)
    {
        return 1;
    }
    else
    {
        [MAUtilities logWithClass: [self class] format: @"Table view not handled: %@", tableView];
        return 0;
    }
}

- (NSInteger)tableView: (UITableView *)tableView numberOfRowsInSection: (NSInteger)section 
{
    if (tableView == self.locationTypeTableView)
	{
		return self.locationActions.count;
	}
	else if (tableView == self.directionTableView)
	{
		return self.directionThetas.count;
	}
	else if (tableView == self.wallTypeTableView)
	{
		return self.wallTypes.count;
	}
	else if (tableView == self.backgroundSoundTableView)
	{
		return [MASoundManager shared].count + 1;
	}
    else
    {
        [MAUtilities logWithClass: [self class] format: @"Table view not handled: %@", tableView];
        return 0;
    }
}

- (UITableViewCell *)tableView: (UITableView *)tableView cellForRowAtIndexPath: (NSIndexPath *)indexPath 
{    
	UITableViewCell *cell = nil;
	
	if (tableView == self.locationTypeTableView)
	{
		static NSString *CellIdentifier = @"LocationTypeTableViewCell";
	
		cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
	
		if (cell == nil)
        {
			cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
        }
        
		[cell.textLabel setText: [self.locationActionLabels objectAtIndex: indexPath.row]];
		cell.textLabel.font = [Styles shared].defaultFont;
	}
	else if (tableView == self.directionTableView)
	{
		static NSString *CellIdentifier = @"DirectionTableViewCell";
		
		cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
		
		if (cell == nil)
        {
			cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
		}
        
		[cell.textLabel setText: [self.directionLabels objectAtIndex: indexPath.row]];
		cell.textLabel.font = [Styles shared].defaultFont;
		
		// add directional arrows to table
		
		float directionArrowLength = self.directionTableView.rowHeight * 0.6;
		UIImage *directionArrowImage = [MAUtilities createDirectionArrowImageWidth: directionArrowLength height: directionArrowLength];
		
		cell.imageView.contentMode = UIViewContentModeCenter;
		cell.imageView.image = directionArrowImage;
		
		CGFloat angleDegrees = [[self.directionThetas objectAtIndex: indexPath.row] floatValue];
		[MAUtilities rotateImageView: cell.imageView angleDegrees: angleDegrees];
	}
	else if (tableView == self.wallTypeTableView)
	{
		static NSString *CellIdentifier = @"WallTypeTableViewCell";
		
		cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
		
		if (cell == nil)
        {
			cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
		}
        
		[cell.textLabel setText: [self.wallTypeLabels objectAtIndex: indexPath.row]];
		cell.textLabel.font = [Styles shared].defaultFont;
	}
	else if (tableView == self.backgroundSoundTableView)
	{
		static NSString *CellIdentifier = @"BackgroundSoundTableViewCell";
		
		cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
		if (cell == nil)
		{
			cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
			cell.textLabel.font = [Styles shared].defaultFont;
		}
				
		if (indexPath.row == 0)
		{
			[cell.textLabel setText: @"None"];
			
			if (self.maze.backgroundSound == nil)
            {
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
			else
            {
				cell.accessoryType = UITableViewCellAccessoryNone;
            }
		}
		else 
		{
			NSArray	*backgroundSounds = [[MASoundManager shared] sortedByName];
		
			MASound *sound = [backgroundSounds objectAtIndex: indexPath.row - 1];
		
			[cell.textLabel setText: sound.name];

			if ([self.maze.backgroundSound.objectId isEqualToString: sound.objectId] == YES)
            {
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
			else
            {
				cell.accessoryType = UITableViewCellAccessoryNone;
            }
		}
	}
	
    return cell;
}

- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath 
{	
	UITableViewCell *cell = [tableView cellForRowAtIndexPath: indexPath];
	if (cell.accessoryType == UITableViewCellAccessoryCheckmark && tableView.tag <= 3)
	{
		[tableView deselectRowAtIndexPath: indexPath animated: YES];
		return;
	}
	
	if (tableView == self.locationTypeTableView)
	{
		MALocationActionType action = [[self.locationActions objectAtIndex: indexPath.row] intValue];

        switch (action)
        {
            case MALocationActionDoNothing:
            {
                [self resetCurrentLocation];
                
                [self showTutorialHelpForTopic: @"None"];
                
                break;
            }
                
            case MALocationActionStart:
            {
                [self resetCurrentLocation];
                
                MALocation *startLoc = [self.maze locationWithAction: MALocationActionStart];
                
                if (startLoc != nil)
                {
                    [startLoc reset];
                }
                
                [self showTutorialHelpForTopic: @"StartDirection"];

                break;
            }
                
            case MALocationActionEnd:
            {
                [self resetCurrentLocation];
                
                MALocation *endLoc = [self.maze locationWithAction: MALocationActionEnd];
                
                if (endLoc != nil)
                {
                    [endLoc reset];
                }
                
                [self showTutorialHelpForTopic: @"None"];			

                break;
            }
                
            case MALocationActionStartOver:
            {
                [self resetCurrentLocation];
                
                [self showTutorialHelpForTopic: @"None"];

                break;
            }
                
            case MALocationActionTeleport:
            {
                if ([self.maze isSurroundedByWallsWithLocation: self.currentLocation])
                {
                    [self teleportationSurroundedAlert];
                    
                    [self.locationTypeTableView deselectRowAtIndexPath: indexPath animated: YES];
                    return;
                }
                
                self.currentLocation.TeleportId = [self getNextTeleportId];
                
                [self showTutorialHelpForTopic: @"TeleportTwin"];

                break;
            }

            default:
                [MAUtilities logWithClass: [self class] format: @"Location action set to an illegal value: %d", action];
                
                break;
        }
        
		self.currentLocation.action = action;
		
		[self setupLocationActionTableViewLocationAction: self.currentLocation.action
                                                   theta: self.currentLocation.direction];
	}
	else if (tableView == self.directionTableView)
	{
		self.currentLocation.Direction = [[self.directionThetas objectAtIndex: indexPath.row] intValue];
		
		[self setupDirectionTableViewLocationAction: self.currentLocation.action
                                              theta: self.currentLocation.direction];
	}	
	else if (tableView == self.wallTypeTableView)
	{
		MAWallType oldWallType = [self.maze wallTypeWithLocationX: self.currentWallLocation.xx
                                                        locationY: self.currentWallLocation.yy
                                                        direction: self.currentWallDirection];
		
		MAWallType newWallType = [[self.wallTypes objectAtIndex: indexPath.row] intValue];
		
		[self.maze setWallTypeWithLocationX: self.currentWallLocation.xx
                                  locationY: self.currentWallLocation.yy
                                  direction: self.currentWallDirection
                                       type: newWallType];
		
		if ([self wallPassesTeleportationSurroundedCheck] == NO)
		{
			[self.maze setWallTypeWithLocationX: self.currentWallLocation.xx
                                      locationY: self.currentWallLocation.yy
                                      direction: self.currentWallDirection
                                           type: oldWallType];
		
			[self.wallTypeTableView deselectRowAtIndexPath: indexPath animated: YES];
			
			[self teleportationSurroundedAlert];
		}
		else 
		{
			[self setupWallTypeTableViewWallType: newWallType];
			
			if (newWallType == MAWallInvisible)
            {
				[self showTutorialHelpForTopic: @"InvisibleWalls"];
            }
			else if (newWallType == MAWallFake)
            {
				[self showTutorialHelpForTopic: @"FakeWalls"];
            }
			else
            {
				[self showTutorialHelpForTopic: @"None"];
            }
		}
	}	
	else if (tableView == self.backgroundSoundTableView)
	{
		NSArray	*backgroundSounds = [[MASoundManager shared] sortedByName];
		
		// previous
		
		int row = 0;
		if (self.maze.backgroundSound == nil)
		{
			row = 0;
		}
		else 
		{
			[self stopBackgroundSound];
			
			row = [backgroundSounds indexOfObject: self.maze.backgroundSound] + 1;
		}
		
		NSIndexPath	*prevIndexPath = [NSIndexPath indexPathForRow: row inSection: 0];	
		UITableViewCell *prevCell = [self.backgroundSoundTableView cellForRowAtIndexPath: prevIndexPath];
		
		prevCell.accessoryType = UITableViewCellAccessoryNone;
		
		// current
		
		if (indexPath.row == 0)
		{
			self.maze.backgroundSound = nil;
		}
		else 
		{
			MASound *sound = [backgroundSounds objectAtIndex: indexPath.row - 1];
			
			self.maze.backgroundSound = sound;
			
			[sound playWithNumberOfLoops: 0];
		}
		
		UITableViewCell *cell = [self.backgroundSoundTableView cellForRowAtIndexPath: indexPath];
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
		
		[self.backgroundSoundTableView deselectRowAtIndexPath: indexPath animated: YES];	
	}	
	
	[self.gridView setNeedsDisplay];
}

- (void)resetCurrentLocation
{
	if (self.currentLocation.action == MALocationActionTeleport)
	{
		[self showTutorialHelpForTopic: @"None"];
		
		MALocation *teleportLoc = [self.maze locationWithLocationX: self.currentLocation.teleportX
                                                         locationY: self.currentLocation.teleportY];

		if (teleportLoc != nil)
			[teleportLoc reset];
	}

	[self.currentLocation reset];
}

- (int)getNextTeleportId
{
	BOOL idexists;
	int teleportId = 0;
	do 
	{
		teleportId = teleportId + 1;
		
		idexists = NO;
		for (MALocation *location in self.maze.locations)
		{
			if (location.teleportId == teleportId)
            {
				idexists = YES;
            }
		}		
	} while (idexists == YES);
		
	return teleportId;
}

- (void)setupLocationActionTableViewLocationAction: (MALocationActionType)locationAction theta: (int)theta
{
	[self clearAccessoriesInTableView: self.locationTypeTableView];
	
	int row = [self.locationActions indexOfObject: [NSNumber numberWithInt: locationAction]];
	NSIndexPath	*indexPath = [NSIndexPath indexPathForRow: row inSection: 0];

	UITableViewCell *cell = [self.locationTypeTableView cellForRowAtIndexPath: indexPath];
	cell.accessoryType = UITableViewCellAccessoryCheckmark;

	[self.locationTypeTableView deselectRowAtIndexPath: indexPath animated: YES];
	
	[self setupDirectionTableViewLocationAction: locationAction theta: theta];
	[self setupMessageDisplaysLabelLocationAction: locationAction];
}

- (void)setupDirectionTableViewLocationAction: (MALocationActionType)locationAction theta: (int)theta
{
	[self clearAccessoriesInTableView: self.directionTableView];

	if (locationAction == MALocationActionStart || locationAction == MALocationActionTeleport)
	{
		[self setTableView: self.directionTableView disabled: NO];
		   
		int row = [self.directionThetas indexOfObject: [NSNumber numberWithInt: theta]];
		NSIndexPath	*indexPath = [NSIndexPath indexPathForRow: row inSection: 0];

		UITableViewCell *cell = [self.directionTableView cellForRowAtIndexPath: indexPath];
		cell.accessoryType = UITableViewCellAccessoryCheckmark;

		[self.directionTableView deselectRowAtIndexPath: indexPath animated: YES];
	}
	else 
	{
		[self setTableView: self.directionTableView disabled: YES];
	}
}

- (void)setupMessageDisplaysLabelLocationAction: (MALocationActionType)locationAction
{
    switch (locationAction)
    {
        case MALocationActionDoNothing:
            self.messageDisplaysLabel.text = @"Above maze";
            break;
            
        case MALocationActionStart:
            self.messageDisplaysLabel.text = @"Above maze";
            break;
            
        case MALocationActionEnd:
            self.messageDisplaysLabel.text = @"In pop-up";
            break;
            
        case MALocationActionStartOver:
            self.messageDisplaysLabel.text = @"In pop-up";
            break;
            
        case MALocationActionTeleport:
            self.messageDisplaysLabel.text = @"Above maze";
            break;
            
        default:
            [MAUtilities logWithClass: [self class] format: @"locationAction set to an illegal value: %d", locationAction];
            break;
    }
}

- (void)setupWallTypeTableViewWallType: (int)wallType
{
	[self clearAccessoriesInTableView: self.wallTypeTableView];
	
	int row = [self.wallTypes indexOfObject: [NSNumber numberWithInt: wallType]];
	NSIndexPath	*indexPath = [NSIndexPath indexPathForRow: row inSection: 0];
	
	UITableViewCell *cell = [self.wallTypeTableView cellForRowAtIndexPath: indexPath];
	cell.accessoryType = UITableViewCellAccessoryCheckmark;
	
	[self.wallTypeTableView deselectRowAtIndexPath: indexPath animated: YES];
}

- (void)clearAccessoriesInTableView: (UITableView *)tableView
{
	for (NSIndexPath *indexPath in [tableView indexPathsForVisibleRows])
	{
		UITableViewCell *cell = [tableView cellForRowAtIndexPath: indexPath];
		
		if (cell.accessoryType == UITableViewCellAccessoryCheckmark)
        {
			cell.accessoryType = UITableViewCellAccessoryNone;
        }
	}
}

- (BOOL)wallPassesTeleportationSurroundedCheck
{
	BOOL passes = YES;
	
	MALocation *location1 = nil;
	MALocation *location2 = nil;

	if (self.currentWallDirection == MADirectionNorth)
	{
		location1 = [self.maze locationWithLocationX: self.currentWallLocation.xx
                                           locationY: self.currentWallLocation.yy];
        
		location2 = [self.maze locationWithLocationX: self.currentWallLocation.xx locationY: self.currentWallLocation.yy - 1];
	}
	else if (self.currentWallDirection == MADirectionWest)
	{
		location1 = [self.maze locationWithLocationX: self.currentWallLocation.xx locationY: self.currentWallLocation.yy];
		location2 = [self.maze locationWithLocationX: self.currentWallLocation.xx - 1 locationY: self.currentWallLocation.yy];
	}

	if ((location1.action == MALocationActionTeleport && [self.maze isSurroundedByWallsWithLocation: location1] == YES) ||
		(location2.action == MALocationActionTeleport && [self.maze isSurroundedByWallsWithLocation: location2] == YES))
	{
		passes = NO;
	}
	else 
	{
		passes = YES;
	}

	return passes;
}

- (void)teleportationSurroundedAlert
{	
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @""
                                                        message: @"A teleportation location cannot be surrounded by walls."
                                                       delegate: nil
                                              cancelButtonTitle: @"OK"
                                              otherButtonTitles: nil];
    
    [alertView show];
}

//
//   PUBLIC SWITCH
//

- (IBAction)switchPublicValueChanged: (id)sender
{
	if (self.publicSwitch.on == YES)
    {
		[self validate];
	}
    
	[self showTutorialHelpForTopic: @"MakePublic"];
}

//
//   VERIFY PATH EXISTS
//

BOOL exists; 

- (BOOL)pathExists
{
	[self.locationsVisited removeAllObjects];
	exists = NO;
	
	MALocation *startLoc = [self.maze locationWithAction: MALocationActionStart];
	[self findExitLocation: startLoc];
	
	return exists;
}

- (void)findExitLocation: (MALocation *)location
{
	if ([self.locationsVisited indexOfObject: location] == NSNotFound)
    {
		[self.locationsVisited addObject: location];
    }
	else
    {
		return;
	}
    
	if (location.action == MALocationActionEnd)
    {
		exists = YES;
    }
    
	if (exists == YES || location.action == MALocationActionStartOver)
    {
		return;
    }
    
	MAWallType wallType;
	
	wallType = [self.maze wallTypeWithLocationX: location.xx locationY: location.yy direction: MADirectionNorth];
	if (wallType == MAWallNone || wallType == MAWallFake)
	{
		MALocation *newLocation = [self.maze locationWithLocationX: location.xx locationY: location.yy - 1];
		[self findExitLocation: newLocation];
	}
		 
	wallType = [self.maze wallTypeWithLocationX: location.xx locationY: location.yy direction: MADirectionEast];
	if (wallType == MAWallNone || wallType == MAWallFake)
	{
		MALocation *newLocation = [self.maze locationWithLocationX: location.xx + 1 locationY: location.yy];
		[self findExitLocation: newLocation];
	}
	
	wallType = [self.maze wallTypeWithLocationX: location.xx locationY: location.yy direction: MADirectionSouth];
	if (wallType == MAWallNone || wallType == MAWallFake)
	{
		MALocation *newLocation = [self.maze locationWithLocationX: location.xx locationY: location.yy + 1];
		[self findExitLocation: newLocation];
	}
	
	wallType = [self.maze wallTypeWithLocationX: location.xx locationY: location.yy direction: MADirectionWest];
	if (wallType == MAWallNone || wallType == MAWallFake)
	{
		MALocation *newLocation = [self.maze locationWithLocationX: location.xx - 1 locationY: location.yy];
		[self findExitLocation: newLocation];
	}
	
	if (location.action == MALocationActionTeleport)
	{
		MALocation *newLocation = [self.maze locationWithLocationX: location.teleportX locationY: location.teleportY];
		[self findExitLocation: newLocation];
	}
}

//
//   LOCATION PANEL
//

- (void)setupLocationPanel
{
	if (self.currentLocation != nil)
	{
		if (self.popoverControllerTextures.popoverVisible == YES)
        {
			[self.popoverControllerTextures dismissPopoverAnimated: YES];
		}
        
		MATexture *floorTexture = nil;
		if (self.currentLocation.floorTexture != nil)
		{
			floorTexture = self.currentLocation.floorTexture;
		}
		else
		{
			floorTexture = self.maze.floorTexture;
		}

		self.floorImageView.image = [UIImage imageNamed: [floorTexture.name stringByAppendingString: @".png"]];

		MATexture *ceilingTexture = nil;
		if (self.currentLocation.ceilingTexture != nil)
		{
			ceilingTexture = self.currentLocation.ceilingTexture;
		}
		else
		{
			ceilingTexture = self.maze.ceilingTexture;
		}
		
		self.ceilingImageView.image = [UIImage imageNamed: [ceilingTexture.name stringByAppendingString: @".png"]];
	}
	else 
	{
		self.floorImageView.backgroundColor = [Styles shared].editView.panelBackgroundColor;

		self.ceilingImageView.backgroundColor = [Styles shared].editView.panelBackgroundColor;
	}	
}

- (IBAction)floorButtonTouchDown
{
	if (self.currentLocation != nil)
	{
		TexturesViewController *texturesViewController = (TexturesViewController *)self.popoverControllerTextures.contentViewController;
		
		texturesViewController.textureDelegate = self.currentLocation;
		texturesViewController.textureSelector = @selector(setFloorTextureIdWithNumber:);
		texturesViewController.exitDelegate = self;
		texturesViewController.exitSelector = @selector(setupLocationPanel);
		
		[self.popoverControllerTextures presentPopoverFromRect: self.floorImageView.frame
                                                        inView: self.locationScrollView
                                      permittedArrowDirections: UIPopoverArrowDirectionAny animated: YES];
	}
}

- (IBAction)ceilingButtonTouchDown
{
	if (self.currentLocation != nil)
	{
		TexturesViewController *texturesViewController = (TexturesViewController *)self.popoverControllerTextures.contentViewController;
		
		texturesViewController.textureDelegate = self.currentLocation;
		texturesViewController.textureSelector = @selector(setCeilingTextureIdWithNumber:);
		texturesViewController.exitDelegate = self;
		texturesViewController.exitSelector = @selector(setupLocationPanel);
		
		[self.popoverControllerTextures presentPopoverFromRect: self.ceilingImageView.frame
                                                         inView: self.locationScrollView
                                       permittedArrowDirections: UIPopoverArrowDirectionAny animated: YES];
	}
}

//
//   WALL PANEL
//

- (void)setupWallPanel
{
	if (self.currentWallLocation != nil)
	{
		if (self.popoverControllerTextures.popoverVisible == YES)
        {
			[self.popoverControllerTextures dismissPopoverAnimated: YES];
		}
        
		MATexture *locationTexture = nil;
        MATexture *texture = nil;
		
		if (self.currentWallDirection == MADirectionNorth)
		{
			locationTexture = self.currentWallLocation.wallNorthTexture;
		}
		else if (self.currentWallDirection == MADirectionWest)
		{
			locationTexture = self.currentWallLocation.wallWestTexture;
		}
		
		if (locationTexture != nil)
		{
			texture = locationTexture;
		}
		else 
		{
			texture = self.maze.wallTexture;
		}
						
		self.wallImageView.image = [UIImage imageNamed: [texture.name stringByAppendingString: @".png"]];
	}
	else 
	{
		self.wallImageView.backgroundColor = [Styles shared].editView.panelBackgroundColor;
	}
}

- (void)wallButtonTouchDown
{
	if (self.currentWallLocation != nil)
	{
		TexturesViewController *texturesViewController = (TexturesViewController *)self.popoverControllerTextures.contentViewController;
		
		texturesViewController.textureDelegate = self.currentWallLocation;
			
		if (self.currentWallDirection == MADirectionNorth)
        {
			texturesViewController.textureSelector = @selector(setWallNorthTextureIdWithNumber:);
        }
		else if (self.currentWallDirection == MADirectionWest)
        {
			texturesViewController.textureSelector = @selector(setWallWestTextureIdWithNumber:);
        }
			
		texturesViewController.exitDelegate = self;
		texturesViewController.exitSelector = @selector(setupWallPanel);
		
		[self.popoverControllerTextures presentPopoverFromRect: self.wallImageView.frame
                                                        inView: self.wallView
                                      permittedArrowDirections: UIPopoverArrowDirectionAny animated: YES];
	}
}

//
//   GRAPHICS PANEL
//

- (void)setupGraphicsPanel
{	
	if (self.popoverControllerTextures.popoverVisible == YES)
    {
		[self.popoverControllerTextures dismissPopoverAnimated: YES];
	}
    
	MATexture *wallTexture = nil; // [[MATextureManager shared] textureWithId: [self.maze.wallTextureId intValue]];
	self.wallDefaultImageView.image = [UIImage imageNamed: [wallTexture.name stringByAppendingString: @".png"]];
	
	MATexture *floorTexture = nil; //  [[MATextureManager shared] textureWithId: [self.maze.floorTextureId intValue]];
	self.floorDefaultImageView.image = [UIImage imageNamed: [floorTexture.name stringByAppendingString: @".png"]];
	
	MATexture *ceilingTexture = nil; //  [[MATextureManager shared] textureWithId: [self.maze.ceilingTextureId intValue]];
	self.ceilingDefaultImageView.image = [UIImage imageNamed: [ceilingTexture.name stringByAppendingString: @".png"]];
}

- (void)wallDefaultButtonTouchDown
{
	TexturesViewController *texturesViewController = (TexturesViewController *)self.popoverControllerTextures.contentViewController;
	
	texturesViewController.textureDelegate = self.maze;
	texturesViewController.textureSelector = @selector(setWallTextureIdWithNumber:);
	texturesViewController.exitDelegate = self;
	texturesViewController.exitSelector = @selector(setupGraphicsPanel);
	
	[self.popoverControllerTextures presentPopoverFromRect: self.wallDefaultImageView.frame
                                                    inView: self.graphicsView
                                  permittedArrowDirections: UIPopoverArrowDirectionAny animated: YES];
}

- (void)floorDefaultButtonTouchDown
{
	TexturesViewController *texturesViewController = (TexturesViewController *)self.popoverControllerTextures.contentViewController;
	
	texturesViewController.textureDelegate = self.maze;
	texturesViewController.textureSelector = @selector(setFloorTextureIdWithNumber:);
	texturesViewController.exitDelegate = self;
	texturesViewController.exitSelector = @selector(setupGraphicsPanel);
	
	[self.popoverControllerTextures presentPopoverFromRect: self.floorDefaultImageView.frame
                                                    inView: self.graphicsView
                                  permittedArrowDirections: UIPopoverArrowDirectionAny animated: YES];
}

- (void)ceilingDefaultButtonTouchDown
{
	TexturesViewController *texturesViewController = (TexturesViewController *)self.popoverControllerTextures.contentViewController;
	
	texturesViewController.textureDelegate = self.maze;
	texturesViewController.textureSelector = @selector(setCeilingTextureIdWithNumber:);
	texturesViewController.exitDelegate = self;
	texturesViewController.exitSelector = @selector(setupGraphicsPanel);
	
	[self.popoverControllerTextures presentPopoverFromRect: self.ceilingDefaultImageView.frame
                                                    inView: self.graphicsView
                                  permittedArrowDirections: UIPopoverArrowDirectionAny animated: YES];
}

//
//   AUDIO PANEL
//




//
//   SAVE
//

- (IBAction)saveButtonTouchDown: (id)sender
{
	if([self setNextLocationAsTeleportation] == YES)
	{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @""
                                                            message: @"Please select a second teleportation location before saving."
                                                           delegate: nil
                                                  cancelButtonTitle: @"OK"
                                                  otherButtonTitles: nil];
        
        [alertView show];
        
		return;
	}
	
	if ([self validate] == NO)
	{
		return;
	}

    self.maze.name = [self.nameTextField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.maze.public = self.publicSwitch.on;
	
    [self saveMaze];
}

- (void)saveMaze
{
    // [self.operationQueue addOperation: [[ServerOperations shared] saveMazeOperationWithDelegate: self maze: self.maze]];
}

- (void)serverOperationsSaveMaze: (MAMaze *)maze error: (NSError *)error
{
    if (error == nil)
    {
        if (maze != nil)
        {
            self.maze = maze;
            
            /*
             if (retVal == [Constants shared].nameExists)
             {
                [self setupTabBarWithSelectedIndex: 1];
             
                NSString *message = [NSString stringWithFormat: @"There is already a maze with the name %@.", [Globals instance].mazeEdit.name];
             
                [Utilities ShowAlertWithDelegate: self Message: message CancelButtonTitle: @"OK" OtherButtonTitle: @"" Tag: 0 Bounds: CGRectZero];
             }
             */
        }
    }
    else
    {
        [[MAEvents shared] addEvent: self.saveMazeEvent];
    }
}

//
//   FORM VALIDATION
//

- (BOOL)validate
{
	BOOL passed = YES; 
	
	NSString *mazeName = [self.nameTextField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];

	MALocation *startLoc = [self.maze locationWithAction: MALocationActionStart];

	if ([mazeName isEqualToString: @""] == true)
	{
		[self setupTabBarWithSelectedIndex: 1];
				
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @""
                                                            message: @"Please enter in a name for your maze."
                                                           delegate: nil
                                                  cancelButtonTitle: @"OK"
                                                  otherButtonTitles: nil];
        
        [alertView show];

		passed = NO;
	}
	else if (startLoc == nil)
	{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @""
                                                            message: @"Please select a start location."
                                                           delegate: nil
                                                  cancelButtonTitle: @"OK"
                                                  otherButtonTitles: nil];
        [alertView show];

		passed = NO;
	}
	else if (self.publicSwitch.on == YES)
	{
		MALocation *endLoc = [self.maze locationWithAction: MALocationActionEnd];
				
		if (endLoc == nil)
		{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @""
                                                                message: @"Your maze must have an end location before it can be made public."
                                                               delegate: nil
                                                      cancelButtonTitle: @"OK"
                                                      otherButtonTitles: nil];
            [alertView show];

			passed = NO;
		}
		else if ([self pathExists] == NO)
		{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @""
                                                                message: @"Your maze must have a path from start to end before it can be made public."
                                                               delegate: nil
                                                      cancelButtonTitle: @"OK"
                                                      otherButtonTitles: nil];
            [alertView show];

			passed = NO;
		}
	}

	if (self.publicSwitch.on == YES && passed == NO)
    {
		[self.publicSwitch setOn: NO animated: YES];
    }
    
	return passed;
}

//
//   DELETE
//

- (IBAction)deleteButtonTouchDown: (id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @""
                                                        message: @"Delete maze?"
                                                       delegate: self
                                              cancelButtonTitle: @"Yes"
                                              otherButtonTitles: @"No", nil];
    alertView.tag = 1;
    
    [alertView show];    
}

- (void)alertView: (UIAlertView *)alertView didDismissWithButtonIndex: (NSInteger)buttonIndex
{
	// answers Yes to delete
	if (alertView.tag == 1 && buttonIndex == 0)
	{
		[self stopBackgroundSound];
		
		if (self.maze.objectId != nil)
		{	
			[self deleteMaze];
		}
		else 
		{
			[self setupCreateView];
		}
	}
}

- (void)deleteMaze
{
    // [self.operationQueue addOperation: [[ServerOperations shared] deleteMazeOperationWithDelegate: self mazeId: [self.maze.objectId intValue]]];
}

- (void)serverOperationsDeleteMazeWithError: (NSError *)error
{
    if (error == nil)
    {
        [self setupCreateView];
    }
    else
    {
        [[MAEvents shared] addEvent: self.deleteMazeEvent];
    }
}

- (void)setupCreateView
{
	[self setup];
	
    [[CreateViewController shared] reset];
    
	[self.navigationController pushViewController: [CreateViewController shared] animated: NO];
}

- (IBAction)mazesButtonTouchDown: (id)sender
{
	[self stopBackgroundSound];
	
	//[[MainListViewController shared] loadMazeList];
	
	[self.navigationController popViewControllerAnimated: NO];
}

- (void)stopBackgroundSound
{
	[self.maze.backgroundSound stop];
}

//
//   KEYBOARD
//

// location message

- (void)textViewDidBeginEditing: (UITextView *)textView
{
	[self showTutorialHelpForTopic: @"LocationMessages"];
}

- (BOOL)textView: (UITextView *)textView shouldChangeTextInRange: (NSRange)range replacementText: (NSString *)string
{
	BOOL changeText = YES;
	
	NSRange rangeNewLine = [string rangeOfString: @"\n"];
	NSRange rangeBackspace = [string rangeOfString: @"\b"];
		 
	if (rangeNewLine.location != NSNotFound)
	{
		changeText = NO;

		[self.messageTextView resignFirstResponder];
	}
	else if (range.location >= [MAConstants shared].locationMessageMaxLength)
	{
		if (rangeBackspace.location == NSNotFound)
        {
			changeText = NO;
        }
    }
	
	return changeText;
}

- (void)textViewDidEndEditing: (UITextView *)textView
{
	[self.gridView setNeedsDisplay];
}

- (void)textViewDidChange:(UITextView *)textView
{	
	self.currentLocation.Message = [self.messageTextView.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

// maze name

- (BOOL)textField: (UITextField *)textField shouldChangeCharactersInRange: (NSRange)range replacementString: (NSString *)string
{
	BOOL changeText = YES;
	
	NSRange rangeNewLine = [string rangeOfString: @"\n"];
	
	if (rangeNewLine.location != NSNotFound)
	{
		changeText = NO;
		
		[self.nameTextField resignFirstResponder];
	}
	else if (range.location >= [MAConstants shared].mazeNameMaxLength)
	{
		changeText = NO;
    }
	
	return changeText;
}

- (IBAction)swtichTutorialValueChanged: (id)sender
{
	if (self.tutorialSwitch.on == NO)
	{
		[self showTutorialHelpForTopic: @"None"];
	}
	
    [Settings shared].useTutorial = self.tutorialSwitch.on;
}

- (void)showTutorialHelpForTopic: (NSString *)topic
{
	if ([Settings shared].useTutorial == YES)
	{
		if ([topic isEqualToString: @"None"] == YES)
		{
			self.message1Label.text = @"";
			self.message2Label.text = @"";
		}
		else if ([topic isEqualToString: @"Start"] == YES)
		{
			self.message1Label.text = @"Tap on a wall (blue segment) to remove it or put it back.";
			self.message2Label.text = @"Tap and hold on a white square to select a location.";
		}
		else if ([topic isEqualToString: @"WallTypes"] == YES)
		{
			self.message1Label.text = @"Tap on the list above to select additional wall types.";
			self.message2Label.text = @"";
		}
		else if ([topic isEqualToString: @"InvisibleWalls"] == YES)
		{
			self.message1Label.text = @"An invisible wall is solid but can't be seen.";
			self.message2Label.text = @"A player can't pass through an invisible wall.";
		}
		else if ([topic isEqualToString: @"FakeWalls"] == YES)
		{
			self.message1Label.text = @"A fake wall looks like a normal wall but is not solid.";
			self.message2Label.text = @"A fake wall will disappear after a player passes through it.";
		}
		else if ([topic isEqualToString: @"LocationTypes"] == YES)
		{
			self.message1Label.text = @"Tap on the Location Type list to determine what will happen at this location.";
			self.message2Label.text = @"";
		}
		else if ([topic isEqualToString: @"StartDirection"] == YES)
		{
			self.message1Label.text = @"Tap on the Direction list to choose the direction the player will face when first entering";
			self.message2Label.text = @"the maze.";
		}
		else if ([topic isEqualToString: @"TeleportTwin"] == YES)
		{
			self.message1Label.text = @"Please select a second teleportation location.";
			self.message2Label.text = @"";
		}
		else if ([topic isEqualToString: @"TeleportDirection"] == YES)
		{
			self.message1Label.text = @"Tap on the Direction list to select the direction the player will face after being teleported to";
			self.message2Label.text = @"this location.";
		}
		else if ([topic isEqualToString: @"LocationMessages"] == YES)
		{
			self.message1Label.text = @"Type in a message to display to the player at this location. The message will either be displayed";
			self.message2Label.text = @"above the maze or in a pop-up depending on the type of location.";
		}
		else if ([topic isEqualToString: @"MakePublic"] == YES)
		{
			self.message1Label.text = @"Set Make Public to On to let everyone play your maze.";
			self.message2Label.text = @"If you have recently saved your maze it will appear at the top of the Newest list.";
		}
        else
        {
            [MAUtilities logWithClass: [self class] format: @"topic set to an illegal value: %@", topic];
        }
	}
}

- (void)setTableView: (UITableView *)tableView disabled: (BOOL)disabled
{
	if (disabled == YES && tableView.allowsSelection == YES)
	{
		tableView.backgroundColor =	[Styles shared].editView.tableViewDisabledBackgroundColor;
		tableView.allowsSelection = NO;
	}
	else if (disabled == NO && tableView.allowsSelection == NO)
	{
		tableView.backgroundColor =	[Styles shared].editView.tableViewBackgroundColor;
		tableView.allowsSelection = YES;
	}
}

@end
