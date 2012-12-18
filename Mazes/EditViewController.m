//
//  EditViewController.m
//  iPad Mazes
//
//  Created by Andre Muis on 4/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EditViewController.h"

#import "Settings.h"
#import "Sounds.h"
#import "Sound.h"
#import "Textures.h"
#import "Texture.h"

@implementation EditViewController

@synthesize btnMain, btnLocation, btnWall, btnGraphics, btnAudio, viewPlaceHolder, viewMain, scrollViewLocation, viewWall, viewGraphics, viewAudio, textFieldName, switchPublic, switchTutorial, LocationTypeTableView, DirectionTableView, textViewMessage, MessageDisplaysLabel, WallTypeTableView, imageViewFloor, imageViewCeiling, imageViewWall, imageViewWallDefault, imageViewFloorDefault, imageViewCeilingDefault, tableViewBackgroundSound, viewButtons, lblMessage1, lblMessage2, gridView;

- (void)viewDidLoad 
{
    [super viewDidLoad];

	self.view.frame = CGRectMake(0.0, 0.0, 768.0, 1024.0);

	viewMain.frame = viewPlaceHolder.frame;
	viewMain.backgroundColor = [Styles shared].editView.panelBackgroundColor;
	
	CGRect locationTypeFrame = LocationTypeTableView.frame;
	CGRect directionFrame =	DirectionTableView.frame;
	
	scrollViewLocation.contentSize = scrollViewLocation.frame.size;
	scrollViewLocation.frame = viewPlaceHolder.frame;
	scrollViewLocation.backgroundColor = [Styles shared].editView.panelBackgroundColor;
	
	LocationTypeTableView.frame = locationTypeFrame;
	DirectionTableView.frame = directionFrame;
	
	viewWall.frame = viewPlaceHolder.frame;
	viewWall.backgroundColor = [Styles shared].editView.panelBackgroundColor;
	
	viewGraphics.frame = viewPlaceHolder.frame;
	viewGraphics.backgroundColor = [Styles shared].editView.panelBackgroundColor;
	
	viewAudio.frame = viewPlaceHolder.frame;
	viewAudio.backgroundColor = [Styles shared].editView.panelBackgroundColor;

	locationTypes = [[NSArray alloc] initWithObjects: [NSNumber numberWithInt: [Constants shared].LocationType.DoNothing], [NSNumber numberWithInt: [Constants shared].LocationType.Start], [NSNumber numberWithInt: [Constants shared].LocationType.End], [NSNumber numberWithInt: [Constants shared].LocationType.StartOver], [NSNumber numberWithInt: [Constants shared].LocationType.Teleportation], nil];
	locationTypeLabels = [[NSArray alloc] initWithObjects: @"Do Nothing", @"Start", @"End", @"Start Over", @"Teleportation", nil];
	
	directionThetas = [[NSArray alloc] initWithObjects: [NSNumber numberWithInt: 0], [NSNumber numberWithInt: 90], [NSNumber numberWithInt: 180], [NSNumber numberWithInt: 270], nil];
	directionLabels = [[NSArray alloc] initWithObjects: @"North", @"East", @"South", @"West", nil];
	
	wallTypes = [[NSArray alloc] initWithObjects: [NSNumber numberWithInt: [Constants shared].WallType.None], [NSNumber numberWithInt: [Constants shared].WallType.Solid], [NSNumber numberWithInt: [Constants shared].WallType.Invisible], [NSNumber numberWithInt: [Constants shared].WallType.Fake], nil];
	wallTypeLabels = [[NSArray alloc] initWithObjects: @"No Wall", @"Solid", @"Invisible", @"Fake", nil];
	
	// set table row heights
	[LocationTypeTableView setRowHeight: (LocationTypeTableView.frame.size.height - LocationTypeTableView.sectionHeaderHeight) / locationTypes.count];
	
	[DirectionTableView setRowHeight: (DirectionTableView.frame.size.height - DirectionTableView.sectionHeaderHeight) / directionThetas.count];

	[WallTypeTableView setRowHeight: (WallTypeTableView.frame.size.height - WallTypeTableView.sectionHeaderHeight) / wallTypes.count];
	
	[tableViewBackgroundSound setRowHeight: (tableViewBackgroundSound.frame.size.height - tableViewBackgroundSound.sectionHeaderHeight) / [Styles shared].editView.tableViewBackgroundSoundRows];

	MessageDisplaysLabel.backgroundColor = [Styles shared].editView.panelBackgroundColor;
	
	[self initTexturesPopover];
	
	viewButtons.backgroundColor = [Styles shared].editView.viewButtonsBackgroundColor;
	
	lblMessage1.backgroundColor = [Styles shared].editView.messageBackgroundColor;
	lblMessage1.textColor = [Styles shared].editView.messageTextColor;
	
	lblMessage2.backgroundColor = [Styles shared].editView.messageBackgroundColor;
	lblMessage2.textColor = [Styles shared].editView.messageTextColor;
	
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
		
    if ([Settings shared].useTutorial == YES)
    {
        [self animateScrollView];
    }
    
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
	
	[gridView setNeedsDisplay];
	
	if ([Globals shared].mazeEdit.rows == 0 && [Globals shared].mazeEdit.columns == 0)
    {
		[self.navigationController pushViewController: (UIViewController *)[Globals shared].createViewController animated: NO];
    }
}

