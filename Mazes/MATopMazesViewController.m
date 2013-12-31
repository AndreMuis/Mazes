//
//  MATopMazesViewController.m
//  Mazes
//
//  Created by Andre Muis on 4/25/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import "MATopMazesViewController.h"

#import "MAActivityIndicatorStyle.h"
#import "MAConstants.h"
#import "MACreateViewController.h"
#import "MAEditViewController.h"
#import "MAGameViewController.h"
#import "MAMainViewController.h"
#import "MAMazeManager.h"
#import "MAMaze.h"
#import "MAMazeSummary.h"
#import "MARatingView.h"
#import "MASoundManager.h"
#import "MAStyles.h"
#import "MATextureManager.h"
#import "MATopMazeTableViewCell.h"
#import "MATopMazesScreenStyle.h"
#import "MATopMazesViewController.h"
#import "MAUtilities.h"
#import "MAWebServices.h"

@interface MATopMazesViewController () <UITableViewDataSource, UITableViewDelegate>

@property (readonly, strong, nonatomic) MAWebServices *webServices;

@property (readonly, strong, nonatomic) MAMazeManager *mazeManager;
@property (readonly, strong, nonatomic) MASoundManager *soundManager;
@property (readonly, strong, nonatomic) MAStyles *styles;
@property (readonly, strong, nonatomic) MATextureManager *textureManager;

@property (readonly, strong, nonatomic) ADBannerView *bannerView;

@property (readwrite, assign, nonatomic) MATopMazesType selectedTopMazesType;
@property (readonly, strong, nonatomic) NSString *topMazeCellIdentifier;

@property (weak, nonatomic) IBOutlet UIImageView *highestRatedImageView;
@property (weak, nonatomic) IBOutlet UIImageView *newestImageView;
@property (weak, nonatomic) IBOutlet UIImageView *yoursImageView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@property (weak, nonatomic) IBOutlet UIImageView *createImageView;
@property (weak, nonatomic) IBOutlet UIButton *createButton;

@end

@implementation MATopMazesViewController

- (id)initWithWebServices: (MAWebServices *)webServices
              mazeManager: (MAMazeManager *)mazeManager
           textureManager: (MATextureManager *)textureManager
             soundManager: (MASoundManager *)soundManager
                   styles: (MAStyles *)styles
               bannerView: (ADBannerView *)bannerView;
{
    self = [[MATopMazesViewController alloc] initWithNibName: NSStringFromClass([self class]) bundle: nil];
    
    if (self)
    {
        _webServices = webServices;
        
        _mazeManager = mazeManager;
        _soundManager = soundManager;
        _styles = styles;
        _textureManager = textureManager;
        
        _bannerView = bannerView;

        _selectedTopMazesType = MATopMazesHighestRated;
        _topMazeCellIdentifier = @"TopMazeTableViewCell";
    }
    
    return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.tableView.backgroundColor = self.styles.topMazesScreen.tableBackgroundColor;
    self.activityIndicatorView.color = self.styles.activityIndicator.color;
}

- (void)viewWillAppear: (BOOL)animated
{
	[super viewWillAppear: animated];

    [self refreshSegments];
    [self refreshActivityIndicatorView];

    if ([self.bannerView isDescendantOfView: self.view] == NO)
    {
        self.bannerView.frame = CGRectMake(self.bannerView.frame.origin.x,
                                           self.tableView.frame.origin.y + self.tableView.frame.size.height,
                                           self.bannerView.frame.size.width,
                                           self.bannerView.frame.size.height);
        
        [self.view addSubview: self.bannerView];
    }
}

- (void)downloadTopMazeSummaries
{
    [self downloadTopMazeSummariesWithType: MATopMazesHighestRated];
    [self downloadTopMazeSummariesWithType: MATopMazesNewest];
    [self downloadTopMazeSummariesWithType: MATopMazesYours];
}

- (void)downloadTopMazeSummariesWithType: (MATopMazesType)topMazesType
{
    [self.mazeManager downloadTopMazeSummariesWithType: topMazesType completionHandler: ^(NSError *error)
    {
        if (error == nil && self.selectedTopMazesType == topMazesType)
        {
            [self.tableView reloadData];
            [self refreshActivityIndicatorView];
        }
        else if (error != nil)
        {
        }
    }];
}

- (IBAction)highestRatedButtonTouchDown: (id)sender
{
    self.selectedTopMazesType = MATopMazesHighestRated;
    
    [self refreshSegments];
    [self.tableView reloadData];
    [self refreshActivityIndicatorView];
    
    [self downloadTopMazeSummariesWithType: MATopMazesHighestRated];

    
    
    [self downloadTopMazeSummariesWithType: MATopMazesNewest];
    [self downloadTopMazeSummariesWithType: MATopMazesYours];
}

- (IBAction)newestButtonTouchDown: (id)sender
{
    self.selectedTopMazesType = MATopMazesNewest;

    [self refreshSegments];
    [self.tableView reloadData];
    [self refreshActivityIndicatorView];

    [self downloadTopMazeSummariesWithType: MATopMazesNewest];
}

