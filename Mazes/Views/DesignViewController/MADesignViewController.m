//
//  MADesignViewController.m
//  Mazes
//
//  Created by Andre Muis on 4/30/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import "MADesignViewController.h"

#import "MAColors.h"
#import "MAConstants.h"
#import "MACoordinate.h"
#import "MACreateViewController.h"
#import "MADesignScreenStyle.h"
#import "MAEventManager.h"
#import "MAEvent.h"
#import "MAFloorPlanView.h"
#import "MALocation.h"
#import "MAMainViewController.h"
#import "MAMazeManager.h"
#import "MAMaze.h"
#import "MASettings.h"
#import "MASize.h"
#import "MASoundManager.h"
#import "MASound.h"
#import "MAStyles.h"
#import "MATextureManager.h"
#import "MATexture.h"
#import "MATexturesViewController.h"
#import "MATopMazesViewController.h"
#import "MAUtilities.h"
#import "MAWall.h"
#import "MAWebServices.h"

@interface MADesignViewController ()

@property (readonly, strong, nonatomic) MAWebServices *webServices;

@property (readonly, strong, nonatomic) MAEventManager *eventManager;
@property (readonly, strong, nonatomic) MAMazeManager *mazeManager;
@property (readonly, strong, nonatomic) MASettings *settings;
@property (readonly, strong, nonatomic) MASoundManager *soundManager;
@property (readonly, strong, nonatomic) MAColors *colors;
@property (readonly, strong, nonatomic) MAStyles *styles;
@property (readonly, strong, nonatomic) MATextureManager *textureManager;

@property (assign, nonatomic) int selectedTabIndex;
	
@property (strong, nonatomic) NSArray *locationActions;
@property (strong, nonatomic) NSArray *locationActionLabels;
    
@property (strong, nonatomic) NSArray *directionThetas;
@property (strong, nonatomic) NSArray *directionLabels;
	
@property (strong, nonatomic) NSArray *wallTypes;
@property (strong, nonatomic) NSArray *wallTypeLabels;

@property (strong, nonatomic) NSMutableArray *locationsVisited;

@property (readonly, strong, nonatomic) UIPopoverController *texturesPopoverController;
@property (readonly, strong, nonatomic) MATexturesViewController *texturesViewController;

@end

@implementation MADesignViewController

- (id)initWithWebServices: (MAWebServices *)webServices
             eventManager: (MAEventManager *)eventManager
              mazeManager: (MAMazeManager *)mazeManager
             soundManager: (MASoundManager *)soundManager
           textureManager: (MATextureManager *)textureManager
{
    self = [super initWithNibName: NSStringFromClass([self class])
                           bundle: nil];
    
    if (self)
    {
        _webServices = webServices;
        
        _eventManager = eventManager;
        _mazeManager = mazeManager;
        _textureManager = textureManager;
        _soundManager = soundManager;
        _settings = [MASettings settings];
        _colors = [MAColors colors];
        _styles = [MAStyles styles];
        
        _texturesViewController = [[MATexturesViewController alloc] initWithTextureManager: textureManager];
        
        _texturesPopoverController = [[UIPopoverController alloc] initWithContentViewController: _texturesViewController];
    }
    
    return self;
}