- (void)setup
{
	[self setupTabBarWithSelectedIndex: 1];
	
	[self setTableView: LocationTypeTableView Disabled: YES];
	[self clearAccessoriesInTableView: LocationTypeTableView];
	
	[self setTableView: DirectionTableView Disabled: YES];
	[self clearAccessoriesInTableView: DirectionTableView];
		
	[self setTableView: WallTypeTableView Disabled: YES];
	[self clearAccessoriesInTableView: WallTypeTableView];
	
	[tableViewBackgroundSound reloadData];
	
	textViewMessage.editable = NO;
	textViewMessage.text = @"";
	
	MessageDisplaysLabel.text = @"";
	
	textFieldName.text = [Globals shared].mazeEdit.name;
	
	switchPublic.on = [Globals shared].mazeEdit.isPublic;
		
	switchTutorial.on = [Settings shared].useTutorial;
	
	currLoc = nil;
	prevLoc = nil;
	
	currWallLoc = nil;
	gridView.currWallLoc = currWallLoc;
	
	currWallDir = 0;
	gridView.currWallDir = currWallDir;
	
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
	btnMain.backgroundColor = [Styles shared].editView.tabDarkColor;
	btnLocation.backgroundColor = [Styles shared].editView.tabDarkColor;
	btnWall.backgroundColor = [Styles shared].editView.tabDarkColor;
	btnGraphics.backgroundColor = [Styles shared].editView.tabDarkColor;
	btnAudio.backgroundColor = [Styles shared].editView.tabDarkColor;

	if (selectedIndex == 1)
	{
		btnMain.backgroundColor = [Styles shared].editView.panelBackgroundColor;
		
		[self.view bringSubviewToFront: viewMain];
	}
	else if (selectedIndex == 2)
	{
		btnLocation.backgroundColor = [Styles shared].editView.panelBackgroundColor;
		
		[self.view bringSubviewToFront: scrollViewLocation];
	}
	else if (selectedIndex == 3)
	{
		btnWall.backgroundColor = [Styles shared].editView.panelBackgroundColor;
		
		[self.view bringSubviewToFront: viewWall];
	}
	else if (selectedIndex == 4)
	{
		btnGraphics.backgroundColor = [Styles shared].editView.panelBackgroundColor;
		
		[self.view bringSubviewToFront: viewGraphics];
	}
	else if (selectedIndex == 5)
	{
		btnAudio.backgroundColor = [Styles shared].editView.panelBackgroundColor;
		
		[self.view bringSubviewToFront: viewAudio];
	}
}

//
//   USER TAPS SCREEN
//

- (void)handleTapFrom: (UITapGestureRecognizer *)recognizer 
{
	CGPoint touchPoint = [recognizer locationInView: gridView];

	int segType = 0;
	Location *location = [[Globals shared].mazeEdit.locations getGridWallLocationSegType: &segType 
                                                                            FromTouchPoint: touchPoint 
                                                                                      Rows: [Globals shared].mazeEdit.rows 
                                                                                   Columns: [Globals shared].mazeEdit.columns];

	if (location != nil)
	{
		currWallLoc = location;
		gridView.currWallLoc = currWallLoc;
		
		[self setupTabBarWithSelectedIndex: 3];
		
		if (segType == [Constants shared].MazeObject.WallNorth)
        {
			currWallDir = [Constants shared].Direction.North;
        }
		else if (segType == [Constants shared].MazeObject.WallWest)
        {
			currWallDir = [Constants shared].Direction.West;
        }
	
		gridView.currWallDir = currWallDir;
		
		if ([[Globals shared].mazeEdit.locations IsInnerWallWithLocation: location Rows: [Globals shared].mazeEdit.rows Columns: [Globals shared].mazeEdit.columns WallDir: currWallDir] == YES)
		{
			[self setTableView: WallTypeTableView Disabled:	NO];
			
			int oldWallType = [[Globals shared].mazeEdit.locations getWallTypeLocX: currWallLoc.x LocY: currWallLoc.y Direction: currWallDir];
			
			int newWallType = 0;
			if (oldWallType == [Constants shared].WallType.None)
            {
				newWallType = [Constants shared].WallType.Solid;
            }
			else
            {
				newWallType = [Constants shared].WallType.None;
            }
            
			[[Globals shared].mazeEdit.locations setWallTypeLocX: currWallLoc.x LocY: currWallLoc.y Direction: currWallDir Type: newWallType];			
			
			if ([self WallPassesTeleportationSurroundedCheck] == NO)
			{
				newWallType = oldWallType;
				
				[[Globals shared].mazeEdit.locations setWallTypeLocX: currWallLoc.x LocY: currWallLoc.y Direction: currWallDir Type: newWallType];
				
				[self TeleportationSurroundedAlert];
			}
			
			[self SetupWallTypeTableViewWallType: newWallType];
			
			[self showTutorialHelpForTopic: @"WallTypes"];
		}
		else 
		{
			[self setTableView: WallTypeTableView Disabled:	YES];

			int wallType = [[Globals shared].mazeEdit.locations getWallTypeLocX: currWallLoc.x LocY: currWallLoc.y Direction: currWallDir];

			[self SetupWallTypeTableViewWallType: wallType];
		}
		
		[self setupWallPanel];

		[gridView setNeedsDisplay];
	}		
}