- (IBAction)yoursButtonTouchDown: (id)sender
{
    self.selectedTopMazesType = MATopMazesYours;

    [self refreshSegments];
    [self.tableView reloadData];
    [self refreshActivityIndicatorView];

    [self downloadTopMazeSummariesWithType: MATopMazesYours];
}

- (void)refreshSegments
{
	if (self.selectedTopMazesType == MATopMazesHighestRated)
    {
		self.highestRatedImageView.image = [UIImage imageNamed: @"btnHighestRatedOrange.png"];
    }
	else
    {
		self.highestRatedImageView.image = [UIImage imageNamed: @"btnHighestRatedBlue.png"];
    }
    
	if (self.selectedTopMazesType == MATopMazesNewest)
    {
		self.newestImageView.image = [UIImage imageNamed: @"btnNewestOrange.png"];
    }
	else
    {
		self.newestImageView.image = [UIImage imageNamed: @"btnNewestBlue.png"];
    }
    
	if (self.selectedTopMazesType == MATopMazesYours)
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
	
    NSArray *topMazeSummaries = [self.mazeManager topMazeSummariesOfType: self.selectedTopMazesType];
    
	if (topMazeSummaries == nil)
    {
		rows = 0;
    }
	else if (topMazeSummaries.count % 2 == 0)
    {
		rows = topMazeSummaries.count / 2;
    }
	else if (topMazeSummaries.count % 2 == 1)
    {
		rows = (topMazeSummaries.count + 1) / 2;
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
    
    NSArray *topMazeSummaries = [self.mazeManager topMazeSummariesOfType: self.selectedTopMazesType];

    MAMazeSummary *mazeSummary1 = [topMazeSummaries objectAtIndex: 2 * indexPath.row];
    
    MAMazeSummary *mazeSummary2 = nil;
    if (2 * indexPath.row + 1 <= topMazeSummaries.count - 1)
    {
        mazeSummary2 = [topMazeSummaries objectAtIndex: 2 * indexPath.row + 1];
    }
    
    [cell setupWithDelegate: self mazeSummary1: mazeSummary1 mazeSummary2: mazeSummary2];
    
    return cell;
}

- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath 
{
	MATopMazeTableViewCell *cell = (MATopMazeTableViewCell *)[self.tableView cellForRowAtIndexPath: indexPath];
	
	int i = indexPath.row * 2 + (cell.selectedColumn - 1);
	
    NSArray *topMazeSummaries = [self.mazeManager topMazeSummariesOfType: self.selectedTopMazesType];

	if (i < topMazeSummaries.count)
	{
        self.gameViewController.mazeSummary = [topMazeSummaries objectAtIndex: i];
        
        [self.mainViewController transitionFromViewController: self
                                             toViewController: self.gameViewController
                                                   transition: MATransitionFlipFromLeft];
    }
}

- (void)topMazeTableViewCell: (MATopMazeTableViewCell *)topMazeTableViewCell
             didUpdateRating: (float)rating
           forMazeWithMazeId: (NSString *)mazeId
{
    [self.webServices saveMazeRatingWithUserName: self.webServices.loggedInUser.userName
                                          mazeId: mazeId
                                          rating: rating
                               completionHandler: ^(NSError *error)
    {
        NSLog(@"%f", rating);
        
        if (error == nil)
        {
            BOOL refreshMazeSummaries = NO;
            
            NSArray *topMazeSummaries = [self.mazeManager topMazeSummariesOfType: self.selectedTopMazesType];

            for (MAMazeSummary *mazeSummary in topMazeSummaries)
            {
                if ([mazeSummary.mazeId isEqualToString: mazeId] == YES)
                {
                    refreshMazeSummaries = YES;
                }
            }
            
            if (refreshMazeSummaries == YES)
            {
                [self downloadTopMazeSummariesWithType: self.selectedTopMazesType];
            }
        }
        else
        {
            NSLog(@"ERROR: didUpdateRating");
        }
    }];
}

- (void)refreshActivityIndicatorView
{
    if ((self.selectedTopMazesType == MATopMazesHighestRated && [self.mazeManager topMazeSummariesOfType: MATopMazesHighestRated] == nil) ||
        (self.selectedTopMazesType == MATopMazesNewest && [self.mazeManager topMazeSummariesOfType: MATopMazesNewest] == nil) ||
        (self.selectedTopMazesType == MATopMazesYours && [self.mazeManager topMazeSummariesOfType: MATopMazesYours] == nil))
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

- (IBAction)createButtonTouchDown: (id)sender
{
    if ([self.mazeManager allUserMazes].count == 0)
    {
        [self.webServices getUserMazesWithCompletionHandler: ^(NSArray *userMazes, NSError *error)
        {
            if ([self.mazeManager allUserMazes].count == 0)
            {
                MAMaze *newMaze = [MAMaze mazeWithLoggedInUser: self.webServices.loggedInUser
                                                          rows: MARowsMin
                                                       columns: MAColumnsMin
                                               backgroundSound: nil
                                                   wallTexture: [self.textureManager textureWithTextureId: MAAlternatingBrickTextureId]
                                                  floorTexture: [self.textureManager textureWithTextureId: MALightSwirlMarbleTextureId]
                                                ceilingTexture: [self.textureManager textureWithTextureId: MACreamyWhiteMarbleTextureId]];
                
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























