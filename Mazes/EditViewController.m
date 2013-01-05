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
#import "MainListViewController.h"
#import "Maze.h"
#import "Settings.h"
#import "Sounds.h"
#import "Sound.h"
#import "Textures.h"
#import "Texture.h"
#import "TexturesViewController.h"

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
    }
    
    return self;
}

- (void)viewDidLoad 
{
    [super viewDidLoad];

	self.view.frame = CGRectMake(0.0, 0.0, 768.0, 1024.0);

	self.viewMain.frame = self.viewPlaceHolder.frame;
	self.viewMain.backgroundColor = [Styles shared].editView.panelBackgroundColor;
	
	CGRect locationTypeFrame = self.locationTypeTableView.frame;
	CGRect directionFrame =	self.directionTableView.frame;
	
	self.scrollViewLocation.contentSize = self.scrollViewLocation.frame.size;
	self.scrollViewLocation.frame = self.viewPlaceHolder.frame;
	self.scrollViewLocation.backgroundColor = [Styles shared].editView.panelBackgroundColor;
	
	self.locationTypeTableView.frame = locationTypeFrame;
	self.directionTableView.frame = directionFrame;
	
	self.viewWall.frame = self.viewPlaceHolder.frame;
	self.viewWall.backgroundColor = [Styles shared].editView.panelBackgroundColor;
	
	self.viewGraphics.frame = self.viewPlaceHolder.frame;
	self.viewGraphics.backgroundColor = [Styles shared].editView.panelBackgroundColor;
	
	self.viewAudio.frame = self.viewPlaceHolder.frame;
	self.viewAudio.backgroundColor = [Styles shared].editView.panelBackgroundColor;

	locationActions = [[NSArray alloc] initWithObjects:
                       [NSNumber numberWithInt: MALocationActionDoNothing],
                       [NSNumber numberWithInt: MALocationActionStart],
                       [NSNumber numberWithInt: MALocationActionEnd],
                       [NSNumber numberWithInt: MALocationActionStartOver],
                       [NSNumber numberWithInt: MALocationActionTeleport],
                       nil];
	
    locationActionLabels = [[NSArray alloc] initWithObjects: @"Do Nothing", @"Start", @"End", @"Start Over", @"Teleportation", nil];
	
	directionThetas = [[NSArray alloc] initWithObjects: [NSNumber numberWithInt: 0], [NSNumber numberWithInt: 90], [NSNumber numberWithInt: 180], [NSNumber numberWithInt: 270], nil];
	directionLabels = [[NSArray alloc] initWithObjects: @"North", @"East", @"South", @"West", nil];
	
	wallTypes = [[NSArray alloc] initWithObjects:
                 [NSNumber numberWithInt: MAWallNone],
                 [NSNumber numberWithInt: MAWallSolid],
                 [NSNumber numberWithInt: MAWallInvisible],
                 [NSNumber numberWithInt: MAWallFake],
                 nil];
	
    wallTypeLabels = [[NSArray alloc] initWithObjects: @"No Wall", @"Solid", @"Invisible", @"Fake", nil];
	
	// set table row heights
	[self.locationTypeTableView setRowHeight: (self.locationTypeTableView.frame.size.height - self.locationTypeTableView.sectionHeaderHeight) / locationActions.count];
	
	[self.directionTableView setRowHeight: (self.directionTableView.frame.size.height - self.directionTableView.sectionHeaderHeight) / directionThetas.count];

	[self.wallTypeTableView setRowHeight: (self.wallTypeTableView.frame.size.height - self.wallTypeTableView.sectionHeaderHeight) / wallTypes.count];
	
	[self.tableViewBackgroundSound setRowHeight: (self.tableViewBackgroundSound.frame.size.height - self.tableViewBackgroundSound.sectionHeaderHeight) / [Styles shared].editView.tableViewBackgroundSoundRows];

	self.messageDisplaysLabel.backgroundColor = [Styles shared].editView.panelBackgroundColor;
	
	[self initTexturesPopover];
	
	self.viewButtons.backgroundColor = [Styles shared].editView.viewButtonsBackgroundColor;
	
	self.lblMessage1.backgroundColor = [Styles shared].editView.messageBackgroundColor;
	self.lblMessage1.textColor = [Styles shared].editView.messageTextColor;
	
	self.lblMessage2.backgroundColor = [Styles shared].editView.messageBackgroundColor;
	self.lblMessage2.textColor = [Styles shared].editView.messageTextColor;
	
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

	locationsVisited = [[NSMutableArray alloc] init];
	
    #ifndef DEBUG
    if ([Settings shared].useTutorial == YES)
    {
        [self animateScrollView];
    }
    #endif
    
	[self setup];
}

- (void)initTexturesPopover
{
	TexturesViewController *viewControllerTextures = [[TexturesViewController alloc] init];
	
	popoverControllerTextures = [[UIPopoverController alloc] initWithContentViewController: viewControllerTextures];
	
	popoverControllerTextures.popoverContentSize = CGSizeMake([Styles shared].editView.popoverTexturesWidth, [Styles shared].editView.popoverTexturesHeight);
    popoverControllerTextures.delegate = self;
}

- (void)animateScrollView
{/*
	float contentOffsetX = scrollView.contentOffset.x;
	
	[UIView animateWithDuration: 2.0
					 animations:^
					 {
						 scrollView.contentOffset = CGPointMake(scrollView.contentSize.width - scrollView.frame.size.width, scrollView.contentOffset.y); 
					 }
					 completion:^
					 (BOOL finished)
					 {
						 [UIView animateWithDuration: 2.0
										  animations:^
										  { 
											  scrollView.contentOffset = CGPointMake(contentOffsetX, scrollView.contentOffset.y); 
										  }];
					 }];
	*/
}