- (void)handleLongPressFrom: (UILongPressGestureRecognizer *)recognizer 
{
	if (recognizer.state == UIGestureRecognizerStateBegan)
	{
		CGPoint touchPoint = [recognizer locationInView: gridView];

		Location *location = [[Globals shared].mazeEdit.locations getGridLocationFromTouchPoint: touchPoint Rows: [Globals shared].mazeEdit.rows Columns: [Globals shared].mazeEdit.columns];
		
		if (location != nil)
		{			
			[self locationChangedToCoord: CGPointMake(location.x, location.y)];
		}
	}
}	

- (void)locationChangedToCoord: (CGPoint)coord
{
	[self setTableView: LocationTypeTableView Disabled: NO];
	
	Location *newLoc = [[Globals shared].mazeEdit.locations getLocationByX: coord.x Y: coord.y];
	
	BOOL setAsTeleportation = [self setNextLocationAsTeleportation];
	
	if (setAsTeleportation == YES && [[Globals shared].mazeEdit.locations IsSurroundedByWallsLocation: newLoc] == YES)
	{
		[self TeleportationSurroundedAlert];
		return;
	}
		
	prevLoc = currLoc;
	currLoc = newLoc;
		
	[self setupTabBarWithSelectedIndex: 2];
		
	if (setAsTeleportation == YES)
	{
		[self ResetCurrentLocation];
		
		prevLoc.teleportX = currLoc.x;
		prevLoc.teleportY = currLoc.y;
				
		currLoc.type = [Constants shared].LocationType.Teleportation;
		currLoc.teleportId = prevLoc.teleportId;
		currLoc.teleportX = prevLoc.x;
		currLoc.teleportY = prevLoc.y;
		
		[self showTutorialHelpForTopic: @"TeleportDirection"];
	}
	else 
	{
		[self showTutorialHelpForTopic: @"LocationTypes"];	
	}
		
	[self SetupLocationTypeTableViewLocationType: currLoc.type Theta: currLoc.direction];
	
	textViewMessage.editable = YES;
	
	// set Message
	[textViewMessage resignFirstResponder];
	textViewMessage.text = currLoc.message;

	[self setupLocationPanel];
	
	gridView.currLoc = currLoc;
	[gridView setNeedsDisplay];
}

