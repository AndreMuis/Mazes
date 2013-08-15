//
//  MATopMazesViewController.m
//  Mazes
//
//  Created by Andre Muis on 4/25/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import "MATopMazesViewController.h"

#import "ActivityViewStyle.h"
#import "AppDelegate.h"
#import "CreateViewController.h"
#import "EditViewController.h"
#import "GameViewController.h"

#import "MAEvents.h"
#import "MAEvent.h"
#import "MAMainViewController.h"
#import "MAMazeManager.h"
#import "MAMaze.h"
#import "MAMazeRating.h"
#import "MATextureManager.h"
#import "MATopMazeItem.h"
#import "MATopMazeTableViewCell.h"
#import "MATopMazesViewController.h"
#import "MAUserManager.h"
#import "MAUser.h"
#import "MAUtilities.h"

#import "RatingView.h"
#import "Styles.h"

@interface MATopMazesViewController ()

@property (assign, nonatomic) int selectedSegmentIndex;

@property (assign, nonatomic) BOOL viewAppearingFirstTime;

@property (strong, nonatomic) NSString *topMazeCellIdentifier;

@property (strong, nonatomic, readonly) NSArray *currentTopMazeItems;

@end

@implementation MATopMazesViewController

+ (MATopMazesViewController *)shared
{
	static MATopMazesViewController *instance = nil;
	
	@synchronized(self)
	{
		if (instance == nil)
		{
			instance = [[MATopMazesViewController alloc] initWithNibName: @"MainListViewController" bundle: nil];
		}
	}
	
	return instance;
}

- (id)initWithNibName: (NSString *)nibNameOrNil bundle: (NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName: nibNameOrNil bundle: nibBundleOrNil];
    
    if (self)
    {
        _selectedSegmentIndex = 0;
        
        _viewAppearingFirstTime = YES;
        
        _topMazeCellIdentifier = @"TopMazeTableViewCell";
    }
    
    return self;
}

- (NSArray *)currentTopMazeItems
{
    switch (self.selectedSegmentIndex)
    {
        case 0:
            return [MAMazeManager shared].highestRatedTopMazeItems;
            break;
            
        case 1:
            return [MAMazeManager shared].newestTopMazeItems;
            break;
            
        case 2:
            return [MAMazeManager shared].yoursTopMazeItems;
            break;
            
        default:
            [MAUtilities logWithClass: [self class] format: @"selectedSegmentIndex set to an illegal value: %d", self.selectedSegmentIndex];
            return nil;
            break;
    }
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.tableView.backgroundColor = [Styles shared].mainListView.tableBackgroundColor;

    self.activityIndicatorView.color = [Styles shared].activityView.color;
}