- (void)viewWillAppear: (BOOL)animated
{
	[super viewWillAppear: animated];
	
	[self.gridView setNeedsDisplay];
	
	if (self.maze.rows == 0 && self.maze.columns == 0)
    {
		[self.navigationController pushViewController: [CreateViewController shared] animated: NO];
    }
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
	
	[self.tableViewBackgroundSound reloadData];
	
	self.textViewMessage.editable = NO;
	self.textViewMessage.text = @"";
	
	self.messageDisplaysLabel.text = @"";
	
	self.textFieldName.text = self.maze.name;
	
	self.switchPublic.on = self.maze.public;
		
	self.switchTutorial.on = [Settings shared].useTutorial;
	
	currLoc = nil;
	prevLoc = nil;
	
	currWallLoc = nil;
	self.gridView.currWallLoc = currWallLoc;
	
	currWallDir = 0;
	self.gridView.currWallDir = currWallDir;
	
	[self setupLocationPanel];
	[self setupWallPanel];
	[self setupGraphicsPanel];
	
	[locationsVisited removeAllObjects];
	
	[self showTutorialHelpForTopic: @"Start"];	
}

//
//   TAB BAR
//

- (IBAction)btnMainTouchDown: (id)sender
{
	[self setupTabBarWithSelectedIndex: 1];
}

- (IBAction)btnLocationTouchDown: (id)sender
{
	[self setupTabBarWithSelectedIndex: 2];
}

- (IBAction)btnWallTochhDown: (id)sender
{
	[self setupTabBarWithSelectedIndex: 3];
}

- (IBAction)btnGraphicsTouchDown: (id)sender
{
	[self setupTabBarWithSelectedIndex: 4];
}

- (IBAction)btnAudioTouchDown: (id)sender
{
	[self setupTabBarWithSelectedIndex: 5];
}

- (void)setupTabBarWithSelectedIndex: (int)selectedIndex
{
	self.btnMain.backgroundColor = [Styles shared].editView.tabDarkColor;
	self.btnLocation.backgroundColor = [Styles shared].editView.tabDarkColor;
	self.btnWall.backgroundColor = [Styles shared].editView.tabDarkColor;
	self.btnGraphics.backgroundColor = [Styles shared].editView.tabDarkColor;
	self.btnAudio.backgroundColor = [Styles shared].editView.tabDarkColor;

	if (selectedIndex == 1)
	{
		self.btnMain.backgroundColor = [Styles shared].editView.panelBackgroundColor;
		
		[self.view bringSubviewToFront: self.viewMain];
	}
	else if (selectedIndex == 2)
	{
		self.btnLocation.backgroundColor = [Styles shared].editView.panelBackgroundColor;
		
		[self.view bringSubviewToFront: self.scrollViewLocation];
	}
	else if (selectedIndex == 3)
	{
		self.btnWall.backgroundColor = [Styles shared].editView.panelBackgroundColor;
		
		[self.view bringSubviewToFront: self.viewWall];
	}
	else if (selectedIndex == 4)
	{
		self.btnGraphics.backgroundColor = [Styles shared].editView.panelBackgroundColor;
		
		[self.view bringSubviewToFront: self.viewGraphics];
	}
	else if (selectedIndex == 5)
	{
		self.btnAudio.backgroundColor = [Styles shared].editView.panelBackgroundColor;
		
		[self.view bringSubviewToFront: self.viewAudio];
	}
}

//
//   USER TAPS SCREEN
//