- (BOOL)setNextLocationAsTeleportation
{
	BOOL setAsTeleportation = NO;
	
	if (currLoc != nil && currLoc.type == [Constants shared].LocationType.Teleportation && currLoc.teleportX == 0 && currLoc.teleportY == 0)
		setAsTeleportation = YES;
	
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
		rows = locationTypes.count;
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
        
		[cell.textLabel setText: [locationTypeLabels objectAtIndex: indexPath.row]];
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
		
		float directionArrowLength = DirectionTableView.rowHeight * 0.6;
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
			
			if ([Globals shared].mazeEdit.backgroundSoundId == 0)
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
			NSArray	*backgroundSounds = [[Sounds shared] getSoundsSorted];
		
			Sound *sound = [backgroundSounds objectAtIndex: indexPath.row - 1];
		
			[cell.textLabel setText: sound.name];

			if ([Globals shared].mazeEdit.backgroundSoundId == [sound.id intValue])
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
		int locationType = [[locationTypes objectAtIndex: indexPath.row] intValue];

		if (locationType == [Constants shared].LocationType.DoNothing)
		{
			[self ResetCurrentLocation];

			[self showTutorialHelpForTopic: @"None"];
		}
		if (locationType == [Constants shared].LocationType.Start)
		{
			[self ResetCurrentLocation];

			Location *startLoc = [[Globals shared].mazeEdit.locations getLocationByType: [Constants shared].LocationType.Start];
			
			if (startLoc != nil)
            {
				[startLoc reset];
			}
            
			[self showTutorialHelpForTopic: @"StartDirection"];
		}
		else if (locationType == [Constants shared].LocationType.End)
		{
			[self ResetCurrentLocation];

			Location *endLoc = [[Globals shared].mazeEdit.locations getLocationByType: [Constants shared].LocationType.End];
			
			if (endLoc != nil)
            {
				[endLoc reset];
            }
            
            [self showTutorialHelpForTopic: @"None"];			
		}
		else if (locationType == [Constants shared].LocationType.StartOver)
		{
			[self ResetCurrentLocation];
			
			[self showTutorialHelpForTopic: @"None"];			
		}
		else if (locationType == [Constants shared].LocationType.Teleportation)
		{
			if ([[Globals shared].mazeEdit.locations IsSurroundedByWallsLocation: currLoc])
			{
				[self TeleportationSurroundedAlert];
				
				[LocationTypeTableView deselectRowAtIndexPath: indexPath animated: YES];
				return;
			}
			
			currLoc.TeleportId = [self GetNextTeleportId];
			
			[self showTutorialHelpForTopic: @"TeleportTwin"];
		}

		currLoc.Type = locationType;
		
		[self SetupLocationTypeTableViewLocationType: currLoc.type Theta: currLoc.direction];
	}
	else if (tableView.tag == 2)
	{
		currLoc.Direction = [[directionThetas objectAtIndex: indexPath.row] intValue];
		
		[self SetupDirectionTableViewLocationType: currLoc.type Theta: currLoc.direction];
	}	
	else if (tableView.tag == 3)
	{
		int oldWallType = [[Globals shared].mazeEdit.locations getWallTypeLocX: currWallLoc.x LocY: currWallLoc.y Direction: currWallDir];
		
		int newWallType = [[wallTypes objectAtIndex: indexPath.row] intValue];
		
		[[Globals shared].mazeEdit.locations setWallTypeLocX: currWallLoc.x LocY: currWallLoc.y Direction: currWallDir Type: newWallType]; 
		
		if ([self WallPassesTeleportationSurroundedCheck] == NO)
		{
			[[Globals shared].mazeEdit.locations setWallTypeLocX: currWallLoc.x LocY: currWallLoc.y Direction: currWallDir Type: oldWallType]; 
		
			[WallTypeTableView deselectRowAtIndexPath: indexPath animated: YES];
			
			[self TeleportationSurroundedAlert];
		}
		else 
		{
			[self SetupWallTypeTableViewWallType: newWallType];
			
			if (newWallType == [Constants shared].WallType.Invisible)
            {
				[self showTutorialHelpForTopic: @"InvisibleWalls"];
            }
			else if (newWallType == [Constants shared].WallType.Fake)
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
		NSArray	*backgroundSounds = [[Sounds shared] getSoundsSorted];
		
		// previous
		
		int row = 0;
		if ([Globals shared].mazeEdit.backgroundSoundId == 0)
		{
			row = 0;
		}
		else 
		{
			[self stopBackgroundSound];
			
			Sound *sound = [[Sounds shared] getSoundWithId: [Globals shared].mazeEdit.backgroundSoundId];
			
			row = [backgroundSounds indexOfObject: sound] + 1;
		}
		
		NSIndexPath	*prevIndexPath = [NSIndexPath indexPathForRow: row inSection: 0];	
		UITableViewCell *prevCell = [tableViewBackgroundSound cellForRowAtIndexPath: prevIndexPath]; 
		
		prevCell.accessoryType = UITableViewCellAccessoryNone;
		
		// current
		
		if (indexPath.row == 0)
		{
			[Globals shared].mazeEdit.backgroundSoundId = 0;
		}
		else 
		{
			Sound *sound = [backgroundSounds objectAtIndex: indexPath.row - 1];
			
			[Globals shared].mazeEdit.backgroundSoundId = [sound.id intValue];
			
			[sound playWithNumberOfLoops: 0];
		}
		
		UITableViewCell *cell = [tableViewBackgroundSound cellForRowAtIndexPath: indexPath];
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
		
		[tableViewBackgroundSound deselectRowAtIndexPath: indexPath animated: YES];	
	}	
	
	[gridView setNeedsDisplay];
}

