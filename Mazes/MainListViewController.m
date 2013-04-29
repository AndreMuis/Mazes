//
//  MainListViewController.m
//  Mazes
//
//  Created by Andre Muis on 4/25/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import "MainListViewController.h"

#import "ActivityViewStyle.h"
#import "AppDelegate.h"
#import "CurrentUser.h"
#import "CreateViewController.h"
#import "EditViewController.h"
#import "GameViewController.h"
#import "MAEvents.h"
#import "MAEvent.h"
#import "MainListItem.h"
#import "MainListTableViewCell.h"
#import "MainViewController.h"
#import "Maze.h"
#import "MazeUser.h"
#import "Rating.h"
#import "RatingView.h"
#import "ServerOperations.h"
#import "Styles.h"
#import "Utilities.h"

@interface MainListViewController ()

@property (strong, nonatomic) NSOperationQueue *getMazeListsOperationQueue;;
@property (strong, nonatomic) NSOperationQueue *getUserMazeOperationQueue;;

@property (strong, nonatomic) MAEvent *getMazeListsEvent;
@property (strong, nonatomic) MAEvent *getUserMazeEvent;

@property (strong, nonatomic) NSArray *highestRatedMainListItems;
@property (assign, nonatomic) BOOL highestRatedListHasLoaded;

@property (strong, nonatomic) NSArray *newestMainListItems;
@property (assign, nonatomic) BOOL newestMainListHasLoaded;

@property (strong, nonatomic) NSArray *yoursMainListItems;
@property (assign, nonatomic) BOOL yoursMainListHasLoaded;

@property (assign, nonatomic) int selectedSegmentIndex;

@property (assign, nonatomic) BOOL viewAppearingFirstTime;

@end

@implementation MainListViewController

+ (MainListViewController *)shared
{
	static MainListViewController *instance = nil;
	
	@synchronized(self)
	{
		if (instance == nil)
		{
			instance = [[MainListViewController alloc] initWithNibName: @"MainListViewController" bundle: nil];
		}
	}
	
	return instance;
}

- (id)initWithNibName: (NSString *)nibNameOrNil bundle: (NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName: nibNameOrNil bundle: nibBundleOrNil];
    
    if (self)
    {
        _getMazeListsOperationQueue = [[NSOperationQueue alloc] init];
        _getUserMazeOperationQueue = [[NSOperationQueue alloc] init];

        _getMazeListsEvent = [[MAEvent alloc] initWithTarget: self
                                                      action: @selector(getMazeLists)
                                                intervalSecs: [Constants shared].serverRetryDelaySecs
                                                     repeats: NO];
        
        _getUserMazeEvent = [[MAEvent alloc] initWithTarget: self
                                                     action: @selector(getUserMaze)
                                               intervalSecs: [Constants shared].serverRetryDelaySecs
                                                    repeats: NO];
        
        self.highestRatedMainListItems = [NSArray array];
        self.highestRatedListHasLoaded = NO;
        
        self.newestMainListItems = [NSArray array];
        self.newestMainListHasLoaded = NO;
        
        self.yoursMainListItems = [NSArray array];
        self.yoursMainListHasLoaded = NO;
        
        self.selectedSegmentIndex = 0;
        
        self.viewAppearingFirstTime = YES;
    }
    
    return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
    self.selectedSegmentIndex = 0;
	[self refreshSegments];

	self.tableView.backgroundColor = [Styles shared].mainListView.tableBackgroundColor;

    self.activityIndicatorView.color = [Styles shared].activityView.color;
    
    if ([CurrentUser shared].id == 0)
    {
        self.activityIndicatorView.hidden = NO;
        [self.activityIndicatorView startAnimating];
    }
}

- (void)viewWillAppear: (BOOL)animated
{
	[super viewWillAppear: animated];

    if (self.movingToParentViewController == YES || self.viewAppearingFirstTime == YES)
    {
        self.viewAppearingFirstTime = NO;
        
        if ([CurrentUser shared].id != 0)
        {
            [self getMazeLists];
        }
        
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

        if ([appDelegate.bannerView isDescendantOfView: self.view] == NO)
        {
            appDelegate.bannerView.frame = CGRectMake(appDelegate.bannerView.frame.origin.x,
                                                      self.tableView.frame.origin.y + self.tableView.frame.size.height,
                                                      appDelegate.bannerView.frame.size.width,
                                                      appDelegate.bannerView.frame.size.height);
            
            [self.view addSubview: appDelegate.bannerView];
        }
    }
}