- (void)handleTapFrom: (UITapGestureRecognizer *)recognizer 
{
	CGPoint touchPoint = [recognizer locationInView: self.gridView];

	MAMazeObjectType segType = 0;
	Location *location = [self.maze.locations getGridWallLocationSegType: &segType 
                                                          fromTouchPoint: touchPoint
                                                                    rows: self.maze.rows
                                                                 columns: self.maze.columns];

	if (location != nil)
	{
		currWallLoc = location;
		self.gridView.currWallLoc = currWallLoc;
		
		[self setupTabBarWithSelectedIndex: 3];
		
		if (segType == MAMazeObjectWallNorth)
        {
			currWallDir = MADirectionNorth;
        }
		else if (segType == MAMazeObjectWallWest)
        {
			currWallDir = MADirectionWest;
        }
	
		self.gridView.currWallDir = currWallDir;
		
		if ([self.maze.locations isInnerWallWithLocation: location rows: self.maze.rows columns: self.maze.columns wallDir: currWallDir] == YES)
		{
			[self setTableView: self.wallTypeTableView disabled:	NO];
			
			MAWallType oldWallType = [self.maze.locations getWallTypeLocX: currWallLoc.x locY: currWallLoc.y direction: currWallDir];
			
			MAWallType newWallType = 0;
			if (oldWallType == MAWallNone)
            {
				newWallType = MAWallSolid;
            }
			else
            {
				newWallType = MAWallNone;
            }
            
			[self.maze.locations setWallTypeLocX: currWallLoc.x locY: currWallLoc.y direction: currWallDir type: newWallType];
			
			if ([self wallPassesTeleportationSurroundedCheck] == NO)
			{
				newWallType = oldWallType;
				
				[self.maze.locations setWallTypeLocX: currWallLoc.x locY: currWallLoc.y direction: currWallDir type: newWallType];
				
				[self teleportationSurroundedAlert];
			}
			
			[self setupWallTypeTableViewWallType: newWallType];
			
			[self showTutorialHelpForTopic: @"WallTypes"];
		}
		else 
		{
			[self setTableView: self.wallTypeTableView disabled:	YES];

			int wallType = [self.maze.locations getWallTypeLocX: currWallLoc.x locY: currWallLoc.y direction: currWallDir];

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

		Location *location = [self.maze.locations getGridLocationFromTouchPoint: touchPoint rows: self.maze.rows columns: self.maze.columns];
		
		if (location != nil)
		{			
			[self locationChangedToCoord: CGPointMake(location.x, location.y)];
		}
	}
}	

- (void)locationChangedToCoord: (CGPoint)coord
{
	[self setTableView: self.locationTypeTableView disabled: NO];
	
	Location *newLoc = [self.maze.locations getLocationByX: coord.x y: coord.y];
	
	BOOL setAsTeleportation = [self setNextLocationAsTeleportation];
	
	if (setAsTeleportation == YES && [self.maze.locations isSurroundedByWallsLocation: newLoc] == YES)
	{
		[self teleportationSurroundedAlert];
		return;
	}
		
	prevLoc = currLoc;
	currLoc = newLoc;
		
	[self setupTabBarWithSelectedIndex: 2];
		
	if (setAsTeleportation == YES)
	{
		[self resetCurrentLocation];
		
		prevLoc.teleportX = currLoc.x;
		prevLoc.teleportY = currLoc.y;
				
		currLoc.action = MALocationActionTeleport;
		currLoc.teleportId = prevLoc.teleportId;
		currLoc.teleportX = prevLoc.x;
		currLoc.teleportY = prevLoc.y;
		
		[self showTutorialHelpForTopic: @"TeleportDirection"];
	}
	else 
	{
		[self showTutorialHelpForTopic: @"LocationTypes"];	
	}
		
	[self setupLocationActionTableViewLocationAction: currLoc.action theta: currLoc.direction];
	
	self.textViewMessage.editable = YES;
	
	// set Message
	[self.textViewMessage resignFirstResponder];
	self.textViewMessage.text = currLoc.message;

	[self setupLocationPanel];
	
	self.gridView.currLoc = currLoc;
	[self.gridView setNeedsDisplay];
}

- (BOOL)setNextLocationAsTeleportation
{
	BOOL setAsTeleportation = NO;
	
	if (currLoc != nil && currLoc.action == MALocationActionTeleport && currLoc.teleportX == 0 && currLoc.teleportY == 0)
    {
		setAsTeleportation = YES;
	}
    
	return setAsTeleportation;
}

//
//	LOCATION TYPES
//

- (UIView *)tableView: (UITableView *)tableView viewForHeaderInSection: (NSInteger)section 
{
	UIView *headerView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, tableView.bounds.size.width, tableView.sectionHeaderHeight)];

	UILabel *lblHeader = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, tableView.bounds.size.width, tableView.sectionHeaderHeight)];
	
	lblHeader.backgroundColor = [Styles shared].editView.tableHeaderBackgroundColor;
	lblHeader.font = [Styles shared].editView.tableHeaderFont;
	lblHeader.textColor = [Styles shared].editView.tableHeaderTextColor;
	lblHeader.textAlignment = [Styles shared].editView.tableHeaderTextAlignment;
	
	if (tableView.tag == 1)
	{
		lblHeader.text = @"Location Type";
	}
	else if (tableView.tag == 2)
	{
		lblHeader.text = @"Direction";
	}
	else if (tableView.tag == 3)
	{
		lblHeader.text = @"Wall Type";
	}
	else if (tableView.tag == 4)
	{
		lblHeader.text = @"Background";
	}
	
	[headerView addSubview: lblHeader];
	
	return headerView;
}

- (NSInteger)numberOfSectionsInTableView: (UITableView *)tableView 
{
	int sections = 0;
	
	if (tableView.tag == 1)
	{
		sections =  1;
	}
	else if (tableView.tag == 2)
	{
		sections = 1;
	}
	else if (tableView.tag == 3)
	{
		sections = 1;
	}
	else if (tableView.tag == 4)
	{
		sections = 1;
	}
	
	return sections;
}

- (NSInteger)tableView: (UITableView *)tableView numberOfRowsInSection: (NSInteger)section 
{
	int rows = 0;
	
	if (tableView.tag == 1)
	{
		rows = locationActions.count;
	}
	else if (tableView.tag == 2)
	{
		rows = directionThetas.count;
	}
	else if (tableView.tag == 3)
	{
		rows = wallTypes.count;
	}
	else if (tableView.tag == 4)
	{
		rows = [Sounds shared].count + 1;
	}
	
	return rows;
}