- (void)ResetCurrentLocation
{
	if (currLoc.type == [Constants shared].LocationType.Teleportation)
	{
		[self showTutorialHelpForTopic: @"None"];
		
		Location *teleportLoc = [[Globals shared].mazeEdit.locations getLocationByX: currLoc.teleportX Y: currLoc.teleportY];	

		if (teleportLoc != nil)
			[teleportLoc reset];
	}

	[currLoc reset];
}

- (int)GetNextTeleportId
{
	BOOL idexists;
	int teleportId = 0;
	do 
	{
		teleportId = teleportId + 1;
		
		idexists = NO;
		for (Location *loc in [Globals shared].mazeEdit.locations.array)
		{
			if (loc.teleportId == teleportId)
            {
				idexists = YES;
            }
		}		
	} while (idexists == YES);
		
	return teleportId;
}

- (void)SetupLocationTypeTableViewLocationType: (int)locationType Theta: (int)theta
{
	[self clearAccessoriesInTableView: LocationTypeTableView];
	
	int row = [locationTypes indexOfObject: [NSNumber numberWithInt: locationType]];
	NSIndexPath	*indexPath = [NSIndexPath indexPathForRow: row inSection: 0];

	UITableViewCell *cell = [LocationTypeTableView cellForRowAtIndexPath: indexPath];
	cell.accessoryType = UITableViewCellAccessoryCheckmark;

	[LocationTypeTableView deselectRowAtIndexPath: indexPath animated: YES];
	
	[self SetupDirectionTableViewLocationType: locationType Theta: theta];
	[self SetupMessageDisplaysLabelLocationType: locationType];
}

- (void)SetupDirectionTableViewLocationType: (int)locationType Theta: (int)theta
{
	[self clearAccessoriesInTableView: DirectionTableView];

	if (locationType == [Constants shared].LocationType.Start || locationType == [Constants shared].LocationType.Teleportation)
	{
		[self setTableView: DirectionTableView Disabled: NO];
		
		int row = [directionThetas indexOfObject: [NSNumber numberWithInt: theta]];
		NSIndexPath	*indexPath = [NSIndexPath indexPathForRow: row inSection: 0];

		UITableViewCell *cell = [DirectionTableView cellForRowAtIndexPath: indexPath];
		cell.accessoryType = UITableViewCellAccessoryCheckmark;

		[DirectionTableView deselectRowAtIndexPath: indexPath animated: YES];	
	}
	else 
	{
		[self setTableView: DirectionTableView Disabled: YES];
	}
}

- (void)SetupMessageDisplaysLabelLocationType: (int)locationType
{
	if (locationType == [Constants shared].LocationType.DoNothing)
		MessageDisplaysLabel.text = @"Above maze";
	else if (locationType == [Constants shared].LocationType.Start)
		MessageDisplaysLabel.text = @"Above maze";
	else if (locationType == [Constants shared].LocationType.End)
		MessageDisplaysLabel.text = @"In pop-up";
	else if (locationType == [Constants shared].LocationType.StartOver)
		MessageDisplaysLabel.text = @"In pop-up";
	else if (locationType == [Constants shared].LocationType.Teleportation)
		MessageDisplaysLabel.text = @"Above maze";
}

- (void)SetupWallTypeTableViewWallType: (int)wallType
{
	[self clearAccessoriesInTableView: WallTypeTableView];
	
	int row = [wallTypes indexOfObject: [NSNumber numberWithInt: wallType]];
	NSIndexPath	*indexPath = [NSIndexPath indexPathForRow: row inSection: 0];
	
	UITableViewCell *cell = [WallTypeTableView cellForRowAtIndexPath: indexPath];
	cell.accessoryType = UITableViewCellAccessoryCheckmark;
	
	[WallTypeTableView deselectRowAtIndexPath: indexPath animated: YES];	
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

- (BOOL)WallPassesTeleportationSurroundedCheck
{
	BOOL passes = YES;
	
	Location *location1 = nil;
	Location *location2 = nil;

	if (currWallDir == [Constants shared].Direction.North)
	{
		location1 = [[Globals shared].mazeEdit.locations getLocationByX: currWallLoc.x Y: currWallLoc.y];
		location2 = [[Globals shared].mazeEdit.locations getLocationByX: currWallLoc.x Y: currWallLoc.y - 1];			
	}
	else if (currWallDir == [Constants shared].Direction.West)
	{
		location1 = [[Globals shared].mazeEdit.locations getLocationByX: currWallLoc.x Y: currWallLoc.y];
		location2 = [[Globals shared].mazeEdit.locations getLocationByX: currWallLoc.x - 1 Y: currWallLoc.y];			
	}

	if ((location1.type == [Constants shared].LocationType.Teleportation && [[Globals shared].mazeEdit.locations IsSurroundedByWallsLocation: location1] == YES) ||
		(location2.type == [Constants shared].LocationType.Teleportation && [[Globals shared].mazeEdit.locations IsSurroundedByWallsLocation: location2] == YES))
	{
		passes = NO;
	}
	else 
	{
		passes = YES;
	}

	return passes;
}

- (void)TeleportationSurroundedAlert
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
	if (switchPublic.on == YES)
		[self validate];
	
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
	
	Location *startLoc = [[Globals shared].mazeEdit.locations getLocationByType: [Constants shared].LocationType.Start];
	[self findExitLocation: startLoc];
	
	return exists;
}

