//
//  MADesignViewController.m
//  Mazes
//
//  Created by Andre Muis on 4/30/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import "MADesignViewController.h"

#import "MAButton.h"
#import "MAColors.h"
#import "MAConstants.h"
#import "MACoordinate.h"
#import "MACreateViewController.h"
#import "MADesignScreenStyle.h"
#import "MAEventManager.h"
#import "MAEvent.h"
#import "MAFloorPlanView.h"
#import "MAFloorPlanViewController.h"
#import "MAFloorPlanViewDelegate.h"
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

@interface MADesignViewController ()  <
    MAFloorPlanViewDelegate,
    UITableViewDelegate,
    UITextViewDelegate,
    UITextFieldDelegate,
    UIAlertViewDelegate,
    UIPopoverControllerDelegate>

@property (readonly, strong, nonatomic) Reachability *reachability;
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

@property (readonly, strong, nonatomic) UIAlertView *invalidTeleportationLocationAlertView;
@property (readonly, strong, nonatomic) UIAlertView *selectSecondTeleportationLocationAlertView;
@property (readonly, strong, nonatomic) UIAlertView *mazeNameExistsAlertView;
@property (readonly, strong, nonatomic) UIAlertView *enterMazeNameAlertView;
@property (readonly, strong, nonatomic) UIAlertView *selectStartLocationAlertView;
@property (readonly, strong, nonatomic) UIAlertView *selectEndLocationAlertView;
@property (readonly, strong, nonatomic) UIAlertView *noPathToExitAlertView;
@property (readonly, strong, nonatomic) UIAlertView *resetMazeAlertView;

@property (readonly, strong, nonatomic) UIAlertView *saveMazeErrorAlertView;

@end

@implementation MADesignViewController