- (void)serverOperationsHighestRatedList: (NSArray *)mainListItems error: (NSError *)error
{
    if (error == nil)
    {
        NSLog(@"highest rated");
        
        self.highestRatedMainListItems = mainListItems;
        
        if (self.highestRatedListHasLoaded == NO)
        {
            self.highestRatedListHasLoaded = YES;
            
            if (self.selectedSegmentIndex == 0)
            {
                self.activityIndicatorView.hidden = YES;
                [self.activityIndicatorView stopAnimating];
            }
        }
        
        if (self.selectedSegmentIndex == 0)
        {
            [self.tableView reloadData];
        }
    }
    else
    {
        if (self.selectedSegmentIndex == 0)
        {
            if ([[MAEvents shared] hasEvent: self.getMazeListsEvent] == NO)
            {
                [[MAEvents shared] addEvent: self.getMazeListsEvent];
            }
        }
    }
}

- (void)serverOperationsNewestList: (NSArray *)mainListItems error: (NSError *)error
{
    if (error == nil)
    {
        NSLog(@"newest");
        
        self.newestMainListItems = mainListItems;
        
        if (self.newestMainListHasLoaded == NO)
        {
            self.newestMainListHasLoaded = YES;
            
            if (self.selectedSegmentIndex == 1)
            {
                self.activityIndicatorView.hidden = YES;
                [self.activityIndicatorView stopAnimating];
            }
        }

        if (self.selectedSegmentIndex == 1)
        {
            [self.tableView reloadData];
        }
    }
    else
    {
        if (self.selectedSegmentIndex == 1)
        {
            if ([[MAEvents shared] hasEvent: self.getMazeListsEvent] == NO)
            {
                [[MAEvents shared] addEvent: self.getMazeListsEvent];
            }
        }
    }
}

- (void)serverOperationsYoursList: (NSArray *)mainListItems error: (NSError *)error
{
    if (error == nil)
    {
        NSLog(@"yours");
        
        self.yoursMainListItems = mainListItems;
        
        if (self.yoursMainListHasLoaded == NO)
        {
            self.yoursMainListHasLoaded = YES;
            
            if (self.selectedSegmentIndex == 2)
            {
                self.activityIndicatorView.hidden = YES;
                [self.activityIndicatorView stopAnimating];
            }
        }
        
        if (self.selectedSegmentIndex == 2)
        {
            [self.tableView reloadData];
        }
        
        [self.tableView reloadData];
    }
    else
    {
        if (self.selectedSegmentIndex == 2)
        {
            if ([[MAEvents shared] hasEvent: self.getMazeListsEvent] == NO)
            {
                [[MAEvents shared] addEvent: self.getMazeListsEvent];
            }
        }
    }
}

- (void)getMazeLists
{
    [self.getMazeListsOperationQueue cancelAllOperations];

    if ([[MAEvents shared] hasEvent: self.getMazeListsEvent] == YES)
    {
        [[MAEvents shared] removeEvent: self.getMazeListsEvent];
    }
    
    RKObjectRequestOperation *highestRatedOperation = [[ServerOperations shared] highestRatedOperationWithDelegate: self
                                                                                                            userId: [CurrentUser shared].id];
    
    RKObjectRequestOperation *newestOperation = [[ServerOperations shared] newestOperationWithDelegate: self
                                                                                                userId: [CurrentUser shared].id];
    
    RKObjectRequestOperation *yoursOperation = [[ServerOperations shared] yoursOperationWithDelegate: self
                                                                                              userId: [CurrentUser shared].id];
    
    NSArray *operations = @[highestRatedOperation, newestOperation, yoursOperation];
    
    RKObjectRequestOperation *currentOperation = nil;
    
    switch (self.selectedSegmentIndex)
    {
        case 0:
            currentOperation = highestRatedOperation;
            break;
            
        case 1:
            currentOperation = newestOperation;
            break;
            
        case 2:
            currentOperation = yoursOperation;
            break;
            
        default:
            [Utilities logWithClass: [self class] format: @"selectedSegmentIndex set to an illegal value: %d", self.selectedSegmentIndex];
            break;
    }

    [self.getMazeListsOperationQueue addOperation: currentOperation];

    for (RKObjectRequestOperation *operation in operations)
    {
        if (operation != currentOperation)
        {
            NSArray *mainListItems;
            
            if (operation == highestRatedOperation)
            {
                mainListItems = self.highestRatedMainListItems;
            }
            else if (operation == newestOperation)
            {
                mainListItems = self.newestMainListItems;
            }
            else if (operation == yoursOperation)
            {
                mainListItems = self.yoursMainListItems;
            }
            
            if (mainListItems.count == 0)
            {
                [operation addDependency: currentOperation];
            
                [self.getMazeListsOperationQueue addOperation: operation];
            }
        }
    }
    
    if ((self.selectedSegmentIndex == 0 && self.highestRatedListHasLoaded == NO) ||
        (self.selectedSegmentIndex == 1 && self.newestMainListHasLoaded == NO) ||
        (self.selectedSegmentIndex == 2 && self.yoursMainListHasLoaded == NO))
    {
        self.activityIndicatorView.hidden = NO;
        [self.activityIndicatorView startAnimating];
    }
    else
    {
        self.activityIndicatorView.hidden = YES;
        [self.activityIndicatorView stopAnimating];
    }
}