- (void)findExitLocation: (Location *)location
{
	if ([locationsVisited indexOfObject: location] == NSNotFound)
		[locationsVisited addObject: location];
	else
		return;
		
	if (location.type == [Constants shared].LocationType.End)
		exists = YES;

	if (exists == YES || location.type == [Constants shared].LocationType.StartOver)
    {
		return;
    }
    
	int wallType;
	
	wallType = [[Globals shared].mazeEdit.locations getWallTypeLocX: location.x LocY: location.y Direction: [Constants shared].Direction.North];
	if (wallType == [Constants shared].WallType.None || wallType == [Constants shared].WallType.Fake)
	{
		Location *newLocation = [[Globals shared].mazeEdit.locations getLocationByX: location.x Y: location.y - 1];
		[self findExitLocation: newLocation];
	}
		 
	wallType = [[Globals shared].mazeEdit.locations getWallTypeLocX: location.x LocY: location.y Direction: [Constants shared].Direction.East];
	if (wallType == [Constants shared].WallType.None || wallType == [Constants shared].WallType.Fake)
	{
		Location *newLocation = [[Globals shared].mazeEdit.locations getLocationByX: location.x + 1 Y: location.y];
		[self findExitLocation: newLocation];
	}
	
	wallType = [[Globals shared].mazeEdit.locations getWallTypeLocX: location.x LocY: location.y Direction: [Constants shared].Direction.South];
	if (wallType == [Constants shared].WallType.None || wallType == [Constants shared].WallType.Fake)
	{
		Location *newLocation = [[Globals shared].mazeEdit.locations getLocationByX: location.x Y: location.y + 1];
		[self findExitLocation: newLocation];
	}
	
	wallType = [[Globals shared].mazeEdit.locations getWallTypeLocX: location.x LocY: location.y Direction: [Constants shared].Direction.West];
	if (wallType == [Constants shared].WallType.None || wallType == [Constants shared].WallType.Fake)
	{
		Location *newLocation = [[Globals shared].mazeEdit.locations getLocationByX: location.x - 1 Y: location.y];
		[self findExitLocation: newLocation];
	}
	
	if (location.type == [Constants shared].LocationType.Teleportation)
	{
		Location *newLocation = [[Globals shared].mazeEdit.locations getLocationByX: location.teleportX Y: location.teleportY];
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
			floorTextureId = [Globals shared].mazeEdit.floorTextureId;
		}

		Texture *floorTexture = [[Textures shared] getTextureWithId: floorTextureId];
		
		imageViewFloor.image = [UIImage imageNamed: [floorTexture.name stringByAppendingString: @".png"]];

		int ceilingTextureId = 0;
		if (currLoc.ceilingTextureId != 0)
		{
			ceilingTextureId = currLoc.ceilingTextureId;
		}
		else
		{
			ceilingTextureId = [Globals shared].mazeEdit.ceilingTextureId;
		}
		
		Texture *ceilingTexture = [[Textures shared] getTextureWithId: ceilingTextureId];
		
		imageViewCeiling.image = [UIImage imageNamed: [ceilingTexture.name stringByAppendingString: @".png"]];
	}
	else 
	{
		imageViewFloor.backgroundColor = [Styles shared].editView.panelBackgroundColor;

		imageViewCeiling.backgroundColor = [Styles shared].editView.panelBackgroundColor;
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
		
		[popoverControllerTextures presentPopoverFromRect: imageViewFloor.frame inView: scrollViewLocation permittedArrowDirections: UIPopoverArrowDirectionAny animated: YES];
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
		
		[popoverControllerTextures presentPopoverFromRect: imageViewCeiling.frame inView: scrollViewLocation permittedArrowDirections: UIPopoverArrowDirectionAny animated: YES];
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
		
		if (currWallDir == [Constants shared].Direction.North)
		{
			locationTextureId = currWallLoc.wallNorthTextureId;
		}
		else if (currWallDir == [Constants shared].Direction.West)
		{
			locationTextureId = currWallLoc.wallWestTextureId;			
		}
		
		if (locationTextureId != 0)
		{
			textureId = locationTextureId;
		}
		else 
		{
			textureId = [Globals shared].mazeEdit.wallTextureId;			
		}
						
		Texture *texture = [[Textures shared] getTextureWithId: textureId];
		
		imageViewWall.image = [UIImage imageNamed: [texture.name stringByAppendingString: @".png"]];
	}
	else 
	{
		imageViewWall.backgroundColor = [Styles shared].editView.panelBackgroundColor;
	}
}