- (void)viewDidLoad 
{
    [super viewDidLoad];

	self.mainView.frame = CGRectMake(0.0, 0.0, self.contentView.frame.size.width, self.contentView.frame.size.height);
	self.mainView.backgroundColor = self.styles.designScreen.panelBackgroundColor;
	[self.contentView addSubview: self.mainView];
    
	self.locationScrollView.contentSize = self.locationScrollView.frame.size;
	self.locationScrollView.frame = CGRectMake(0.0, 0.0, self.contentView.frame.size.width, self.contentView.frame.size.height);
	self.locationScrollView.backgroundColor = self.styles.designScreen.panelBackgroundColor;
    self.floorTextureButton.backgroundColor = [UIColor clearColor];
    self.ceilingTextureButton.backgroundColor = [UIColor clearColor];
	[self.contentView addSubview: self.locationScrollView];
	
	self.wallView.frame = CGRectMake(0.0, 0.0, self.contentView.frame.size.width, self.contentView.frame.size.height);
	self.wallView.backgroundColor = self.styles.designScreen.panelBackgroundColor;
    self.wallTextureButton.backgroundColor = [UIColor clearColor];
	[self.contentView addSubview: self.wallView];
	
	self.graphicsView.frame = CGRectMake(0.0, 0.0, self.contentView.frame.size.width, self.contentView.frame.size.height);
	self.graphicsView.backgroundColor = self.styles.designScreen.panelBackgroundColor;
    self.defaultWallTextureButton.backgroundColor = [UIColor clearColor];
    self.defaultFloorTextureButton.backgroundColor = [UIColor clearColor];
    self.defaultCeilingTextureButton.backgroundColor = [UIColor clearColor];
	[self.contentView addSubview: self.graphicsView];
	
	self.audioView.frame = CGRectMake(0.0, 0.0, self.contentView.frame.size.width, self.contentView.frame.size.height);
	self.audioView.backgroundColor = self.styles.designScreen.panelBackgroundColor;
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
	
	[self.backgroundSoundTableView setRowHeight: (self.backgroundSoundTableView.frame.size.height - self.backgroundSoundTableView.sectionHeaderHeight) / self.styles.designScreen.tableViewBackgroundSoundRows];

	self.messageDisplaysLabel.backgroundColor = self.styles.designScreen.panelBackgroundColor;
	
	self.buttonsView.backgroundColor = self.styles.designScreen.buttonsViewBackgroundColor;
	
	self.message1Label.backgroundColor = self.styles.designScreen.messageBackgroundColor;
	self.message1Label.textColor = self.styles.designScreen.messageTextColor;
	
	self.message2Label.backgroundColor = self.styles.designScreen.messageBackgroundColor;
	self.message2Label.textColor = self.styles.designScreen.messageTextColor;
	
    self.floorPlanView.maze = self.maze;
    
	UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(handleTapFrom:)];
	tapRecognizer.cancelsTouchesInView = NO;
	[self.view addGestureRecognizer: tapRecognizer];
	
	UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget: self action: @selector(handleLongPressFrom:)];
	longPressRecognizer.cancelsTouchesInView = NO;
	longPressRecognizer.minimumPressDuration = 0.4;
    
	[self.view addGestureRecognizer: longPressRecognizer];

	self.locationsVisited = [[NSMutableArray alloc] init];
	
	[self setup];
}

- (void)viewWillAppear: (BOOL)animated
{
	[super viewWillAppear: animated];
	
	[self.floorPlanView refresh];

    [self setupTexturesPopover];
}