- (id)initWithReachability: (Reachability *)reachability
               webServices: (MAWebServices *)webServices
              eventManager: (MAEventManager *)eventManager
               mazeManager: (MAMazeManager *)mazeManager
              soundManager: (MASoundManager *)soundManager
            textureManager: (MATextureManager *)textureManager
{
    self = [super initWithNibName: NSStringFromClass([self class])
                           bundle: nil];
    
    if (self)
    {
        _reachability = reachability;
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

        _invalidTeleportationLocationAlertView = [[UIAlertView alloc] initWithTitle: @""
                                                                            message: @"A teleportation location cannot be surrounded by walls."
                                                                           delegate: nil
                                                                  cancelButtonTitle: @"OK"
                                                                  otherButtonTitles: nil];
        
        _selectSecondTeleportationLocationAlertView = [[UIAlertView alloc] initWithTitle: @""
                                                                                 message: @"Please select a second teleportation location before saving."
                                                                                delegate: nil
                                                                       cancelButtonTitle: @"OK"
                                                                       otherButtonTitles: nil];
        
        _mazeNameExistsAlertView = [[UIAlertView alloc] initWithTitle: @""
                                                              message: @""
                                                             delegate: nil
                                                    cancelButtonTitle: @"OK"
                                                    otherButtonTitles: nil];
        
        _enterMazeNameAlertView = [[UIAlertView alloc] initWithTitle: @""
                                                             message: @"Please enter in a name for your maze."
                                                            delegate: nil
                                                   cancelButtonTitle: @"OK"
                                                   otherButtonTitles: nil];
        
        _selectStartLocationAlertView = [[UIAlertView alloc] initWithTitle: @""
                                                                   message: @"Please select a start location."
                                                                  delegate: nil
                                                         cancelButtonTitle: @"OK"
                                                         otherButtonTitles: nil];
        
        _selectEndLocationAlertView = [[UIAlertView alloc] initWithTitle: @""
                                                                 message: @"A public maze must have an end location."
                                                                delegate: nil
                                                       cancelButtonTitle: @"OK"
                                                       otherButtonTitles: nil];

        _noPathToExitAlertView = [[UIAlertView alloc] initWithTitle: @""
                                                            message: @"A public maze must have a path from start to end."
                                                           delegate: nil
                                                  cancelButtonTitle: @"OK"
                                                  otherButtonTitles: nil];

        _resetMazeAlertView = [[UIAlertView alloc] initWithTitle: @""
                                                         message: @"Reset maze?"
                                                        delegate: self
                                               cancelButtonTitle: @"Yes"
                                               otherButtonTitles: @"No", nil];

        _saveMazeErrorAlertView = [[UIAlertView alloc] initWithTitle: @""
                                                             message: @""
                                                            delegate: nil
                                                   cancelButtonTitle: @"OK"
                                                   otherButtonTitles: nil];
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
    self.floorTextureButton.backgroundColor = self.styles.designScreen.texturePlaceholderBackgroundColor;
    self.ceilingTextureButton.backgroundColor = self.styles.designScreen.texturePlaceholderBackgroundColor;
    [self.contentView addSubview: self.locationScrollView];
    
    self.wallView.frame = CGRectMake(0.0, 0.0, self.contentView.frame.size.width, self.contentView.frame.size.height);
    self.wallView.backgroundColor = self.styles.designScreen.panelBackgroundColor;
    self.wallTextureButton.backgroundColor = self.styles.designScreen.texturePlaceholderBackgroundColor;
    [self.contentView addSubview: self.wallView];
    
    self.graphicsView.frame = CGRectMake(0.0, 0.0, self.contentView.frame.size.width, self.contentView.frame.size.height);
    self.graphicsView.backgroundColor = self.styles.designScreen.panelBackgroundColor;
    self.defaultWallTextureButton.backgroundColor = self.styles.designScreen.texturePlaceholderBackgroundColor;
    self.defaultFloorTextureButton.backgroundColor = self.styles.designScreen.texturePlaceholderBackgroundColor;
    self.defaultCeilingTextureButton.backgroundColor = self.styles.designScreen.texturePlaceholderBackgroundColor;
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
    
    self.message1Label.backgroundColor = self.styles.designScreen.messageBackgroundColor;
    self.message1Label.textColor = self.styles.designScreen.messageTextColor;
    
    self.message2Label.backgroundColor = self.styles.designScreen.messageBackgroundColor;
    self.message2Label.textColor = self.styles.designScreen.messageTextColor;
    
    self.floorPlanBorderView.backgroundColor = self.styles.designScreen.floorPlanBorderColor;
    
    _floorPlanViewController = [MAFloorPlanViewController floorPlanViewControllerWithMaze: self.maze
                                                                    floorPlanViewDelegate: self];
    
    [MAUtilities addChildViewController: self.floorPlanViewController
                 toParentViewController: self
                        placeholderView: self.floorPlanPlaceholderView];
    
    self.locationsVisited = [[NSMutableArray alloc] init];
    
    [self setup];
}

- (void)viewWillAppear: (BOOL)animated
{
    [super viewWillAppear: animated];
    
    [self.floorPlanViewController redrawUI];
    
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
        [MAUtilities logWithClass: [self class]
                          message: @"selectedIndex set to an illegal value."
                       parameters: @{@"selectedIndex" : @(selectedIndex)}];
   }
}

#pragma mark - MAFloorPlanViewDelegate

- (void)floorPlanView: (MAFloorPlanView *)floorPlanView didSelectWall: (MAWall *)wall
{
    if ([self.maze isInnerWall: wall])
    {
        self.floorPlanViewController.currentSelectedWall = wall;
        
        [self setupTabBarWithSelectedIndex: 3];
    
        [self setTableView: self.wallTypeTableView disabled: NO];
        
        if (self.floorPlanViewController.currentSelectedWall.type == MAWallNone)
        {
            self.floorPlanViewController.currentSelectedWall.type = MAWallSolid;

            if ([self wallPassesTeleportationSurroundedCheck: wall] == NO)
            {
                self.floorPlanViewController.currentSelectedWall.type = MAWallNone;
                
                [self teleportationSurroundedAlert];
            }
        }
        else
        {
            self.floorPlanViewController.currentSelectedWall.type = MAWallNone;
        }
        
        [self setupWallTypeTableViewWallType: self.floorPlanViewController.currentSelectedWall.type];
        
        [self showTutorialHelpForTopic: @"WallTypes"];
        
        [self setupWallPanel];

        [self.floorPlanViewController redrawUI];
        
        self.settings.hasSelectedWall = YES;
    }
}