- (void)btnWallTouchDown
{
	if (currWallLoc != nil)
	{
		TexturesViewController *texturesViewController = (TexturesViewController *)popoverControllerTextures.contentViewController;
		
		texturesViewController.textureDelegate = currWallLoc;
			
		if (currWallDir == [Constants shared].Direction.North)
        {
			texturesViewController.textureSelector = @selector(setWallNorthTextureIdWithNumber:);
        }
		else if (currWallDir == [Constants shared].Direction.West)
        {
			texturesViewController.textureSelector = @selector(setWallWestTextureIdWithNumber:);
        }
			
		texturesViewController.exitDelegate = self;
		texturesViewController.exitSelector = @selector(setupWallPanel);
		
		[popoverControllerTextures presentPopoverFromRect: imageViewWall.frame inView: viewWall permittedArrowDirections: UIPopoverArrowDirectionAny animated: YES];
	}
}

//
//   GRAPHICS PANEL
//

- (void)setupGraphicsPanel
{	
	if (popoverControllerTextures.popoverVisible == YES)
		[popoverControllerTextures dismissPopoverAnimated: YES];
	
	Texture *wallTexture = [[Textures shared] getTextureWithId: [Globals shared].mazeEdit.wallTextureId];
	imageViewWallDefault.image = [UIImage imageNamed: [wallTexture.name stringByAppendingString: @".png"]];
	
	Texture *floorTexture = [[Textures shared] getTextureWithId: [Globals shared].mazeEdit.floorTextureId];
	imageViewFloorDefault.image = [UIImage imageNamed: [floorTexture.name stringByAppendingString: @".png"]];
	
	Texture *ceilingTexture = [[Textures shared] getTextureWithId: [Globals shared].mazeEdit.ceilingTextureId];
	imageViewCeilingDefault.image = [UIImage imageNamed: [ceilingTexture.name stringByAppendingString: @".png"]];	
}

- (void)btnWallDefaultTouchDown
{
	TexturesViewController *texturesViewController = (TexturesViewController *)popoverControllerTextures.contentViewController;
	
	texturesViewController.textureDelegate = [Globals shared].mazeEdit;
	texturesViewController.textureSelector = @selector(setWallTextureIdWithNumber:);
	texturesViewController.exitDelegate = self;
	texturesViewController.exitSelector = @selector(setupGraphicsPanel);
	
	[popoverControllerTextures presentPopoverFromRect: imageViewWallDefault.frame inView: viewGraphics permittedArrowDirections: UIPopoverArrowDirectionAny animated: YES];
}

- (void)btnFloorDefaultTouchDown
{
	TexturesViewController *texturesViewController = (TexturesViewController *)popoverControllerTextures.contentViewController;
	
	texturesViewController.textureDelegate = [Globals shared].mazeEdit;
	texturesViewController.textureSelector = @selector(setFloorTextureIdWithNumber:);
	texturesViewController.exitDelegate = self;
	texturesViewController.exitSelector = @selector(setupGraphicsPanel);
	
	[popoverControllerTextures presentPopoverFromRect: imageViewFloorDefault.frame inView: viewGraphics permittedArrowDirections: UIPopoverArrowDirectionAny animated: YES];
}

- (void)btnCeilingDefaultTouchDown
{
	TexturesViewController *texturesViewController = (TexturesViewController *)popoverControllerTextures.contentViewController;
	
	texturesViewController.textureDelegate = [Globals shared].mazeEdit;
	texturesViewController.textureSelector = @selector(setCeilingTextureIdWithNumber:);
	texturesViewController.exitDelegate = self;
	texturesViewController.exitSelector = @selector(setupGraphicsPanel);
	
	[popoverControllerTextures presentPopoverFromRect: imageViewCeilingDefault.frame inView: viewGraphics permittedArrowDirections: UIPopoverArrowDirectionAny animated: YES];
}

//
//   AUDIO PANEL
//




//
//   SAVE
//

- (IBAction)Save: (id)sender
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
		[Globals shared].mazeEdit.Name = [textFieldName.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
		[Globals shared].mazeEdit.IsPublic = switchPublic.on;
	}
	
	if ([Globals shared].mazeEdit.mazeId == 0)
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
	
	NSString *mazeName = [textFieldName.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];

	Location *startLoc = [[Globals shared].mazeEdit.locations getLocationByType: [Constants shared].LocationType.Start];

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
	else if (switchPublic.on == YES)
	{
		Location *endLoc = [[Globals shared].mazeEdit.locations getLocationByType: [Constants shared].LocationType.End];
				
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

	if (switchPublic.on == YES && passed == NO)
		[switchPublic setOn: NO animated: YES];

	return passed;
}