// Segmented Control

- (IBAction)highestRatedButtonTouchDown: (id)sender
{	
	if (self.selectedSegmentIndex != 0)
	{
        self.selectedSegmentIndex = 0;
		[self refreshSegments];

        if ([CurrentUser shared].id != 0)
        {
            [self.tableView reloadData];
            
            [self getMazeLists];
        }
	}
}

- (IBAction)newestButtonTouchDown: (id)sender
{
	if (self.selectedSegmentIndex != 1)
	{
        self.selectedSegmentIndex = 1;
		[self refreshSegments];
        
        if ([CurrentUser shared].id != 0)
        {
            [self.tableView reloadData];

            [self getMazeLists];
        }
	}
}

- (IBAction)yoursButtonTouchDown: (id)sender
{
	if (self.selectedSegmentIndex != 2)
	{
        self.selectedSegmentIndex = 2;
		[self refreshSegments];
        
        if ([CurrentUser shared].id != 0)
        {
            [self.tableView reloadData];
            
            [self getMazeLists];
        }
	}
}

- (void)refreshSegments
{
	if (self.selectedSegmentIndex == 0)
    {
		self.highestRatedImageView.image = [UIImage imageNamed: @"btnHighestRatedOrange.png"];
    }
	else
    {
		self.highestRatedImageView.image = [UIImage imageNamed: @"btnHighestRatedBlue.png"];
    }
		
	if (self.selectedSegmentIndex == 1)
    {
		self.newestImageView.image = [UIImage imageNamed: @"btnNewestOrange.png"];
    }
	else
    {
		self.newestImageView.image = [UIImage imageNamed: @"btnNewestBlue.png"];
    }

	if (self.selectedSegmentIndex == 2)
    {
		self.yoursImageView.image = [UIImage imageNamed: @"btnYoursOrange.png"];
    }
	else
    {
		self.yoursImageView.image = [UIImage imageNamed: @"btnYoursBlue.png"];
    }
}

- (NSInteger)numberOfSectionsInTableView: (UITableView *)tableView 
{
    return 1;
}

- (NSInteger)tableView: (UITableView *)tableView numberOfRowsInSection: (NSInteger)section 
{
	NSInteger rows = 0;
	
    NSArray *mainListItems = [self currentMainListItems];
    
	if (mainListItems.count % 2 == 0)
    {
		rows = mainListItems.count / 2;
    }
	else if (mainListItems.count % 2 == 1)
    {
		rows = (mainListItems.count + 1)/ 2;
    }
	
    return rows;
}

- (UITableViewCell *)tableView: (UITableView *)tableView cellForRowAtIndexPath: (NSIndexPath *)indexPath 
{    
    static NSString *CellIdentifier = @"MainListTableViewCell";
    
    MainListTableViewCell *cell = (MainListTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier: CellIdentifier];
    if (cell == nil) 
	{
		[[NSBundle mainBundle] loadNibNamed: @"MainListTableViewCell" owner: self options: nil];
		cell = self.tableViewCell;
		
		self.tableViewCell = nil;
    }
    
    NSArray *mainListItems = [self currentMainListItems];
    
    MainListItem *mainListItem1 = [mainListItems objectAtIndex: 2 * indexPath.row];
    
    MainListItem *mainListItem2 = nil;
    if (2 * indexPath.row + 1 <= mainListItems.count - 1)
    {
        mainListItem2 = [mainListItems objectAtIndex: 2 * indexPath.row + 1];
    }
    
    [cell setupWithMainListItem1: mainListItem1 mainListItem2: mainListItem2];
    
    return cell;
}

- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath 
{
	MainListTableViewCell *cell = (MainListTableViewCell *)[self.tableView cellForRowAtIndexPath: indexPath];
	
	int i = indexPath.row * 2 + (cell.selectedColumn - 1);
	
    NSArray *mainListItems = [self currentMainListItems];
    
	if (i < mainListItems.count)
	{
        if ([[MAEvents shared] hasEvent: self.getMazeListsEvent] == YES)
        {
            [[MAEvents shared] removeEvent: self.getMazeListsEvent];
        }
        
        [self.getMazeListsOperationQueue cancelAllOperations];
        
        
        if ([[MAEvents shared] hasEvent: self.getUserMazeEvent] == YES)
        {
            [[MAEvents shared] removeEvent: self.getUserMazeEvent];
        }
        
        [self.getUserMazeOperationQueue cancelAllOperations];
        
        
        self.createButton.enabled = YES;
        
        MainListItem *mainListItem = [mainListItems objectAtIndex: i];
        
        [GameViewController shared].mazeId = mainListItem.mazeId;
        
        [[MainViewController shared] transitionFromViewController: self
                                                 toViewController: [GameViewController shared]
                                                       transition: MATransitionFlipFromLeft];
    }
}

- (NSArray *)currentMainListItems
{
    switch (self.selectedSegmentIndex)
    {
        case 0:
            return self.highestRatedMainListItems;
            break;
            
        case 1:
            return self.newestMainListItems;
            break;
            
        case 2:
            return self.yoursMainListItems;
            break;
            
        default:
            [Utilities logWithClass: [self class] format: @"selectedSegmentIndex set to an illegal value: %d", self.selectedSegmentIndex];
            return nil;
            break;
    }
}

- (void)savedMazeUser: (MazeUser *)mazeUser
{
    for (MainListItem *mainListItem in [self currentMainListItems])
    {
        if (mazeUser.mazeId == mainListItem.mazeId && (mazeUser.started != mainListItem.userStarted || mazeUser.rating != mainListItem.userRating))
        {
            [self getMazeLists];
        }
    }
}

- (void)savedRating: (Rating *)rating
{
    for (MainListItem *mainListItem in [self currentMainListItems])
    {
        if (rating.mazeId == mainListItem.mazeId && rating.value != mainListItem.userRating)
        {
            [self getMazeLists];
        }
    }
}

- (IBAction)createButtonTouchDown: (id)sender
{
    if ([CurrentUser shared].id != 0)
    {
        if ([[MAEvents shared] hasEvent: self.getMazeListsEvent] == YES)
        {
            [[MAEvents shared] removeEvent: self.getMazeListsEvent];
        }

        [self.getMazeListsOperationQueue cancelAllOperations];
        
        
        if ([EditViewController shared].maze == nil)
        {
            self.createButton.enabled = NO;
            
            [self getUserMaze];
        }
        else
        {
            if ([EditViewController shared].maze.locations.list.count == 0)
            {
                [[MainViewController shared] transitionFromViewController: self
                                                         toViewController: [CreateViewController shared]
                                                               transition: MATransitionCrossDissolve];            
            }
            else
            {
                [[MainViewController shared] transitionFromViewController: self
                                                         toViewController: [EditViewController shared]
                                                               transition: MATransitionCrossDissolve];
            }
        }
    }
}

- (void)getUserMaze
{
    [self.getUserMazeOperationQueue addOperation: [[ServerOperations shared] getMazeOperationWithDelegate: self userId: [CurrentUser shared].id]];
}

- (void)serverOperationsGetMaze: (Maze *)maze error: (NSError *)error
{
    NSLog(@"maze = %@", maze);
    
    if (error == nil)
    {
        if (maze == nil)
        {
            [EditViewController shared].maze = [[Maze alloc] init];

            [EditViewController shared].maze.userId = [CurrentUser shared].id;
            [EditViewController shared].maze.active = YES;
            [EditViewController shared].maze.wallTextureId = 1;
            [EditViewController shared].maze.floorTextureId = 20;
            [EditViewController shared].maze.ceilingTextureId = 15;
            
            [[MainViewController shared] transitionFromViewController: self
                                                     toViewController: [CreateViewController shared]
                                                           transition: MATransitionCrossDissolve];
        }
        else
        {
            [EditViewController shared].maze = maze;

            [[MainViewController shared] transitionFromViewController: self
                                                     toViewController: [EditViewController shared]
                                                           transition: MATransitionCrossDissolve];
        }
        
        self.createButton.enabled = YES;
    }
    else
    {
        [self performSelector: @selector(getUserMaze) withObject: nil afterDelay: [Constants shared].serverRetryDelaySecs];
    }
}

@end