- (void)floorPlanView: (MAFloorPlanView *)floorPlanView didSelectLocation: (MALocation *)location
{
    [self locationChangedToCoordinate: location.coordinate];
            
    self.settings.hasSelectedLocation = YES;
}

#pragma mark -

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
        
    self.floorPlanViewController.previousSelectedLocation = self.floorPlanViewController.currentSelectedLocation;
    self.floorPlanViewController.currentSelectedLocation = newLocation;
        
    [self setupTabBarWithSelectedIndex: 2];
        
    if (setAsTeleportation == YES)
    {
        [self.maze resetLocation: self.floorPlanViewController.currentSelectedLocation];
        
        self.floorPlanViewController.previousSelectedLocation.teleportX = self.floorPlanViewController.currentSelectedLocation.column;
        self.floorPlanViewController.previousSelectedLocation.teleportY = self.floorPlanViewController.currentSelectedLocation.row;
                
        self.floorPlanViewController.currentSelectedLocation.action = MALocationActionTeleport;
        self.floorPlanViewController.currentSelectedLocation.teleportId = self.floorPlanViewController.previousSelectedLocation.teleportId;
        self.floorPlanViewController.currentSelectedLocation.teleportX = self.floorPlanViewController.previousSelectedLocation.column;
        self.floorPlanViewController.currentSelectedLocation.teleportY = self.floorPlanViewController.previousSelectedLocation.row;
        
        [self showTutorialHelpForTopic: @"TeleportDirection"];
    }
    else 
    {
        [self showTutorialHelpForTopic: @"LocationTypes"];    
    }
        
    [self setupLocationActionTableViewLocationAction: self.floorPlanViewController.currentSelectedLocation.action
                                               theta: self.floorPlanViewController.currentSelectedLocation.direction];
    
    self.messageTextView.editable = YES;
    
    // set Message
    [self.messageTextView resignFirstResponder];
    self.messageTextView.text = self.floorPlanViewController.currentSelectedLocation.message;

    [self setupLocationPanel];
    
    [self.floorPlanViewController redrawUI];
}