- (UITableViewCell *)tableView: (UITableView *)tableView cellForRowAtIndexPath: (NSIndexPath *)indexPath 
{    
	UITableViewCell *cell = nil;
	
	if (tableView.tag == 1)
	{
		static NSString *CellIdentifier = @"LocationTypeTableViewCell";
	
		cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
	
		if (cell == nil)
        {
			cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
        }
        
		[cell.textLabel setText: [locationActionLabels objectAtIndex: indexPath.row]];
		cell.textLabel.font = [Styles shared].defaultFont;
	}
	else if (tableView.tag == 2)
	{
		static NSString *CellIdentifier = @"DirectionTableViewCell";
		
		cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
		
		if (cell == nil)
        {
			cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
		}
        
		[cell.textLabel setText: [directionLabels objectAtIndex: indexPath.row]];
		cell.textLabel.font = [Styles shared].defaultFont;
		
		// add directional arrows to table
		
		float directionArrowLength = self.directionTableView.rowHeight * 0.6;
		UIImage *directionArrowImage = [Utilities createDirectionArrowImageWidth: directionArrowLength height: directionArrowLength];
		
		cell.imageView.contentMode = UIViewContentModeCenter;
		cell.imageView.image = directionArrowImage;
		
		CGFloat angleDegrees = [[directionThetas objectAtIndex: indexPath.row] floatValue];
		[Utilities rotateImageView: cell.imageView angleDegrees: angleDegrees];
	}
	else if (tableView.tag == 3)
	{
		static NSString *CellIdentifier = @"WallTypeTableViewCell";
		
		cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
		
		if (cell == nil)
        {
			cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
		}
        
		[cell.textLabel setText: [wallTypeLabels objectAtIndex: indexPath.row]];
		cell.textLabel.font = [Styles shared].defaultFont;
	}
	else if (tableView.tag == 4)
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
			
			if (self.maze.backgroundSoundId == 0)
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
			NSArray	*backgroundSounds = [[Sounds shared] sortedByName];
		
			Sound *sound = [backgroundSounds objectAtIndex: indexPath.row - 1];
		
			[cell.textLabel setText: sound.name];

			if (self.maze.backgroundSoundId == [sound.id intValue])
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
	
	if (tableView.tag == 1)
	{
		MALocationActionType action = [[locationActions objectAtIndex: indexPath.row] intValue];

		if (action == MALocationActionDoNothing)
		{
			[self resetCurrentLocation];

			[self showTutorialHelpForTopic: @"None"];
		}
		if (action == MALocationActionStart)
		{
			[self resetCurrentLocation];

			Location *startLoc = [self.maze.locations getLocationByAction: MALocationActionStart];
			
			if (startLoc != nil)
            {
				[startLoc reset];
			}
            
			[self showTutorialHelpForTopic: @"StartDirection"];
		}
		else if (action == MALocationActionEnd)
		{
			[self resetCurrentLocation];

			Location *endLoc = [self.maze.locations getLocationByAction: MALocationActionEnd];
			
			if (endLoc != nil)
            {
				[endLoc reset];
            }
            
            [self showTutorialHelpForTopic: @"None"];			
		}
		else if (action == MALocationActionStartOver)
		{
			[self resetCurrentLocation];
			
			[self showTutorialHelpForTopic: @"None"];			
		}
		else if (action == MALocationActionTeleport)
		{
			if ([self.maze.locations isSurroundedByWallsLocation: currLoc])
			{
				[self teleportationSurroundedAlert];
				
				[self.locationTypeTableView deselectRowAtIndexPath: indexPath animated: YES];
				return;
			}
			
			currLoc.TeleportId = [self getNextTeleportId];
			
			[self showTutorialHelpForTopic: @"TeleportTwin"];
		}

		currLoc.action = action;
		
		[self setupLocationActionTableViewLocationAction: currLoc.action theta: currLoc.direction];
	}
	else if (tableView.tag == 2)
	{
		currLoc.Direction = [[directionThetas objectAtIndex: indexPath.row] intValue];
		
		[self setupDirectionTableViewLocationAction: currLoc.action theta: currLoc.direction];
	}	
	else if (tableView.tag == 3)
	{
		MAWallType oldWallType = [self.maze.locations getWallTypeLocX: currWallLoc.x locY: currWallLoc.y direction: currWallDir];
		
		MAWallType newWallType = [[wallTypes objectAtIndex: indexPath.row] intValue];
		
		[self.maze.locations setWallTypeLocX: currWallLoc.x locY: currWallLoc.y direction: currWallDir type: newWallType];
		
		if ([self wallPassesTeleportationSurroundedCheck] == NO)
		{
			[self.maze.locations setWallTypeLocX: currWallLoc.x locY: currWallLoc.y direction: currWallDir type: oldWallType];
		
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
	else if (tableView.tag == 4)
	{
		NSArray	*backgroundSounds = [[Sounds shared] sortedByName];
		
		// previous
		
		int row = 0;
		if (self.maze.backgroundSoundId == 0)
		{
			row = 0;
		}
		else 
		{
			[self stopBackgroundSound];
			
			Sound *sound = [[Sounds shared] soundWithId: self.maze.backgroundSoundId];
			
			row = [backgroundSounds indexOfObject: sound] + 1;
		}
		
		NSIndexPath	*prevIndexPath = [NSIndexPath indexPathForRow: row inSection: 0];	
		UITableViewCell *prevCell = [self.tableViewBackgroundSound cellForRowAtIndexPath: prevIndexPath]; 
		
		prevCell.accessoryType = UITableViewCellAccessoryNone;
		
		// current
		
		if (indexPath.row == 0)
		{
			self.maze.backgroundSoundId = 0;
		}
		else 
		{
			Sound *sound = [backgroundSounds objectAtIndex: indexPath.row - 1];
			
			self.maze.backgroundSoundId = [sound.id intValue];
			
			[sound playWithNumberOfLoops: 0];
		}
		
		UITableViewCell *cell = [self.tableViewBackgroundSound cellForRowAtIndexPath: indexPath];
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
		
		[self.tableViewBackgroundSound deselectRowAtIndexPath: indexPath animated: YES];	
	}	
	
	[self.gridView setNeedsDisplay];
}

- (void)resetCurrentLocation
{
	if (currLoc.action == MALocationActionTeleport)
	{
		[self showTutorialHelpForTopic: @"None"];
		
		Location *teleportLoc = [self.maze.locations getLocationByX: currLoc.teleportX y: currLoc.teleportY];

		if (teleportLoc != nil)
			[teleportLoc reset];
	}

	[currLoc reset];
}

- (int)getNextTeleportId
{
	BOOL idexists;
	int teleportId = 0;
	do 
	{
		teleportId = teleportId + 1;
		
		idexists = NO;
		for (Location *loc in [self.maze.locations all])
		{
			if (loc.teleportId == teleportId)
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
	
	int row = [locationActions indexOfObject: [NSNumber numberWithInt: locationAction]];
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
		   
		int row = [directionThetas indexOfObject: [NSNumber numberWithInt: theta]];
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
            [Utilities logWithClass: [self class] format: @"locationAction set to an illegal value: %d", locationAction];
            break;
    }
}

- (void)setupWallTypeTableViewWallType: (int)wallType
{
	[self clearAccessoriesInTableView: self.wallTypeTableView];
	
	int row = [wallTypes indexOfObject: [NSNumber numberWithInt: wallType]];
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
			cell.accessoryType = UITableViewCellAccessoryNone;
	}
}

- (BOOL)wallPassesTeleportationSurroundedCheck
{
	BOOL passes = YES;
	
	Location *location1 = nil;
	Location *location2 = nil;

	if (currWallDir == MADirectionNorth)
	{
		location1 = [self.maze.locations getLocationByX: currWallLoc.x y: currWallLoc.y];
		location2 = [self.maze.locations getLocationByX: currWallLoc.x y: currWallLoc.y - 1];
	}
	else if (currWallDir == MADirectionWest)
	{
		location1 = [self.maze.locations getLocationByX: currWallLoc.x y: currWallLoc.y];
		location2 = [self.maze.locations getLocationByX: currWallLoc.x - 1 y: currWallLoc.y];
	}

	if ((location1.action == MALocationActionTeleport && [self.maze.locations isSurroundedByWallsLocation: location1] == YES) ||
		(location2.action == MALocationActionTeleport && [self.maze.locations isSurroundedByWallsLocation: location2] == YES))
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
	if (self.switchPublic.on == YES)
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
	[locationsVisited removeAllObjects];
	exists = NO;
	
	Location *startLoc = [self.maze.locations getLocationByAction: MALocationActionStart];
	[self findExitLocation: startLoc];
	
	return exists;
}

- (void)findExitLocation: (Location *)location
{
	if ([locationsVisited indexOfObject: location] == NSNotFound)
		[locationsVisited addObject: location];
	else
		return;
		
	if (location.action == MALocationActionEnd)
    {
		exists = YES;
    }
    
	if (exists == YES || location.action == MALocationActionStartOver)
    {
		return;
    }
    
	MAWallType wallType;
	
	wallType = [self.maze.locations getWallTypeLocX: location.x locY: location.y direction: MADirectionNorth];
	if (wallType == MAWallNone || wallType == MAWallFake)
	{
		Location *newLocation = [self.maze.locations getLocationByX: location.x y: location.y - 1];
		[self findExitLocation: newLocation];
	}
		 
	wallType = [self.maze.locations getWallTypeLocX: location.x locY: location.y direction: MADirectionEast];
	if (wallType == MAWallNone || wallType == MAWallFake)
	{
		Location *newLocation = [self.maze.locations getLocationByX: location.x + 1 y: location.y];
		[self findExitLocation: newLocation];
	}
	
	wallType = [self.maze.locations getWallTypeLocX: location.x locY: location.y direction: MADirectionSouth];
	if (wallType == MAWallNone || wallType == MAWallFake)
	{
		Location *newLocation = [self.maze.locations getLocationByX: location.x y: location.y + 1];
		[self findExitLocation: newLocation];
	}
	
	wallType = [self.maze.locations getWallTypeLocX: location.x locY: location.y direction: MADirectionWest];
	if (wallType == MAWallNone || wallType == MAWallFake)
	{
		Location *newLocation = [self.maze.locations getLocationByX: location.x - 1 y: location.y];
		[self findExitLocation: newLocation];
	}
	
	if (location.action == MALocationActionTeleport)
	{
		Location *newLocation = [self.maze.locations getLocationByX: location.teleportX y: location.teleportY];
		[self findExitLocation: newLocation];
	}
}

//
//   LOCATION PANEL
//

- (void)setupLocationPanel
{
	if (currLoc != nil)
	{
		if (popoverControllerTextures.popoverVisible == YES)
			[popoverControllerTextures dismissPopoverAnimated: YES];
		
		int floorTextureId = 0;
		if (currLoc.floorTextureId != 0)
		{
			floorTextureId = currLoc.floorTextureId;
		}
		else
		{
			floorTextureId = self.maze.floorTextureId;
		}

		Texture *floorTexture = [[Textures shared] textureWithId: floorTextureId];
		
		self.imageViewFloor.image = [UIImage imageNamed: [floorTexture.name stringByAppendingString: @".png"]];

		int ceilingTextureId = 0;
		if (currLoc.ceilingTextureId != 0)
		{
			ceilingTextureId = currLoc.ceilingTextureId;
		}
		else
		{
			ceilingTextureId = self.maze.ceilingTextureId;
		}
		
		Texture *ceilingTexture = [[Textures shared] textureWithId: ceilingTextureId];
		
		self.imageViewCeiling.image = [UIImage imageNamed: [ceilingTexture.name stringByAppendingString: @".png"]];
	}
	else 
	{
		self.imageViewFloor.backgroundColor = [Styles shared].editView.panelBackgroundColor;

		self.imageViewCeiling.backgroundColor = [Styles shared].editView.panelBackgroundColor;
	}	
}

- (IBAction)btnFloorTouchDown
{
	if (currLoc != nil)
	{
		TexturesViewController *texturesViewController = (TexturesViewController *)popoverControllerTextures.contentViewController;
		
		texturesViewController.textureDelegate = currLoc;
		texturesViewController.textureSelector = @selector(setFloorTextureIdWithNumber:);
		texturesViewController.exitDelegate = self;
		texturesViewController.exitSelector = @selector(setupLocationPanel);
		
		[self->popoverControllerTextures presentPopoverFromRect: self.imageViewFloor.frame inView: self.scrollViewLocation permittedArrowDirections: UIPopoverArrowDirectionAny animated: YES];
	}
}

- (IBAction)btnCeilingTouchDown
{
	if (currLoc != nil)
	{
		TexturesViewController *texturesViewController = (TexturesViewController *)popoverControllerTextures.contentViewController;
		
		texturesViewController.textureDelegate = currLoc;
		texturesViewController.textureSelector = @selector(setCeilingTextureIdWithNumber:);
		texturesViewController.exitDelegate = self;
		texturesViewController.exitSelector = @selector(setupLocationPanel);
		
		[self->popoverControllerTextures presentPopoverFromRect: self.imageViewCeiling.frame inView: self.scrollViewLocation permittedArrowDirections: UIPopoverArrowDirectionAny animated: YES];
	}
}

//
//   WALL PANEL
//

- (void)setupWallPanel
{
	if (currWallLoc != nil)
	{
		if (popoverControllerTextures.popoverVisible == YES)
			[popoverControllerTextures dismissPopoverAnimated: YES];
		
		int locationTextureId = 0, textureId = 0;
		
		if (currWallDir == MADirectionNorth)
		{
			locationTextureId = currWallLoc.wallNorthTextureId;
		}
		else if (currWallDir == MADirectionWest)
		{
			locationTextureId = currWallLoc.wallWestTextureId;			
		}
		
		if (locationTextureId != 0)
		{
			textureId = locationTextureId;
		}
		else 
		{
			textureId = self.maze.wallTextureId;			
		}
						
		Texture *texture = [[Textures shared] textureWithId: textureId];
		
		self.imageViewWall.image = [UIImage imageNamed: [texture.name stringByAppendingString: @".png"]];
	}
	else 
	{
		self.imageViewWall.backgroundColor = [Styles shared].editView.panelBackgroundColor;
	}
}

- (void)btnWallTouchDown
{
	if (currWallLoc != nil)
	{
		TexturesViewController *texturesViewController = (TexturesViewController *)popoverControllerTextures.contentViewController;
		
		texturesViewController.textureDelegate = currWallLoc;
			
		if (currWallDir == MADirectionNorth)
        {
			texturesViewController.textureSelector = @selector(setWallNorthTextureIdWithNumber:);
        }
		else if (currWallDir == MADirectionWest)
        {
			texturesViewController.textureSelector = @selector(setWallWestTextureIdWithNumber:);
        }
			
		texturesViewController.exitDelegate = self;
		texturesViewController.exitSelector = @selector(setupWallPanel);
		
		[self->popoverControllerTextures presentPopoverFromRect: self.imageViewWall.frame inView: self.viewWall permittedArrowDirections: UIPopoverArrowDirectionAny animated: YES];
	}
}

//
//   GRAPHICS PANEL
//

- (void)setupGraphicsPanel
{	
	if (popoverControllerTextures.popoverVisible == YES)
		[popoverControllerTextures dismissPopoverAnimated: YES];
	
	Texture *wallTexture = [[Textures shared] textureWithId: self.maze.wallTextureId];
	self.imageViewWallDefault.image = [UIImage imageNamed: [wallTexture.name stringByAppendingString: @".png"]];
	
	Texture *floorTexture = [[Textures shared] textureWithId: self.maze.floorTextureId];
	self.imageViewFloorDefault.image = [UIImage imageNamed: [floorTexture.name stringByAppendingString: @".png"]];
	
	Texture *ceilingTexture = [[Textures shared] textureWithId: self.maze.ceilingTextureId];
	self.imageViewCeilingDefault.image = [UIImage imageNamed: [ceilingTexture.name stringByAppendingString: @".png"]];
}

- (void)btnWallDefaultTouchDown
{
	TexturesViewController *texturesViewController = (TexturesViewController *)popoverControllerTextures.contentViewController;
	
	texturesViewController.textureDelegate = self.maze;
	texturesViewController.textureSelector = @selector(setWallTextureIdWithNumber:);
	texturesViewController.exitDelegate = self;
	texturesViewController.exitSelector = @selector(setupGraphicsPanel);
	
	[self->popoverControllerTextures presentPopoverFromRect: self.imageViewWallDefault.frame inView: self.viewGraphics permittedArrowDirections: UIPopoverArrowDirectionAny animated: YES];
}

- (void)btnFloorDefaultTouchDown
{
	TexturesViewController *texturesViewController = (TexturesViewController *)popoverControllerTextures.contentViewController;
	
	texturesViewController.textureDelegate = self.maze;
	texturesViewController.textureSelector = @selector(setFloorTextureIdWithNumber:);
	texturesViewController.exitDelegate = self;
	texturesViewController.exitSelector = @selector(setupGraphicsPanel);
	
	[self->popoverControllerTextures presentPopoverFromRect: self.imageViewFloorDefault.frame inView: self.viewGraphics permittedArrowDirections: UIPopoverArrowDirectionAny animated: YES];
}

- (void)btnCeilingDefaultTouchDown
{
	TexturesViewController *texturesViewController = (TexturesViewController *)popoverControllerTextures.contentViewController;
	
	texturesViewController.textureDelegate = self.maze;
	texturesViewController.textureSelector = @selector(setCeilingTextureIdWithNumber:);
	texturesViewController.exitDelegate = self;
	texturesViewController.exitSelector = @selector(setupGraphicsPanel);
	
	[self->popoverControllerTextures presentPopoverFromRect: self.imageViewCeilingDefault.frame inView: self.viewGraphics permittedArrowDirections: UIPopoverArrowDirectionAny animated: YES];
}

//
//   AUDIO PANEL
//




//
//   SAVE
//

- (IBAction)save: (id)sender
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
	else 
	{
		self.maze.name = [self.textFieldName.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
		self.maze.public = self.switchPublic.on;
	}
	
	if (self.maze.id == 0)
	{
		[self createMaze];
	}
	else 
	{
		[self updateMaze];
	}
}	

- (void)createMaze
{
    /*
	comm = [[Communication alloc] initWithDelegate: self Selector: @selector(createMazeResponse) Action: @"CreateMaze" WaitMessage: @"Saving"];
	
	[XML addNodeDoc: comm.requestDoc Parent: [XML getRootNodeDoc: comm.requestDoc] NodeName: @"UserId" NodeValue: UNIQUE_ID];
	[XML addNodeDoc: comm.requestDoc Parent: [XML getRootNodeDoc: comm.requestDoc] NodeName: @"Name" NodeValue: [Globals instance].mazeEdit.name];
	[XML addNodeDoc: comm.requestDoc Parent: [XML getRootNodeDoc: comm.requestDoc] NodeName: @"Rows" NodeValue: [NSString stringWithFormat: @"%d", [Globals instance].mazeEdit.rows]];
	[XML addNodeDoc: comm.requestDoc Parent: [XML getRootNodeDoc: comm.requestDoc] NodeName: @"Columns" NodeValue: [NSString stringWithFormat: @"%d", [Globals instance].mazeEdit.columns]];	
	[XML addNodeDoc: comm.requestDoc Parent: [XML getRootNodeDoc: comm.requestDoc] NodeName: @"BackgroundSoundId" NodeValue: [NSString stringWithFormat: @"%d", [Globals instance].mazeEdit.backgroundSoundId]];
	[XML addNodeDoc: comm.requestDoc Parent: [XML getRootNodeDoc: comm.requestDoc] NodeName: @"WallTextureId" NodeValue: [NSString stringWithFormat: @"%d", [Globals instance].mazeEdit.wallTextureId]];
	[XML addNodeDoc: comm.requestDoc Parent: [XML getRootNodeDoc: comm.requestDoc] NodeName: @"FloorTextureId" NodeValue: [NSString stringWithFormat: @"%d", [Globals instance].mazeEdit.floorTextureId]];
	[XML addNodeDoc: comm.requestDoc Parent: [XML getRootNodeDoc: comm.requestDoc] NodeName: @"CeilingTextureId" NodeValue: [NSString stringWithFormat: @"%d", [Globals instance].mazeEdit.ceilingTextureId]];	
	[XML addNodeDoc: comm.requestDoc Parent: [XML getRootNodeDoc: comm.requestDoc] NodeName: @"IsPublic" NodeValue: [Globals instance].mazeEdit.isPublic == YES ? @"True" : @"False"];
	
	[comm post];
    */
}

- (void)createMazeResponse
{
    /*
	if (comm.errorOccurred == NO)
	{
		int retVal = [[XML getNodeValueFromDoc: comm.responseDoc Node: [XML getRootNodeDoc: comm.responseDoc] XPath: "/Response/RetVal"] intValue];
		
		if (retVal == [Constants shared].nameExists)
		{
			[self setupTabBarWithSelectedIndex: 1];
						
			NSString *message = [NSString stringWithFormat: @"There is already a maze with the name %@.", [Globals instance].mazeEdit.name];
			
			[Utilities ShowAlertWithDelegate: self Message: message CancelButtonTitle: @"OK" OtherButtonTitle: @"" Tag: 0 Bounds: CGRectZero];
		}
		else
		{
			[Globals instance].mazeEdit.mazeId = retVal;
			[[Globals instance].mazeEdit.locations UpdateMazeId: retVal];
			
			[self setLocations];
		}
	}
    */
}

- (void)updateMaze
{
    /*
	comm = [[Communication alloc] initWithDelegate: self Selector: @selector(updateMazeResponse) Action: @"UpdateMaze" WaitMessage: @"Saving"];

	[XML addNodeDoc: comm.requestDoc Parent: [XML getRootNodeDoc: comm.requestDoc] NodeName: @"MazeId" NodeValue: [NSString stringWithFormat: @"%d", [Globals instance].mazeEdit.mazeId]];
	[XML addNodeDoc: comm.requestDoc Parent: [XML getRootNodeDoc: comm.requestDoc] NodeName: @"Name" NodeValue: [Globals instance].mazeEdit.name];
	[XML addNodeDoc: comm.requestDoc Parent: [XML getRootNodeDoc: comm.requestDoc] NodeName: @"BackgroundSoundId" NodeValue: [NSString stringWithFormat: @"%d", [Globals instance].mazeEdit.backgroundSoundId]];
	[XML addNodeDoc: comm.requestDoc Parent: [XML getRootNodeDoc: comm.requestDoc] NodeName: @"WallTextureId" NodeValue: [NSString stringWithFormat: @"%d", [Globals instance].mazeEdit.wallTextureId]];
	[XML addNodeDoc: comm.requestDoc Parent: [XML getRootNodeDoc: comm.requestDoc] NodeName: @"FloorTextureId" NodeValue: [NSString stringWithFormat: @"%d", [Globals instance].mazeEdit.floorTextureId]];
	[XML addNodeDoc: comm.requestDoc Parent: [XML getRootNodeDoc: comm.requestDoc] NodeName: @"CeilingTextureId" NodeValue: [NSString stringWithFormat: @"%d", [Globals instance].mazeEdit.ceilingTextureId]];	
	[XML addNodeDoc: comm.requestDoc Parent: [XML getRootNodeDoc: comm.requestDoc] NodeName: @"IsPublic" NodeValue: [Globals instance].mazeEdit.isPublic == YES ? @"True" : @"False"];

	[comm post];
    */
}

- (void)updateMazeResponse
{
    /*
	if (comm.errorOccurred == NO)
	{
		int retVal = [[XML getNodeValueFromDoc: comm.responseDoc Node :[XML getRootNodeDoc: comm.responseDoc] XPath: "/Response/RetVal"] intValue];
		
		if (retVal == [Constants shared].nameExists)
		{
			[self setupTabBarWithSelectedIndex: 1];
						
			NSString *message = [NSString stringWithFormat: @"There is already a maze with the name %@.", [Globals instance].mazeEdit.name];
			
			[Utilities ShowAlertWithDelegate: self Message: message CancelButtonTitle: @"OK" OtherButtonTitle: @"" Tag: 0 Bounds: CGRectZero];
		}
		else 
		{
			[self setLocations];				
		}
	}
    */
}

- (void)setLocations
{
    /*
	comm = [[Communication alloc] initWithDelegate: self Selector: @selector(setLocationsResponse) Action: @"SetLocations" WaitMessage: @"Saving"];
	
	xmlNodePtr locationsNode = [[Globals instance].mazeEdit.locations CreateLocationsXMLWithDoc: comm.requestDoc];
	[XML AddChildNode: locationsNode ToParent: [XML getRootNodeDoc: comm.requestDoc]];
		
	[comm post];
    */
}

- (void)setLocationsResponse
{
}

//
//   FORM VALIDATION
//

- (BOOL)validate
{
	BOOL passed = YES; 
	
	NSString *mazeName = [self.textFieldName.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];

	Location *startLoc = [self.maze.locations getLocationByAction: MALocationActionStart];

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
	else if (self.switchPublic.on == YES)
	{
		Location *endLoc = [self.maze.locations getLocationByAction: MALocationActionEnd];
				
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

	if (self.switchPublic.on == YES && passed == NO)
    {
		[self.switchPublic setOn: NO animated: YES];
    }
    
	return passed;
}

//
//   DELETE
//

- (IBAction)delete: (id)sender
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
		
		if (self.maze.id != 0)
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
    /*
	comm = [[Communication alloc] initWithDelegate: self Selector: @selector(deleteMazeResponse) Action: @"SetMazeInactive" WaitMessage: @"Deleting"];
	
	[XML addNodeDoc: comm.requestDoc Parent: [XML getRootNodeDoc: comm.requestDoc] NodeName: @"MazeId" NodeValue: [NSString stringWithFormat: @"%d", [Globals instance].mazeEdit.mazeId]];
	
	[comm post];
    */
}

- (void)deleteMazeResponse
{
    /*
	if (comm.errorOccurred == NO)
	{			
		[self setupCreateView];
	}
    */
}

- (void)setupCreateView
{
	[self setup];
	
	[self.navigationController pushViewController: [CreateViewController shared] animated: NO];
}

- (IBAction)btnMazesTouchDown: (id)sender
{
	[self stopBackgroundSound];
	
	//[[MainListViewController shared] loadMazeList];
	
	[self.navigationController popViewControllerAnimated: NO];
}

- (void)stopBackgroundSound
{
	Sound *sound = [[Sounds shared] soundWithId: self.maze.backgroundSoundId];

	[sound stop];
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

		[self.textViewMessage resignFirstResponder];
	}
	else if (range.location >= [Constants shared].locationMessageMaxLength)
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
	currLoc.Message = [self.textViewMessage.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

// maze name

- (BOOL)textField: (UITextField *)textField shouldChangeCharactersInRange: (NSRange)range replacementString: (NSString *)string
{
	BOOL changeText = YES;
	
	NSRange rangeNewLine = [string rangeOfString: @"\n"];
	
	if (rangeNewLine.location != NSNotFound)
	{
		changeText = NO;
		
		[self.textFieldName resignFirstResponder];
	}
	else if (range.location >= [Constants shared].mazeNameMaxLength)
	{
		changeText = NO;
    }
	
	return changeText;
}

- (IBAction)swtichTutorialValueChanged: (id)sender
{
	if (self.switchTutorial.on == NO)
	{
		[self showTutorialHelpForTopic: @"None"];
	}
	
    [Settings shared].useTutorial = self.switchTutorial.on;
}

- (void)showTutorialHelpForTopic: (NSString *)topic
{
	if ([Settings shared].useTutorial == YES)
	{
		if (topic == @"None")
		{
			self.lblMessage1.text = @"";
			self.lblMessage2.text = @"";
		}
		else if (topic == @"Start")
		{
			self.lblMessage1.text = @"Tap on a wall (blue segment) to remove it or put it back.";
			self.lblMessage2.text = @"Tap and hold on a white square to select a location.";
		}
		else if (topic == @"WallTypes")
		{
			self.lblMessage1.text = @"Tap on the list above to select additional wall types.";
			self.lblMessage2.text = @"";
		}
		else if (topic == @"InvisibleWalls")
		{
			self.lblMessage1.text = @"An invisible wall is solid but can't be seen.";
			self.lblMessage2.text = @"A player can't pass through an invisible wall.";
		}
		else if (topic == @"FakeWalls")
		{
			self.lblMessage1.text = @"A fake wall looks like a normal wall but is not solid.";
			self.lblMessage2.text = @"A fake wall will disappear after a player passes through it.";
		}
		else if (topic == @"LocationTypes")
		{
			self.lblMessage1.text = @"Tap on the Location Type list to determine what will happen at this location.";
			self.lblMessage2.text = @"";
		}
		else if (topic == @"StartDirection")
		{
			self.lblMessage1.text = @"Tap on the Direction list to choose the direction the player will face when first entering";
			self.lblMessage2.text = @"the maze.";
		}
		else if (topic == @"TeleportTwin")
		{
			self.lblMessage1.text = @"Please select a second teleportation location.";
			self.lblMessage2.text = @"";
		}
		else if (topic == @"TeleportDirection")
		{
			self.lblMessage1.text = @"Tap on the Direction list to select the direction the player will face after being teleported to";
			self.lblMessage2.text = @"this location.";
		}
		else if (topic == @"LocationMessages")
		{
			self.lblMessage1.text = @"Type in a message to display to the player at this location. The message will either be displayed";
			self.lblMessage2.text = @"above the maze or in a pop-up depending on the type of location.";
		}
		else if (topic == @"MakePublic")
		{
			self.lblMessage1.text = @"Set Make Public to On to let everyone play your maze.";
			self.lblMessage2.text = @"If you have recently saved your maze it will appear at the top of the Newest list.";
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