- (void)setupTexturesPopover
{
    [self.texturesViewController setup];
    
    _texturesPopoverController.popoverContentSize = CGSizeMake(self.styles.designScreen.texturesPopoverWidth,
                                                               self.styles.designScreen.texturesPopoverHeight);
    _texturesPopoverController.delegate = self;
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
		
	self.tutorialSwitch.on = self.settings.useTutorial;
	
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

- (IBAction)wallButtonTouchDown: (id)sender
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
	self.mainButton.backgroundColor = self.styles.designScreen.tabDarkColor;
	self.locationButton.backgroundColor = self.styles.designScreen.tabDarkColor;
	self.wallButton.backgroundColor = self.styles.designScreen.tabDarkColor;
	self.graphicsButton.backgroundColor = self.styles.designScreen.tabDarkColor;
	self.audioButton.backgroundColor = self.styles.designScreen.tabDarkColor;

	if (selectedIndex == 1)
	{
		self.mainButton.backgroundColor = self.styles.designScreen.panelBackgroundColor;
		
		[self.contentView bringSubviewToFront: self.mainView];
	}
	else if (selectedIndex == 2)
	{
		self.locationButton.backgroundColor = self.styles.designScreen.panelBackgroundColor;
		
		[self.contentView bringSubviewToFront: self.locationScrollView];
	}
	else if (selectedIndex == 3)
	{
		self.wallButton.backgroundColor = self.styles.designScreen.panelBackgroundColor;
		
		[self.contentView bringSubviewToFront: self.wallView];
	}
	else if (selectedIndex == 4)
	{
		self.graphicsButton.backgroundColor = self.styles.designScreen.panelBackgroundColor;
		
		[self.contentView bringSubviewToFront: self.graphicsView];
	}
	else if (selectedIndex == 5)
	{
		self.audioButton.backgroundColor = self.styles.designScreen.panelBackgroundColor;
		
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
	CGPoint touchPoint = [recognizer locationInView: self.floorPlanView];

	MAWall *wall = [self.floorPlanView wallWithTouchPoint: touchPoint];

	if (wall != nil)
	{
		self.maze.currentSelectedWall = wall;
		
		[self setupTabBarWithSelectedIndex: 3];
		
		if ([self.maze isInnerWall: wall] == YES)
		{
			[self setTableView: self.wallTypeTableView disabled: NO];
			
			if (self.maze.currentSelectedWall.type == MAWallNone)
            {
				self.maze.currentSelectedWall.type = MAWallSolid;
            }
			else
            {
				self.maze.currentSelectedWall.type = MAWallNone;
            }
            
			if ([self wallPassesTeleportationSurroundedCheck] == NO)
			{
				self.maze.currentSelectedWall.type = self.maze.previousSelectedWall.type;
                
				[self teleportationSurroundedAlert];
			}
			
			[self setupWallTypeTableViewWallType: self.maze.currentSelectedWall.type];
			
            self.maze.previousSelectedWall = self.maze.currentSelectedWall;
            
			[self showTutorialHelpForTopic: @"WallTypes"];
		}
		else 
		{
			[self setTableView: self.wallTypeTableView disabled: YES];

			[self setupWallTypeTableViewWallType: self.maze.currentSelectedWall.type];
		}
		
		[self setupWallPanel];

		[self.floorPlanView refresh];
	}		
}

- (void)handleLongPressFrom: (UILongPressGestureRecognizer *)recognizer 
{
	if (recognizer.state == UIGestureRecognizerStateBegan)
	{
		CGPoint touchPoint = [recognizer locationInView: self.floorPlanView];

		MALocation *location = [self.floorPlanView locationWithTouchPoint: touchPoint];
		
		if (location != nil)
		{			
			[self locationChangedToCoordinate: location.coordinate];
		}
	}
}	

- (void)locationChangedToCoordinate: (MACoordinate *)coordinate
{
	[self setTableView: self.locationTypeTableView disabled: NO];
	
	MALocation *newLocation = [self.maze locationWithRow: coordinate.row
                                                  column: coordinate.column];
	
	BOOL setAsTeleportation = [self setNextLocationAsTeleportation];
	
	if (setAsTeleportation == YES && [self.maze isSurroundedByWallsWithLocation: newLocation] == YES)
	{
		[self teleportationSurroundedAlert];
		return;
	}
		
	self.maze.previousSelectedLocation = self.maze.currentSelectedLocation;
	self.maze.currentSelectedLocation = newLocation;
		
	[self setupTabBarWithSelectedIndex: 2];
		
	if (setAsTeleportation == YES)
	{
		[self resetCurrentLocation];
		
		self.maze.previousSelectedLocation.teleportX = self.maze.currentSelectedLocation.column;
		self.maze.previousSelectedLocation.teleportY = self.maze.currentSelectedLocation.row;
				
		self.maze.currentSelectedLocation.action = MALocationActionTeleport;
		self.maze.currentSelectedLocation.teleportId = self.maze.previousSelectedLocation.teleportId;
		self.maze.currentSelectedLocation.teleportX = self.maze.previousSelectedLocation.column;
		self.maze.currentSelectedLocation.teleportY = self.maze.previousSelectedLocation.row;
		
		[self showTutorialHelpForTopic: @"TeleportDirection"];
	}
	else 
	{
		[self showTutorialHelpForTopic: @"LocationTypes"];	
	}
		
	[self setupLocationActionTableViewLocationAction: self.maze.currentSelectedLocation.action
                                               theta: self.maze.currentSelectedLocation.direction];
	
	self.messageTextView.editable = YES;
	
	// set Message
	[self.messageTextView resignFirstResponder];
	self.messageTextView.text = self.maze.currentSelectedLocation.message;

	[self setupLocationPanel];
	
	[self.floorPlanView refresh];
}

- (BOOL)setNextLocationAsTeleportation
{
	if (self.maze.currentSelectedLocation != nil &&
        self.maze.currentSelectedLocation.action == MALocationActionTeleport &&
        self.maze.currentSelectedLocation.teleportX == 0 && self.maze.currentSelectedLocation.teleportY == 0)
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
	
	headerLabel.backgroundColor = self.styles.designScreen.tableHeaderBackgroundColor;
	headerLabel.font = self.styles.designScreen.tableHeaderFont;
	headerLabel.textColor = self.styles.designScreen.tableHeaderTextColor;
	headerLabel.textAlignment = self.styles.designScreen.tableHeaderTextAlignment;
	
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
		return self.soundManager.count + 1;
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
		cell.textLabel.font = self.styles.defaultFont;
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
		cell.textLabel.font = self.styles.defaultFont;
		
		// add directional arrows to table
		
		float directionArrowLength = self.directionTableView.rowHeight * 0.6;
		UIImage *directionArrowImage = [MAUtilities createDirectionArrowImageWidth: directionArrowLength height: directionArrowLength];
		
		cell.imageView.contentMode = UIViewContentModeCenter;
		cell.imageView.image = directionArrowImage;
		
		CGFloat angleDegrees = [[self.directionThetas objectAtIndex: indexPath.row] floatValue];
        cell.imageView.transform = CGAffineTransformMakeRotation([MAUtilities radiansFromDegrees: angleDegrees]);
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
		cell.textLabel.font = self.styles.defaultFont;
	}
	else if (tableView == self.backgroundSoundTableView)
	{
		static NSString *CellIdentifier = @"BackgroundSoundTableViewCell";
		
		cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
		if (cell == nil)
		{
			cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
			cell.textLabel.font = self.styles.defaultFont;
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
			NSArray	*backgroundSounds = [self.soundManager sortedByName];
		
			MASound *sound = [backgroundSounds objectAtIndex: indexPath.row - 1];
		
			[cell.textLabel setText: sound.name];

			if (self.maze.backgroundSound == sound)
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
                
                if (self.maze.startLocation != nil)
                {
                    [self.maze.startLocation reset];
                    self.maze.startLocation.floorTextureId = self.maze.floorTexture.textureId;
                }
                
                self.maze.currentSelectedLocation.floorTextureId = MAGreenTextureId;
                
                [self showTutorialHelpForTopic: @"StartDirection"];

                break;
            }
                
            case MALocationActionEnd:
            {
                [self resetCurrentLocation];
                
                if (self.maze.endLocation != nil)
                {
                    self.maze.endLocation.floorTextureId = self.maze.floorTexture.textureId;
                    [self.maze.endLocation reset];
                }
                
                self.maze.currentSelectedLocation.floorTextureId = MARedTextureId;

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
                if ([self.maze isSurroundedByWallsWithLocation: self.maze.currentSelectedLocation])
                {
                    [self teleportationSurroundedAlert];
                    
                    [self.locationTypeTableView deselectRowAtIndexPath: indexPath animated: YES];
                    return;
                }
                
                self.maze.currentSelectedLocation.TeleportId = [self getNextTeleportId];
                
                [self showTutorialHelpForTopic: @"TeleportTwin"];

                break;
            }

            default:
                [MAUtilities logWithClass: [self class] format: @"Location action set to an illegal value: %d", action];
                
                break;
        }
        
		self.maze.currentSelectedLocation.action = action;
		
		[self setupLocationActionTableViewLocationAction: self.maze.currentSelectedLocation.action
                                                   theta: self.maze.currentSelectedLocation.direction];
	}
	else if (tableView == self.directionTableView)
	{
		self.maze.currentSelectedLocation.Direction = [[self.directionThetas objectAtIndex: indexPath.row] intValue];
		
		[self setupDirectionTableViewLocationAction: self.maze.currentSelectedLocation.action
                                              theta: self.maze.currentSelectedLocation.direction];
	}	
	else if (tableView == self.wallTypeTableView)
	{
        self.maze.currentSelectedWall.type = [[self.wallTypes objectAtIndex: indexPath.row] intValue];
		
		if ([self wallPassesTeleportationSurroundedCheck] == NO)
		{
            self.maze.currentSelectedWall.type = self.maze.previousSelectedWall.type;
            
			[self.wallTypeTableView deselectRowAtIndexPath: indexPath animated: YES];
			
			[self teleportationSurroundedAlert];
		}
		else 
		{
			[self setupWallTypeTableViewWallType: self.maze.currentSelectedWall.type];
			
			if (self.maze.currentSelectedWall.type == MAWallInvisible)
            {
				[self showTutorialHelpForTopic: @"InvisibleWalls"];
            }
			else if (self.maze.currentSelectedWall.type == MAWallFake)
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
		NSArray	*backgroundSounds = [self.soundManager sortedByName];
		
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
	
	[self.floorPlanView refresh];
}

- (void)resetCurrentLocation
{
	if (self.maze.currentSelectedLocation.action == MALocationActionTeleport)
	{
		[self showTutorialHelpForTopic: @"None"];
		
		MALocation *teleportLoc = [self.maze locationWithRow: self.maze.currentSelectedLocation.teleportY
                                                      column: self.maze.currentSelectedLocation.teleportX];

		if (teleportLoc != nil)
        {
			[teleportLoc reset];
        }
	}

	[self.maze.currentSelectedLocation reset];
}

- (int)getNextTeleportId
{
	BOOL idexists;
	int teleportId = 0;
	do 
	{
		teleportId = teleportId + 1;
		
		idexists = NO;
		for (MALocation *location in [self.maze allLocations])
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
	MALocation *location1 = nil;
	MALocation *location2 = nil;

	if (self.maze.currentSelectedWall.type == MADirectionNorth)
	{
		location1 = [self.maze locationWithRow: self.maze.currentSelectedWall.row
                                        column: self.maze.currentSelectedWall.column];
        
		location2 = [self.maze locationWithRow: self.maze.currentSelectedWall.row - 1
                                        column: self.maze.currentSelectedWall.column];
	}
	else if (self.maze.currentSelectedWall.type == MADirectionWest)
	{
		location1 = [self.maze locationWithRow: self.maze.currentSelectedWall.row
                                        column: self.maze.currentSelectedWall.column];
        
		location2 = [self.maze locationWithRow: self.maze.currentSelectedWall.row
                                        column: self.maze.currentSelectedWall.column - 1] ;

	}

	if ((location1.action == MALocationActionTeleport && [self.maze isSurroundedByWallsWithLocation: location1] == YES) ||
		(location2.action == MALocationActionTeleport && [self.maze isSurroundedByWallsWithLocation: location2] == YES))
	{
		return NO;
	}
	else 
	{
		return YES;
	}
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
	
	[self findExitWithLocation: self.maze.endLocation];
	
	return exists;
}

- (void)findExitWithLocation: (MALocation *)location
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
    
	MAWall *northWall = [self.maze wallWithRow: location.row
                                        column: location.column
                                     direction: MADirectionNorth];
    
	if (northWall.type == MAWallNone || northWall.type == MAWallFake)
	{
		MALocation *nextLocation = [self.maze locationWithRow: location.row - 1
                                                       column: location.column];
        
		[self findExitWithLocation: nextLocation];
	}
		 
	MAWall *southWall = [self.maze wallWithRow: location.row
                                        column: location.column
                                     direction: MADirectionSouth];
    
	if (southWall.type == MAWallNone || southWall.type == MAWallFake)
	{
		MALocation *nextLocation = [self.maze locationWithRow: location.row + 1
                                                       column: location.column];
        
		[self findExitWithLocation: nextLocation];
	}
	
    MAWall *westWall = [self.maze wallWithRow: location.row
                                       column: location.column
                                    direction: MADirectionWest];
    
	if (westWall.type == MAWallNone || westWall.type == MAWallFake)
	{
		MALocation *nextLocation = [self.maze locationWithRow: location.row
                                                       column: location.column - 1];
        
		[self findExitWithLocation: nextLocation];
	}

	MAWall *eastWall = [self.maze wallWithRow: location.row
                                       column: location.column
                                    direction: MADirectionEast];
    
	if (eastWall.type == MAWallNone || eastWall.type == MAWallFake)
	{
		MALocation *nextLocation = [self.maze locationWithRow: location.row
                                                       column: location.column + 1];
        
		[self findExitWithLocation: nextLocation];
	}
	
	if (location.action == MALocationActionTeleport)
	{
		MALocation *nextLocation = [self.maze locationWithRow: location.teleportY
                                                       column: location.teleportX];
                                    
		[self findExitWithLocation: nextLocation];
	}
}

//
//   LOCATION PANEL
//

- (void)setupLocationPanel
{
	if (self.maze.currentSelectedLocation != nil)
	{
		if (self.texturesPopoverController.popoverVisible == YES)
        {
			[self.texturesPopoverController dismissPopoverAnimated: YES];
		}
        
		MATexture *floorTexture = nil;
        if (self.maze.currentSelectedLocation.floorTextureId != nil)
		{
			floorTexture = [self.textureManager textureWithTextureId: self.maze.currentSelectedLocation.floorTextureId];;
		}
		else
		{
			floorTexture = self.maze.floorTexture;
		}

        [self.floorTextureButton setImage: [UIImage imageNamed: [floorTexture.name stringByAppendingString: @".png"]]
                                 forState: UIControlStateNormal];

		MATexture *ceilingTexture = nil;
		if (self.maze.currentSelectedLocation.ceilingTextureId != nil)
		{
			ceilingTexture = [self.textureManager textureWithTextureId: self.maze.currentSelectedLocation.ceilingTextureId];;
		}
		else
		{
			ceilingTexture = self.maze.ceilingTexture;
		}
		
        [self.ceilingTextureButton setImage: [UIImage imageNamed: [ceilingTexture.name stringByAppendingString: @".png"]]
                                   forState: UIControlStateNormal];
	}
    else
    {
        [self.floorTextureButton setImage: nil forState: UIControlStateNormal];
        [self.ceilingTextureButton setImage: nil forState: UIControlStateNormal];
    }
}

- (IBAction)floorTextureButtonTouchDown: (id)sender
{
	if (self.maze.currentSelectedLocation != nil)
	{
        __weak typeof(self) weakSelf = self;
        
		self.texturesViewController.textureSelectedHandler = ^(MATexture *texture)
        {
            weakSelf.maze.currentSelectedLocation.floorTextureId = texture.textureId;
            [weakSelf setupLocationPanel];
        };
		
		[self.texturesPopoverController presentPopoverFromRect: self.floorTextureButton.frame
                                                        inView: self.locationScrollView
                                      permittedArrowDirections: UIPopoverArrowDirectionAny
                                                      animated: YES];
	}
}

- (IBAction)floorTextureResetButtonTouchDown: (id)sender
{
    self.maze.currentSelectedLocation.floorTextureId = nil;
    [self setupLocationPanel];
}

- (IBAction)ceilingTextureButtonTouchDown: (id)sender
{
	if (self.maze.currentSelectedLocation != nil)
	{
        __weak typeof(self) weakSelf = self;
        
		self.texturesViewController.textureSelectedHandler = ^(MATexture *texture)
        {
            weakSelf.maze.currentSelectedLocation.ceilingTextureId = texture.textureId;
            [weakSelf setupLocationPanel];
        };
		
		[self.texturesPopoverController presentPopoverFromRect: self.ceilingTextureButton.frame
                                                        inView: self.locationScrollView
                                      permittedArrowDirections: UIPopoverArrowDirectionAny
                                                      animated: YES];
	}
}

- (IBAction)ceilingTextureResetButtonTouchDown: (id)sender
{
    self.maze.currentSelectedLocation.ceilingTextureId = nil;
    [self setupLocationPanel];
}

//
//   WALL PANEL
//

- (void)setupWallPanel
{
	if (self.maze.currentSelectedWall != nil)
	{
		if (self.texturesPopoverController.popoverVisible == YES)
        {
			[self.texturesPopoverController dismissPopoverAnimated: YES];
		}
        
        MATexture *texture = nil;
		if (self.maze.currentSelectedWall.textureId != nil)
		{
			texture = [self.textureManager textureWithTextureId: self.maze.currentSelectedWall.textureId];
		}
		else
		{
			texture = self.maze.wallTexture;
		}
			
        [self.wallTextureButton setImage: [UIImage imageNamed: [texture.name stringByAppendingString: @".png"]]
                                forState: UIControlStateNormal];
	}
    else
    {
        [self.wallTextureButton setImage: nil forState: UIControlStateNormal];
    }
}

- (void)wallTextureButtonTouchDown: (id)sender
{
	if (self.maze.currentSelectedWall != nil)
	{
        __weak typeof(self) weakSelf = self;
        
		self.texturesViewController.textureSelectedHandler = ^(MATexture *texture)
        {
            weakSelf.maze.currentSelectedWall.textureId = texture.textureId;
            [weakSelf setupWallPanel];
        };
				
		[self.texturesPopoverController presentPopoverFromRect: self.wallTextureButton.frame
                                                        inView: self.wallView
                                      permittedArrowDirections: UIPopoverArrowDirectionAny animated: YES];
	}
}

- (IBAction)wallTextureResetButtonTouchDown: (id)sender
{
    self.maze.currentSelectedWall.textureId = nil;
    [self setupWallPanel];
}

//
//   GRAPHICS PANEL
//

- (void)setupGraphicsPanel
{	
	if (self.texturesPopoverController.popoverVisible == YES)
    {
		[self.texturesPopoverController dismissPopoverAnimated: YES];
	}
    
    [self.defaultWallTextureButton setImage: [UIImage imageNamed: [self.maze.wallTexture.name stringByAppendingString: @".png"]]
                                   forState: UIControlStateNormal];
    
    [self.defaultFloorTextureButton setImage: [UIImage imageNamed: [self.maze.floorTexture.name stringByAppendingString: @".png"]]
                                    forState: UIControlStateNormal];

    [self.defaultCeilingTextureButton setImage: [UIImage imageNamed: [self.maze.ceilingTexture.name stringByAppendingString: @".png"]]
                                      forState: UIControlStateNormal];
}

- (void)defaultWallTextureButtonTouchDown: (id)sender
{
    __weak typeof(self) weakSelf = self;
    
    self.texturesViewController.textureSelectedHandler = ^(MATexture *texture)
    {
        weakSelf.maze.wallTexture = texture;
        [weakSelf setupGraphicsPanel];
    };
	
	[self.texturesPopoverController presentPopoverFromRect: self.defaultWallTextureButton.frame
                                                    inView: self.graphicsView
                                  permittedArrowDirections: UIPopoverArrowDirectionAny animated: YES];
}

- (void)defaultFloorTextureButtonTouchDown: (id)sender
{
    __weak typeof(self) weakSelf = self;
    
    self.texturesViewController.textureSelectedHandler = ^(MATexture *texture)
    {
        weakSelf.maze.floorTexture = texture;
        [weakSelf setupGraphicsPanel];
    };
	
	[self.texturesPopoverController presentPopoverFromRect: self.defaultFloorTextureButton.frame
                                                    inView: self.graphicsView
                                  permittedArrowDirections: UIPopoverArrowDirectionAny animated: YES];
}

- (void)defaultCeilingTextureButtonTouchDown: (id)sender
{
    __weak typeof(self) weakSelf = self;
    
    self.texturesViewController.textureSelectedHandler = ^(MATexture *texture)
    {
        weakSelf.maze.ceilingTexture = texture;
        [weakSelf setupGraphicsPanel];
    };
	
	[self.texturesPopoverController presentPopoverFromRect: self.defaultCeilingTextureButton.frame
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
    [self.webServices saveMaze: self.maze
             completionHandler: ^(NSError *error)
    {
        if (error == nil)
        {
            if ([[error.userInfo allKeys] indexOfObject: MAStatusCodeKey] != NSNotFound)
            {
                NSNumber *statusCode = [error.userInfo objectForKey: MAStatusCodeKey];
                
                if ([statusCode integerValue] == 450)
                {
                    [self setupTabBarWithSelectedIndex: 1];
                 
                    NSString *message = [NSString stringWithFormat: @"There is already a maze with the name %@.", self.maze.name];
                 
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @""
                                                                        message: message
                                                                       delegate: nil
                                                              cancelButtonTitle: @"OK"
                                                              otherButtonTitles: nil];
                    
                    [alertView show];
                }
            }
        }
        else
        {
        
        }
    }];
}

//
//   FORM VALIDATION
//

- (BOOL)validate
{
	BOOL passed = YES; 
	
	NSString *mazeName = [self.nameTextField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];

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
	else if (self.maze.startLocation == nil)
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
		if (self.maze.endLocation == nil)
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
//   RESET
//

- (IBAction)resetButtonTouchDown: (id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @""
                                                        message: @"Reset maze?"
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
		
        [self.maze resetWithRows: MARowsMin
                         columns: MAColumnsMin
                 backgroundSound: nil
                     wallTexture: [self.textureManager textureWithTextureId: MAAlternatingBrickTextureId]
                    floorTexture: [self.textureManager textureWithTextureId: MALightSwirlMarbleTextureId]
                  ceilingTexture: [self.textureManager textureWithTextureId: MACreamyWhiteMarbleTextureId]];

        [self setup];
        
        self.mazeManager.isFirstUserMazeSizeChosen = NO;
        
        self.createViewController.maze = self.maze;
        
        [self.mainViewController transitionFromViewController: self
                                             toViewController: self.createViewController
                                                   transition: MATransitionCrossDissolve];
	}
}

- (IBAction)mazesButtonTouchDown: (id)sender
{
	[self stopBackgroundSound];
	
	[self.navigationController popViewControllerAnimated: NO];

    [self.mainViewController transitionFromViewController: self
                                         toViewController: self.topMazesViewController
                                               transition: MATransitionCrossDissolve];
}

- (void)stopBackgroundSound
{
	[self.mazeManager.firstUserMaze.backgroundSound stop];
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
	else if (range.location >= MALocationMessageMaxLength)
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
	[self.floorPlanView refresh];
}

- (void)textViewDidChange:(UITextView *)textView
{	
	self.maze.currentSelectedLocation.message = [self.messageTextView.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
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
	else if (range.location >= MAMazeNameMaxLength)
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
	
    self.settings.useTutorial = self.tutorialSwitch.on;
}

- (void)showTutorialHelpForTopic: (NSString *)topic
{
	if (self.settings.useTutorial == YES)
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
		tableView.backgroundColor =	self.styles.designScreen.tableViewDisabledBackgroundColor;
		tableView.allowsSelection = NO;
	}
	else if (disabled == NO && tableView.allowsSelection == NO)
	{
		tableView.backgroundColor =	self.styles.designScreen.tableViewBackgroundColor;
		tableView.allowsSelection = YES;
	}
}

@end




