- (BOOL)setNextLocationAsTeleportation
{
    if (self.floorPlanViewController.currentSelectedLocation != nil &&
        self.floorPlanViewController.currentSelectedLocation.action == MALocationActionTeleport &&
        self.floorPlanViewController.currentSelectedLocation.teleportX == 0 && self.floorPlanViewController.currentSelectedLocation.teleportY == 0)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

//
//    LOCATION TYPES
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
        [MAUtilities logWithClass: [self class]
                          message: @"tableView not handled."
                       parameters: @{@"tableView" : tableView}];
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
        [MAUtilities logWithClass: [self class]
                          message: @"tableView not handled."
                       parameters: @{@"tableView" : tableView}];
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
        [MAUtilities logWithClass: [self class]
                          message: @"tableView not handled."
                       parameters: @{@"tableView" : tableView}];
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
            NSArray    *backgroundSounds = [self.soundManager sortedByName];
        
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
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark)
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
                [self.maze resetLocation: self.floorPlanViewController.currentSelectedLocation];
                
                [self setupLocationPanel];
                
                [self showTutorialHelpForTopic: @"None"];
                
                break;
            }
                
            case MALocationActionStart:
            {                
                [self.maze resetLocation: self.floorPlanViewController.currentSelectedLocation];
                
                if (self.maze.startLocation != nil)
                {
                    [self.maze resetLocation: self.maze.startLocation];
                }
                
                self.floorPlanViewController.currentSelectedLocation.floorTextureId = MAGreenTextureId;
                [self setupLocationPanel];
                
                [self showTutorialHelpForTopic: @"StartDirection"];

                break;
            }
                
            case MALocationActionEnd:
            {
                [self.maze resetLocation: self.floorPlanViewController.currentSelectedLocation];
                
                if (self.maze.endLocation != nil)
                {
                    [self.maze resetLocation: self.maze.endLocation];
                }
                
                self.floorPlanViewController.currentSelectedLocation.floorTextureId = MARedTextureId;
                [self setupLocationPanel];

                [self showTutorialHelpForTopic: @"None"];

                break;
            }
                
            case MALocationActionStartOver:
            {
                [self.maze resetLocation: self.floorPlanViewController.currentSelectedLocation];
                
                [self setupLocationPanel];

                [self showTutorialHelpForTopic: @"None"];

                break;
            }
                
            case MALocationActionTeleport:
            {
                if ([self.maze isSurroundedByWallsWithLocation: self.floorPlanViewController.currentSelectedLocation])
                {
                    [self teleportationSurroundedAlert];
                    
                    [self.locationTypeTableView deselectRowAtIndexPath: indexPath animated: YES];
                    return;
                }
                
                [self.maze resetLocation: self.floorPlanViewController.currentSelectedLocation];
                
                self.floorPlanViewController.currentSelectedLocation.TeleportId = [self getNextTeleportId];
                
                [self setupLocationPanel];
                
                [self showTutorialHelpForTopic: @"TeleportTwin"];

                break;
            }

            default:
                [MAUtilities logWithClass: [self class]
                                  message: @"action set to an illegal value."
                               parameters: @{@"action" : @(action)}];
                break;
        }
        
        self.floorPlanViewController.currentSelectedLocation.action = action;
        
        [self setupLocationActionTableViewLocationAction: self.floorPlanViewController.currentSelectedLocation.action
                                                   theta: self.floorPlanViewController.currentSelectedLocation.direction];
    }
    else if (tableView == self.directionTableView)
    {
        self.floorPlanViewController.currentSelectedLocation.direction = [[self.directionThetas objectAtIndex: indexPath.row] intValue];
        
        [self setupDirectionTableViewLocationAction: self.floorPlanViewController.currentSelectedLocation.action
                                              theta: self.floorPlanViewController.currentSelectedLocation.direction];
    }    
    else if (tableView == self.wallTypeTableView)
    {
        MAWallType previousSelectedWallType = self.floorPlanViewController.currentSelectedWall.type;
        self.floorPlanViewController.currentSelectedWall.type = [[self.wallTypes objectAtIndex: indexPath.row] intValue];
        
        if ([self wallPassesTeleportationSurroundedCheck: self.floorPlanViewController.currentSelectedWall] == NO)
        {
            self.floorPlanViewController.currentSelectedWall.type = previousSelectedWallType;
            
            [self.wallTypeTableView deselectRowAtIndexPath: indexPath animated: YES];
            
            [self teleportationSurroundedAlert];
        }
        else 
        {
            [self setupWallTypeTableViewWallType: self.floorPlanViewController.currentSelectedWall.type];
            
            if (self.floorPlanViewController.currentSelectedWall.type == MAWallInvisible)
            {
                [self showTutorialHelpForTopic: @"InvisibleWalls"];
            }
            else if (self.floorPlanViewController.currentSelectedWall.type == MAWallFake)
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
        NSArray    *backgroundSounds = [self.soundManager sortedByName];
        
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
        
        NSIndexPath    *prevIndexPath = [NSIndexPath indexPathForRow: row inSection: 0];    
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
    
    [self.floorPlanViewController redrawUI];
}

- (int)getNextTeleportId
{
    BOOL idExists;
    int teleportId = 0;
    
    do
    {
        teleportId = teleportId + 1;
        
        idExists = NO;
        for (MALocation *location in [self.maze allLocations])
        {
            if (location.teleportId == teleportId)
            {
                idExists = YES;
            }
        }        
    } while (idExists == YES);
        
    return teleportId;
}

- (void)setupLocationActionTableViewLocationAction: (MALocationActionType)locationAction theta: (int)theta
{
    [self clearAccessoriesInTableView: self.locationTypeTableView];
    
    int row = [self.locationActions indexOfObject: [NSNumber numberWithInt: locationAction]];
    NSIndexPath    *indexPath = [NSIndexPath indexPathForRow: row inSection: 0];

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
        NSIndexPath    *indexPath = [NSIndexPath indexPathForRow: row inSection: 0];

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
            [MAUtilities logWithClass: [self class]
                              message: @"locationAction set to an illegal value."
                           parameters: @{@"locationAction" : @(locationAction)}];
            break;
    }
}

