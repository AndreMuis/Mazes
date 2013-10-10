//
//  MATopMazesViewController.m
//  Mazes
//
//  Created by Andre Muis on 4/25/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import "MATopMazesViewController.h"

#import "MAActivityViewStyle.h"
#import "MAConstants.h"
#import "MACreateViewController.h"
#import "MAEditViewController.h"
#import "MAGameViewController.h"
#import "MAMainListViewStyle.h"
#import "MAMainViewController.h"
#import "MAMazeManager.h"
#import "MAMaze.h"
#import "MAMazeRating.h"
#import "MARatingView.h"
#import "MASoundManager.h"
#import "MAStyles.h"
#import "MATextureManager.h"
#import "MATopMazeItem.h"
#import "MATopMazeTableViewCell.h"
#import "MATopMazesViewController.h"
#import "MAUtilities.h"

@interface MATopMazesViewController () <UITableViewDataSource, UITableViewDelegate>

@property (readonly, strong, nonatomic) AMFatFractal *amFatFractal;

@property (readonly, strong, nonatomic) MAConstants *constants;
@property (readonly, strong, nonatomic) MAMazeManager *mazeManager;
@property (readonly, strong, nonatomic) MASoundManager *soundManager;
@property (readonly, strong, nonatomic) MAStyles *styles;
@property (readonly, strong, nonatomic) MATextureManager *textureManager;

@property (readonly, strong, nonatomic) ADBannerView *bannerView;

@property (assign, nonatomic) int selectedSegmentIndex;
@property (assign, nonatomic) BOOL viewAppearingFirstTime;
@property (readonly, strong, nonatomic) NSString *topMazeCellIdentifier;
@property (readonly, strong, nonatomic) NSArray *currentTopMazeItems;

@property (weak, nonatomic) IBOutlet UIImageView *highestRatedImageView;
@property (weak, nonatomic) IBOutlet UIImageView *newestImageView;
@property (weak, nonatomic) IBOutlet UIImageView *yoursImageView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@property (weak, nonatomic) IBOutlet UIImageView *createImageView;
@property (weak, nonatomic) IBOutlet UIButton *createButton;

@end

@implementation MATopMazesViewController

- (id)initWithAMFatFractal: (AMFatFractal *)amFatFractal
                 constants: (MAConstants *)constants
               mazeManager: (MAMazeManager *)mazeManager
            textureManager: (MATextureManager *)textureManager
              soundManager: (MASoundManager *)soundManager
                    styles: (MAStyles *)styles
                bannerView: (ADBannerView *)bannerView;
{
    self = [[MATopMazesViewController alloc] initWithNibName: NSStringFromClass([self class]) bundle: nil];
    
    if (self)
    {
        _amFatFractal = amFatFractal;
        
        _constants = constants;
        _mazeManager = mazeManager;
        _soundManager = soundManager;
        _styles = styles;
        _textureManager = textureManager;
        
        _bannerView = bannerView;

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
            return self.mazeManager.highestRatedTopMazeItems;
            break;
            
        case 1:
            return self.mazeManager.newestTopMazeItems;
            break;
            
        case 2:
            return self.mazeManager.yoursTopMazeItems;
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
	
	self.tableView.backgroundColor = self.styles.mainListView.tableBackgroundColor;
    self.activityIndicatorView.color = self.styles.activityView.color;
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
        if ([self.bannerView isDescendantOfView: self.view] == NO)
        {
            self.bannerView.frame = CGRectMake(self.bannerView.frame.origin.x,
                                               self.tableView.frame.origin.y + self.tableView.frame.size.height,
                                               self.bannerView.frame.size.width,
                                               self.bannerView.frame.size.height);
            
            [self.view addSubview: self.bannerView];
        }
    }
    
    self.viewAppearingFirstTime = NO;
}

- (void)downloadTopMazeItems
{
    [self downloadHighestRatedTopMazeItems];
}

- (void)downloadHighestRatedTopMazeItems
{
    if (self.mazeManager.isDownloadingHighestRatedMazes == NO)
    {
        NSLog(@"downloading highest rated");

        [self.mazeManager getHighestRatedMazesWithCompletionHandler: ^
        {
            NSLog(@"downloaded highest rated");

            if (self.selectedSegmentIndex == 0)
            {
                [self.tableView reloadData];
                [self refreshActivityIndicatorView];
            }

            [self downloadOtherMazes];
        }];
    }
}

- (void)downloadNewestTopMazeItems
{
    if (self.mazeManager.isDownloadingNewestMazes == NO)
    {
        NSLog(@"downloading newest");

        [self.mazeManager getNewestMazesWithCompletionHandler: ^
        {
            NSLog(@"downloaded newest");

            if (self.selectedSegmentIndex == 1)
            {
                [self.tableView reloadData];
                [self refreshActivityIndicatorView];
            }

            [self downloadOtherMazes];
        }];
    }
}

- (void)downloadYoursTopMazeItems
{
    if (self.mazeManager.isDownloadingYoursMazes == NO)
    {
        NSLog(@"downloading yours");

        [self.mazeManager getYoursMazesWithCompletionHandler: ^
        {
            NSLog(@"downloaded yours");

            if (self.selectedSegmentIndex == 2)
            {
                [self.tableView reloadData];
                [self refreshActivityIndicatorView];
            }
            
            [self downloadOtherMazes];
        }];
    }
}