- (void)viewWillAppear: (BOOL)animated
{
	[super viewWillAppear: animated];

    if (self.viewAppearingFirstTime == YES)
    {
        [self refreshSegments];
        [self refreshActivityIndicatorView];
    }
    
    if (self.movingToParentViewController == YES || self.viewAppearingFirstTime == YES)
    {
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
    
    [[MAMazeManager shared] addObserver: self
                             forKeyPath: @"highestRatedTopMazeItems"
                                options: (NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew)
                                context: NULL];
    
    [[MAMazeManager shared] addObserver: self
                             forKeyPath: @"newestTopMazeItems"
                                options: (NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew)
                                context: NULL];

    [[MAMazeManager shared] addObserver: self
                             forKeyPath: @"yoursTopMazeItems"
                                options: (NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew)
                                context: NULL];

    self.viewAppearingFirstTime = NO;
}

- (void)observeValueForKeyPath: (NSString *)keyPath ofObject: (id)object change: (NSDictionary *)change context: (void *)context
{
    if (object == [MAMazeManager shared] &&
        ([keyPath isEqualToString: @"highestRatedTopMazeItems"] == YES ||
         [keyPath isEqualToString: @"newestTopMazeItems"] == YES ||
         [keyPath isEqualToString: @"yoursTopMazeItems"] == YES))
    {
        if (([keyPath isEqualToString: @"highestRatedTopMazeItems"] == YES && self.selectedSegmentIndex == 0) ||
            ([keyPath isEqualToString: @"newestTopMazeItems"] == YES && self.selectedSegmentIndex == 1) ||
            ([keyPath isEqualToString: @"yoursTopMazeItems"] == YES && self.selectedSegmentIndex == 2))
        
        {
            [self.tableView reloadData];
        }

        [self refreshActivityIndicatorView];
        [self downloadOtherMazes];
    }
}

- (IBAction)highestRatedButtonTouchDown: (id)sender
{
	if (self.selectedSegmentIndex != 0)
	{
        self.selectedSegmentIndex = 0;
		
        [self refreshSegments];
        [self refreshCurrentMazes];
        [self refreshActivityIndicatorView];
	}
}

- (IBAction)newestButtonTouchDown: (id)sender
{
	if (self.selectedSegmentIndex != 1)
	{
        self.selectedSegmentIndex = 1;

		[self refreshSegments];
        [self refreshCurrentMazes];
        [self refreshActivityIndicatorView];
	}
}

- (IBAction)yoursButtonTouchDown: (id)sender
{
	if (self.selectedSegmentIndex != 2)
	{
        self.selectedSegmentIndex = 2;

		[self refreshSegments];
        [self refreshCurrentMazes];
        [self refreshActivityIndicatorView];
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

- (void)refreshCurrentMazes
{
    NSLog(@"refreshCurrentMazes");
    
    [self.tableView reloadData];
    
    switch (self.selectedSegmentIndex)
    {
        case 0:
            if ([MAMazeManager shared].highestRatedTopMazeItems == nil || [MAMazeManager shared].isDownloadingHighestRatedMazes == NO)
            {
                NSLog(@"downloading highest rated");
                
                [[MAMazeManager shared] getHighestRatedMazesWithCompletionHandler: ^
                {
                    NSLog(@"downloaded highest rated");
                }];
            }
            break;
            
        case 1:
            if ([MAMazeManager shared].newestTopMazeItems == nil || [MAMazeManager shared].isDownloadingNewestMazes == NO)
            {
                NSLog(@"downloading newest");
                
                [[MAMazeManager shared] getNewestMazesWithCompletionHandler: ^
                 {
                     NSLog(@"downloaded newest");
                 }];
            }
            break;
            
        case 2:
            if ([MAMazeManager shared].yoursTopMazeItems == nil || [MAMazeManager shared].isDownloadingYoursMazes == NO)
            {
                NSLog(@"downloading yours");

                [[MAMazeManager shared] getYoursMazesWithCompletionHandler: ^
                 {
                     NSLog(@"downloaded yours");
                 }];
            }
            break;
            
        default:
            [MAUtilities logWithClass: [self class] format: @"selectedSegmentIndex set to an illegal value: %d", self.selectedSegmentIndex];
            break;
    }
}

- (void)downloadOtherMazes
{
    if (self.selectedSegmentIndex != 0 && [MAMazeManager shared].highestRatedTopMazeItems == nil)
    {
        NSLog(@"downloading other highest rated");
        
        [[MAMazeManager shared] getHighestRatedMazesWithCompletionHandler: ^
        {
            NSLog(@"downloaded other highest rated");
        }];
    }

    if (self.selectedSegmentIndex != 1 && [MAMazeManager shared].newestTopMazeItems == nil)
    {
        NSLog(@"downloading other newest");

        [[MAMazeManager shared] getNewestMazesWithCompletionHandler: ^
        {
            NSLog(@"downloaded other newest");
        }];
    }
    
    if (self.selectedSegmentIndex != 2 && [MAMazeManager shared].yoursTopMazeItems == nil)
    {
        NSLog(@"downloading other yours");

        [[MAMazeManager shared] getYoursMazesWithCompletionHandler: ^
        {
            NSLog(@"downloaded other yours");
        }];
    }
}

- (void)refreshActivityIndicatorView
{
    if ((self.selectedSegmentIndex == 0 && [MAMazeManager shared].highestRatedTopMazeItems == nil) ||
        (self.selectedSegmentIndex == 1 && [MAMazeManager shared].newestTopMazeItems == nil) ||
        (self.selectedSegmentIndex == 2 && [MAMazeManager shared].yoursTopMazeItems == nil))
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

- (NSInteger)numberOfSectionsInTableView: (UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView: (UITableView *)tableView numberOfRowsInSection: (NSInteger)section 
{
	NSInteger rows = 0;
	
	if (self.currentTopMazeItems == nil)
    {
		rows = 0;
    }
	else if (self.currentTopMazeItems.count % 2 == 0)
    {
		rows = self.currentTopMazeItems.count / 2;
    }
	else if (self.currentTopMazeItems.count % 2 == 1)
    {
		rows = (self.currentTopMazeItems.count + 1)/ 2;
    }
	
    return rows;
}

- (UITableViewCell *)tableView: (UITableView *)tableView cellForRowAtIndexPath: (NSIndexPath *)indexPath 
{
    MATopMazeTableViewCell *cell = (MATopMazeTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier: self.topMazeCellIdentifier];
    
    if (cell == nil) 
	{
        cell = (MATopMazeTableViewCell *)[[[NSBundle mainBundle] loadNibNamed: @"MATopMazeTableViewCell" owner: nil options: nil] objectAtIndex: 0];
    }
    
    MATopMazeItem *topMazeItem1 = [self.currentTopMazeItems objectAtIndex: 2 * indexPath.row];
    
    MATopMazeItem *topMazeItem2 = nil;
    if (2 * indexPath.row + 1 <= self.currentTopMazeItems.count - 1)
    {
        topMazeItem2 = [self.currentTopMazeItems objectAtIndex: 2 * indexPath.row + 1];
    }
    
    [cell setupWithTopMazeItem1: topMazeItem1 topMazeItem2: topMazeItem2];
    
    return cell;
}

- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath 
{
	MATopMazeTableViewCell *cell = (MATopMazeTableViewCell *)[self.tableView cellForRowAtIndexPath: indexPath];
	
	int i = indexPath.row * 2 + (cell.selectedColumn - 1);
	
	if (i < self.currentTopMazeItems.count)
	{
        MATopMazeItem *topMazeItem = [self.currentTopMazeItems objectAtIndex: i];
        
        [GameViewController shared].mazeObjectId = topMazeItem.maze.objectId;
        
        [[MAMainViewController shared] transitionFromViewController: self
                                                   toViewController: [GameViewController shared]
                                                         transition: MATransitionFlipFromLeft];
    }
}

- (IBAction)createButtonTouchDown: (id)sender
{
    if ([EditViewController shared].maze == nil)
    {
        // [self getUserMaze];
    }
    else
    {
        if ([EditViewController shared].maze.locationCount == 0)
        {
            [[MAMainViewController shared] transitionFromViewController: self
                                                       toViewController: [CreateViewController shared]
                                                             transition: MATransitionCrossDissolve];
        }
        else
        {
            [[MAMainViewController shared] transitionFromViewController: self
                                                       toViewController: [EditViewController shared]
                                                             transition: MATransitionCrossDissolve];
        }
    }
}

- (void)serverOperationsGetMaze: (MAMaze *)maze error: (NSError *)error
{
    NSLog(@"maze = %@", maze);
    
    if (error == nil)
    {
        if (maze == nil)
        {
            [EditViewController shared].maze = [[MAMaze alloc] init];

            [EditViewController shared].maze.user = [MAUserManager shared].currentUser;
            [EditViewController shared].maze.active = YES;
            
            [EditViewController shared].maze.wallTexture = [[MATextureManager shared] textureWithObjectId: @"1"];
            [EditViewController shared].maze.floorTexture = [[MATextureManager shared] textureWithObjectId: @"20"];
            [EditViewController shared].maze.ceilingTexture = [[MATextureManager shared] textureWithObjectId: @"15"];
            
            [[MAMainViewController shared] transitionFromViewController: self
                                                       toViewController: [CreateViewController shared]
                                                             transition: MATransitionCrossDissolve];
        }
        else
        {
            [EditViewController shared].maze = maze;

            [[MAMainViewController shared] transitionFromViewController: self
                                                       toViewController: [EditViewController shared]
                                                             transition: MATransitionCrossDissolve];
        }
    }
    else
    {
        [self performSelector: @selector(getUserMaze) withObject: nil afterDelay: [MAConstants shared].serverRetryDelaySecs];
    }
}

@end