//
//   DELETE
//

- (IBAction)Delete: (id)sender
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
		
		if ([Globals shared].mazeEdit.mazeId != 0)
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
	[[Globals shared].mazeEdit reset];
	
	[self setup];
	
	[self.navigationController pushViewController: (UIViewController *)[Globals shared].createViewController animated: NO];
}

- (IBAction)btnMazesTouchDown: (id)sender
{
	[self stopBackgroundSound];
	
	[[MainListViewController shared] loadMazeList];
	
	[self.navigationController popViewControllerAnimated: NO];
}

- (void)stopBackgroundSound
{
	Sound *sound = [[Sounds shared] getSoundWithId: [Globals shared].mazeEdit.backgroundSoundId];

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

		[textViewMessage resignFirstResponder];
	}
	else if (range.location >= [Constants shared].locationMessageMaxLength)
	{
		if (rangeBackspace.location == NSNotFound)
			changeText = NO;
    }
	
	return changeText;
}

- (void)textViewDidEndEditing: (UITextView *)textView
{
	[gridView setNeedsDisplay];
}

- (void)textViewDidChange:(UITextView *)textView
{	
	currLoc.Message = [textViewMessage.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

// maze name

- (BOOL)textField: (UITextField *)textField shouldChangeCharactersInRange: (NSRange)range replacementString: (NSString *)string
{
	BOOL changeText = YES;
	
	NSRange rangeNewLine = [string rangeOfString: @"\n"];
	
	if (rangeNewLine.location != NSNotFound)
	{
		changeText = NO;
		
		[textFieldName resignFirstResponder];
	}
	else if (range.location >= [Constants shared].mazeNameMaxLength)
	{
		changeText = NO;
    }
	
	return changeText;
}

- (IBAction)swtichTutorialValueChanged: (id)sender
{
	if (switchTutorial.on == NO)
	{
		[self showTutorialHelpForTopic: @"None"];
	}
	
    [Settings shared].useTutorial = switchTutorial.on;
}

- (void)showTutorialHelpForTopic: (NSString *)topic
{
	if ([Settings shared].useTutorial == YES)
	{
		if (topic == @"None")
		{
			lblMessage1.text = @"";
			lblMessage2.text = @"";
		}
		else if (topic == @"Start")
		{
			lblMessage1.text = @"Tap on a wall (blue segment) to remove it or put it back.";
			lblMessage2.text = @"Tap and hold on a white square to select a location.";
		}
		else if (topic == @"WallTypes")
		{
			lblMessage1.text = @"Tap on the list above to select additional wall types.";
			lblMessage2.text = @"";
		}
		else if (topic == @"InvisibleWalls")
		{
			lblMessage1.text = @"An invisible wall is solid but can't be seen.";
			lblMessage2.text = @"A player can't pass through an invisible wall.";
		}
		else if (topic == @"FakeWalls")
		{
			lblMessage1.text = @"A fake wall looks like a normal wall but is not solid.";
			lblMessage2.text = @"A fake wall will disappear after a player passes through it.";
		}
		else if (topic == @"LocationTypes")
		{
			lblMessage1.text = @"Tap on the Location Type list to determine what will happen at this location.";
			lblMessage2.text = @"";
		}
		else if (topic == @"StartDirection")
		{
			lblMessage1.text = @"Tap on the Direction list to choose the direction the player will face when first entering";
			lblMessage2.text = @"the maze.";
		}
		else if (topic == @"TeleportTwin")
		{
			lblMessage1.text = @"Please select a second teleportation location.";
			lblMessage2.text = @"";
		}
		else if (topic == @"TeleportDirection")
		{
			lblMessage1.text = @"Tap on the Direction list to select the direction the player will face after being teleported to";
			lblMessage2.text = @"this location.";
		}
		else if (topic == @"LocationMessages")
		{
			lblMessage1.text = @"Type in a message to display to the player at this location. The message will either be displayed";
			lblMessage2.text = @"above the maze or in a pop-up depending on the type of location.";
		}
		else if (topic == @"MakePublic")
		{
			lblMessage1.text = @"Set Make Public to On to let everyone play your maze.";
			lblMessage2.text = @"If you have recently saved your maze it will appear at the top of the Newest list.";
		}
	}
}

- (void)setTableView: (UITableView *)tableView Disabled: (BOOL)disabled
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

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
	
	NSLog(@"Edit View Controller received a memory warning.");
}

@end