- (void)downloadOtherMazes
{
    if (self.mazeManager.highestRatedTopMazeItems == nil)
    {
        NSLog(@"downloading other highest rated");
        
        [self.mazeManager getHighestRatedMazesWithCompletionHandler: ^
         {
             NSLog(@"downloaded other highest rated");

             if (self.selectedSegmentIndex == 0)
             {
                 [self.tableView reloadData];
                 [self refreshActivityIndicatorView];
             }
         }];
    }
    
    if (self.mazeManager.newestTopMazeItems == nil)
    {
        NSLog(@"downloading other newest");
        
        [self.mazeManager getNewestMazesWithCompletionHandler: ^
         {
             NSLog(@"downloaded other newest");
             
             if (self.selectedSegmentIndex == 1)
             {
                 [self.tableView reloadData];
                 [self refreshActivityIndicatorView];
             }
         }];
    }
    
    if (self.mazeManager.yoursTopMazeItems == nil)
    {
        NSLog(@"downloading other yours");
        
        [self.mazeManager getYoursMazesWithCompletionHandler: ^
         {
             NSLog(@"downloaded other yours");
             
             if (self.selectedSegmentIndex == 2)
             {
                 [self.tableView reloadData];
                 [self refreshActivityIndicatorView];
             }
         }];
    }
}

- (IBAction)highestRatedButtonTouchDown: (id)sender
{
	if (self.selectedSegmentIndex != 0)
	{
        self.selectedSegmentIndex = 0;
		
        [self refreshSegments];
        [self.tableView reloadData];
        [self refreshActivityIndicatorView];
        
        [self downloadHighestRatedTopMazeItems];
	}
}

- (IBAction)newestButtonTouchDown: (id)sender
{
	if (self.selectedSegmentIndex != 1)
	{
        self.selectedSegmentIndex = 1;

		[self refreshSegments];
        [self.tableView reloadData];
        [self refreshActivityIndicatorView];

        [self downloadNewestTopMazeItems];
	}
}

- (IBAction)yoursButtonTouchDown: (id)sender
{
	if (self.selectedSegmentIndex != 2)
	{
        self.selectedSegmentIndex = 2;

		[self refreshSegments];
        [self.tableView reloadData];
        [self refreshActivityIndicatorView];

        [self downloadYoursTopMazeItems];
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

- (void)refreshActivityIndicatorView
{
    if ((self.selectedSegmentIndex == 0 && self.mazeManager.highestRatedTopMazeItems == nil) ||
        (self.selectedSegmentIndex == 1 && self.mazeManager.newestTopMazeItems == nil) ||
        (self.selectedSegmentIndex == 2 && self.mazeManager.yoursTopMazeItems == nil))
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
    
    [cell setupWithTopMazeItem1: topMazeItem1
                   topMazeItem2: topMazeItem2];
    
    return cell;
}

- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath 
{
	MATopMazeTableViewCell *cell = (MATopMazeTableViewCell *)[self.tableView cellForRowAtIndexPath: indexPath];
	
	int i = indexPath.row * 2 + (cell.selectedColumn - 1);
	
	if (i < self.currentTopMazeItems.count)
	{
        MATopMazeItem *topMazeItem = [self.currentTopMazeItems objectAtIndex: i];
        
        self.gameViewController.maze = topMazeItem.maze;
        [topMazeItem.maze decompressLocationsDataAndWallsData];
        
        [self.mainViewController transitionFromViewController: self
                                             toViewController: self.gameViewController
                                                   transition: MATransitionFlipFromLeft];
    }
}

- (IBAction)createButtonTouchDown: (id)sender
{
    [self.mazeManager cancelDownloads];
    
    if ([self.mazeManager allUserMazes].count == 0)
    {
        [self.mazeManager getUserMazesWithCompletionHandler: ^
        {
            if ([self.mazeManager allUserMazes].count == 0)
            {
                MAMaze *newMaze = [MAMaze newMazeWithCurrentUser: self.currentUser
                                                            rows: self.constants.rowsMin
                                                         columns: self.constants.columnsMin
                                                 backgroundSound: nil
                                                     wallTexture: [self.textureManager textureWithTextureId: self.constants.alternatingBrickTextureId]
                                                    floorTexture: [self.textureManager textureWithTextureId: self.constants.lightSwirlMarbleTextureId]
                                                  ceilingTexture: [self.textureManager textureWithTextureId: self.constants.creamyWhiteMarbleTextureId]];
                
                [self.mazeManager addMaze: newMaze];
                
                self.mazeManager.isFirstUserMazeSizeChosen = NO;

                self.createViewController.maze = self.mazeManager.firstUserMaze;
                
                [self.mainViewController transitionFromViewController: self
                                                     toViewController: self.createViewController
                                                           transition: MATransitionCrossDissolve];
            }
            else
            {
                self.mazeManager.isFirstUserMazeSizeChosen = YES;
                
                self.editViewController.maze = self.mazeManager.firstUserMaze;
                
                [self.mainViewController transitionFromViewController: self
                                                     toViewController: self.editViewController
                                                           transition: MATransitionCrossDissolve];
            }
        }];
    }
    else
    {
        if (self.mazeManager.isFirstUserMazeSizeChosen == NO)
        {
            self.createViewController.maze = self.mazeManager.firstUserMaze;

            [self.mainViewController transitionFromViewController: self
                                                 toViewController: self.createViewController
                                                       transition: MATransitionCrossDissolve];
        }
        else
        {
            self.editViewController.maze = self.mazeManager.firstUserMaze;

            [self.mainViewController transitionFromViewController: self
                                                 toViewController: self.editViewController
                                                       transition: MATransitionCrossDissolve];
        }
    }
}

@end