- (void)setupWallTypeTableViewWallType: (int)wallType
{
    [self clearAccessoriesInTableView: self.wallTypeTableView];
    
    int row = [self.wallTypes indexOfObject: [NSNumber numberWithInt: wallType]];
    NSIndexPath    *indexPath = [NSIndexPath indexPathForRow: row inSection: 0];
    
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

- (BOOL)wallPassesTeleportationSurroundedCheck: (MAWall *)wall
{
    MALocation *location1 = nil;
    MALocation *location2 = nil;

    if (wall.direction == MADirectionNorth)
    {
        location1 = [self.maze locationWithRow: wall.row
                                        column: wall.column];
        
        location2 = [self.maze locationWithRow: wall.row - 1
                                        column: wall.column];
    }
    else if (wall.direction == MADirectionWest)
    {
        location1 = [self.maze locationWithRow: wall.row
                                        column: wall.column];
        
        location2 = [self.maze locationWithRow: wall.row
                                        column: wall.column - 1];
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
    [self.invalidTeleportationLocationAlertView show];
}

//
//   PUBLIC SWITCH
//

- (IBAction)switchPublicValueChanged: (id)sender
{
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
    
    [self findExitWithLocation: self.maze.startLocation];
    
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
        return;
    }
    
    if (location.action == MALocationActionStartOver)
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
    if (self.floorPlanViewController.currentSelectedLocation != nil)
    {
        if (self.texturesPopoverController.popoverVisible == YES)
        {
            [self.texturesPopoverController dismissPopoverAnimated: YES];
        }
        
        MATexture *floorTexture = nil;
        if (self.floorPlanViewController.currentSelectedLocation.floorTextureId != nil)
        {
            floorTexture = [self.textureManager textureWithTextureId: self.floorPlanViewController.currentSelectedLocation.floorTextureId];
        }
        else
        {
            floorTexture = self.maze.floorTexture;
        }

        [self.floorTextureButton setImage: [UIImage imageNamed: [floorTexture.name stringByAppendingString: @".png"]]
                                 forState: UIControlStateNormal];

        MATexture *ceilingTexture = nil;
        if (self.floorPlanViewController.currentSelectedLocation.ceilingTextureId != nil)
        {
            ceilingTexture = [self.textureManager textureWithTextureId: self.floorPlanViewController.currentSelectedLocation.ceilingTextureId];
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
    if (self.locationScrollView.isTracking == NO)
    {
        if (self.floorPlanViewController.currentSelectedLocation != nil &&
            self.floorPlanViewController.currentSelectedLocation.action != MALocationActionStart &&
            self.floorPlanViewController.currentSelectedLocation.action != MALocationActionEnd)
        {
            __weak typeof(self) weakSelf = self;
            
            self.texturesViewController.textureSelectedHandler = ^(MATexture *texture)
            {
                weakSelf.floorPlanViewController.currentSelectedLocation.floorTextureId = texture.textureId;
                [weakSelf setupLocationPanel];
            };
            
            [self.texturesPopoverController presentPopoverFromRect: self.floorTextureButton.frame
                                                            inView: self.locationScrollView
                                          permittedArrowDirections: UIPopoverArrowDirectionAny
                                                          animated: YES];
        }
    }
}

- (IBAction)floorTextureResetButtonTouchDown: (id)sender
{
    if (self.locationScrollView.isTracking == NO)
    {
        self.floorPlanViewController.currentSelectedLocation.floorTextureId = nil;
        [self setupLocationPanel];
    }
}

- (IBAction)ceilingTextureButtonTouchDown: (id)sender
{
    if (self.locationScrollView.isTracking == NO)
    {
        if (self.floorPlanViewController.currentSelectedLocation != nil)
        {
            __weak typeof(self) weakSelf = self;
            
            self.texturesViewController.textureSelectedHandler = ^(MATexture *texture)
            {
                weakSelf.floorPlanViewController.currentSelectedLocation.ceilingTextureId = texture.textureId;
                [weakSelf setupLocationPanel];
            };
            
            [self.texturesPopoverController presentPopoverFromRect: self.ceilingTextureButton.frame
                                                            inView: self.locationScrollView
                                          permittedArrowDirections: UIPopoverArrowDirectionAny
                                                          animated: YES];
        }
    }
}

- (IBAction)ceilingTextureResetButtonTouchDown: (id)sender
{
    if (self.locationScrollView.isTracking == NO)
    {
        self.floorPlanViewController.currentSelectedLocation.ceilingTextureId = nil;
        [self setupLocationPanel];
    }
}

//
//   WALL PANEL
//

- (void)setupWallPanel
{
    if (self.floorPlanViewController.currentSelectedWall != nil)
    {
        if (self.texturesPopoverController.popoverVisible == YES)
        {
            [self.texturesPopoverController dismissPopoverAnimated: YES];
        }
        
        MATexture *texture = nil;
        if (self.floorPlanViewController.currentSelectedWall.textureId != nil)
        {
            texture = [self.textureManager textureWithTextureId: self.floorPlanViewController.currentSelectedWall.textureId];
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
    if (self.floorPlanViewController.currentSelectedWall != nil)
    {
        __weak typeof(self) weakSelf = self;
        
        self.texturesViewController.textureSelectedHandler = ^(MATexture *texture)
        {
            weakSelf.floorPlanViewController.currentSelectedWall.textureId = texture.textureId;
            [weakSelf setupWallPanel];
        };
                
        [self.texturesPopoverController presentPopoverFromRect: self.wallTextureButton.frame
                                                        inView: self.wallView
                                      permittedArrowDirections: UIPopoverArrowDirectionAny animated: YES];
    }
}

- (IBAction)wallTextureResetButtonTouchDown: (id)sender
{
    self.floorPlanViewController.currentSelectedWall.textureId = nil;
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
    if ([self setNextLocationAsTeleportation] == YES)
    {
        [self.selectSecondTeleportationLocationAlertView show];
        
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
    self.saveButton.isBusy = YES;
    
    if (self.webServices.isSavingLocalMaze == NO)
    {
        [self.webServices saveLocalMaze: self.maze
                      completionHandler: ^(NSError *error)
        {
            if (error == nil)
            {
                ;
            }
            else
            {
                NSNumber *statusCode = [error.userInfo objectForKey: MAStatusCodeKey];
                
                if ([statusCode integerValue] == 450)
                {
                    [self setupTabBarWithSelectedIndex: 1];
                    
                    self.mazeNameExistsAlertView.message = [NSString stringWithFormat: @"There is already a maze with the name %@.", self.maze.name];
                    
                    [self.mazeNameExistsAlertView show];
                }
                else
                {
                    NSString *requestErrorMessage = [MAUtilities requestErrorMessageWithRequestDescription: MARequestDescriptionSaveMaze
                                                                                              reachability: self.reachability
                                                                                              userCanRetry: YES];
                    self.saveMazeErrorAlertView.message = requestErrorMessage;
                    
                    [self.saveMazeErrorAlertView show];
                }
            }

            self.saveButton.isBusy = NO;
        }];
    }
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
                
        [self.enterMazeNameAlertView show];

        passed = NO;
    }
    else if (self.maze.startLocation == nil)
    {
        [self.selectStartLocationAlertView show];

        passed = NO;
    }
    else if (self.publicSwitch.on == YES)
    {
        if (self.maze.endLocation == nil)
        {
            [self.selectEndLocationAlertView show];

            passed = NO;
        }
        else if ([self pathExists] == NO)
        {
            [self.noPathToExitAlertView show];

            passed = NO;
        }
    }

    return passed;
}

//
//   RESET
//

- (IBAction)resetButtonTouchDown: (id)sender
{
    [self.resetMazeAlertView show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView: (UIAlertView *)alertView didDismissWithButtonIndex: (NSInteger)buttonIndex
{
    if (alertView == self.resetMazeAlertView)
    {
        if (buttonIndex == 0 && self.mainViewController.isPerformingTransition == NO)
        {
            [self stopBackgroundSound];
            
            [self.maze reset];

            [self setup];
            
            self.mazeManager.isFirstUserMazeSizeChosen = NO;
            
            self.createViewController.maze = self.maze;
            
            [self.mainViewController transitionFromViewController: self
                                                 toViewController: self.createViewController
                                                       transition: MATransitionTranslateBothRight
                                                       completion: ^{}];
        }
    }
    else
    {
        [MAUtilities logWithClass: [self class]
                          message: @"alertView not handled."
                       parameters: @{@"alertView" : alertView}];
    }
}

- (IBAction)mazesButtonTouchDown: (id)sender
{
    if (self.mainViewController.isPerformingTransition == NO)
    {
        [self stopBackgroundSound];
        
        [self.navigationController popViewControllerAnimated: NO];

        [self.mainViewController transitionFromViewController: self
                                             toViewController: self.topMazesViewController
                                                   transition: MATransitionTranslateBothRight
                                                   completion: ^{}];
    }
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
    [self.floorPlanViewController redrawUI];
}

- (void)textViewDidChange:(UITextView *)textView
{    
    self.floorPlanViewController.currentSelectedLocation.message = [self.messageTextView.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
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

- (IBAction)tutorialSwitchValueChanged: (id)sender
{
    self.settings.useTutorial = self.tutorialSwitch.on;

    if (self.tutorialSwitch.on == NO)
    {
        [self showTutorialHelpForTopic: @"None"];
    }
    else
    {
        [self showTutorialHelpForTopic: @"Start"];
    }
}

- (void)showTutorialHelpForTopic: (NSString *)topic
{
    if ([topic isEqualToString: @"None"] == YES)
    {
        self.message1Label.text = @"";
        self.message2Label.text = @"";
    }

    if (self.settings.useTutorial == YES)
    {
        if ([topic isEqualToString: @"Start"] == YES)
        {
            self.message1Label.text = @"Tap on a wall (blue segment) to remove it or put it back.";
            self.message2Label.text = @"Tap and hold on a white square to select a location.";
        }
        
        if (self.settings.hasSelectedLocation == YES && self.settings.hasSelectedWall == YES)
        {
            if ([topic isEqualToString: @"WallTypes"] == YES)
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
                self.message1Label.text = @"Turn Make Public on so everyone can play your maze.";
                self.message2Label.text = @"If you have recently saved your maze it will appear at the top of the Newest list.";
            }
        }

        if ([topic isEqualToString: @"Start"] == NO &&
            [topic isEqualToString: @"None"] == NO &&
            [topic isEqualToString: @"WallTypes"] == NO &&
            [topic isEqualToString: @"InvisibleWalls"] == NO &&
            [topic isEqualToString: @"FakeWalls"] == NO &&
            [topic isEqualToString: @"LocationTypes"] == NO &&
            [topic isEqualToString: @"StartDirection"] == NO &&
            [topic isEqualToString: @"TeleportTwin"] == NO &&
            [topic isEqualToString: @"TeleportDirection"] == NO &&
            [topic isEqualToString: @"LocationMessages"] == NO &&
            [topic isEqualToString: @"MakePublic"] == NO)
        {
            [MAUtilities logWithClass: [self class]
                              message: @"topic set to an illegal value."
                           parameters: @{@"topic" : topic}];

        }
    }
}

- (void)setTableView: (UITableView *)tableView disabled: (BOOL)disabled
{
    if (disabled == YES && tableView.allowsSelection == YES)
    {
        tableView.backgroundColor = self.styles.designScreen.tableViewDisabledBackgroundColor;
        tableView.allowsSelection = NO;
    }
    else if (disabled == NO && tableView.allowsSelection == NO)
    {
        tableView.backgroundColor = self.styles.designScreen.tableViewBackgroundColor;
        tableView.allowsSelection = YES;
    }
}

@end




















