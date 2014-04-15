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
#import "MADesignViewController.h"
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
@property (readwrite, assign, nonatomic) BOOL showingFullScreenAd;

@property (readwrite, assign, nonatomic) MATopMazeSummariesType selectedTopMazeSummariesType;
@property (readonly, strong, nonatomic) NSString *topMazeCellIdentifier;

@property (weak, nonatomic) IBOutlet UIImageView *highestRatedImageView;
@property (weak, nonatomic) IBOutlet UIImageView *newestImageView;
@property (weak, nonatomic) IBOutlet UIImageView *yoursImageView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@property (weak, nonatomic) IBOutlet UIImageView *createImageView;
@property (weak, nonatomic) IBOutlet UIButton *createButton;

@property (readonly, strong, nonatomic) UIAlertView *downloadTopMazeSummariesErrorAlertView;
@property (readonly, strong, nonatomic) UIAlertView *saveMazeRatingErrorAlertView;
@property (readonly, strong, nonatomic) UIAlertView *downloadUserMazeErrorAlertView;

@end

@implementation MATopMazesViewController

- (id)initWithWebServices: (MAWebServices *)webServices
              mazeManager: (MAMazeManager *)mazeManager
           textureManager: (MATextureManager *)textureManager
             soundManager: (MASoundManager *)soundManager
               bannerView: (ADBannerView *)bannerView;
{
    self = [[MATopMazesViewController alloc] initWithNibName: NSStringFromClass([self class]) bundle: nil];
    
    if (self)
    {
        _webServices = webServices;
        
        _mazeManager = mazeManager;
        _soundManager = soundManager;
        _styles = [MAStyles styles];
        _textureManager = textureManager;
        
        _bannerView = bannerView;

        _showingFullScreenAd = NO;
        
        _selectedTopMazeSummariesType = MATopMazeSummariesHighestRated;
        _topMazeCellIdentifier = @"TopMazeTableViewCell";
        
        _downloadTopMazeSummariesErrorAlertView = [[UIAlertView alloc] initWithTitle: @""
                                                                             message: MADownloadTopMazesSummariesErrorMessage
                                                                            delegate: self
                                                                   cancelButtonTitle: @"OK"
                                                                   otherButtonTitles: nil];
        
        _saveMazeRatingErrorAlertView = [[UIAlertView alloc] initWithTitle: @""
                                                                   message: MASaveMazeRatingErrorMessage
                                                                  delegate: self
                                                         cancelButtonTitle: @"OK"
                                                         otherButtonTitles: nil];
        
        _downloadUserMazeErrorAlertView = [[UIAlertView alloc] initWithTitle: @""
                                                                   message: MADownloadUserMazeErrorMessage
                                                                  delegate: self
                                                         cancelButtonTitle: @"OK"
                                                         otherButtonTitles: nil];
    }
    
    return self;
}

- (void)observeValueForKeyPath: (NSString *)keyPath ofObject: (id)object change: (NSDictionary *)change context: (void *)context
{
    if (object == self.webServices && [keyPath isEqualToString: MAWebServicesIsLoggedInKeyPath] == YES)
    {
        BOOL isLoggedIn = [change[@"new"] boolValue];
        
        if (isLoggedIn == YES)
        {
            [self downloadTopMazeSummariesWithType: self.selectedTopMazeSummariesType];
            self.createButton.enabled = YES;
        }        
    }
    else
    {
        [MAUtilities logWithClass: [self class] format: @"Change of value for keyPath: %@ of object: %@ not handled.", keyPath, object];
    }
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.tableView.backgroundColor = self.styles.topMazesScreen.tableBackgroundColor;
    self.createButton.enabled = NO;
    
    self.activityIndicatorView.color = self.styles.activityIndicator.color;
}

- (void)viewWillAppear: (BOOL)animated
{
	[super viewWillAppear: animated];

    if (self.showingFullScreenAd == NO)
    {
        [self refreshSegments];
        [self refreshActivityIndicatorView];

        if ([self.mazeManager isDownloadingTopMazeSummariesOfType: self.selectedTopMazeSummariesType] == NO &&
            self.webServices.isLoggedIn == YES)
        {
            [self downloadTopMazeSummariesWithType: self.selectedTopMazeSummariesType];
        }

        if ([self.bannerView isDescendantOfView: self.view] == NO)
        {
            self.bannerView.frame = CGRectMake(self.bannerView.frame.origin.x,
                                               self.tableView.frame.origin.y + self.tableView.frame.size.height,
                                               self.bannerView.frame.size.width,
                                               self.bannerView.frame.size.height);
            self.bannerView.delegate = self;
            
            [self.view addSubview: self.bannerView];
        }
    }
}

- (BOOL)bannerViewActionShouldBegin: (ADBannerView *)banner willLeaveApplication: (BOOL)willLeave
{
    self.showingFullScreenAd = YES;
    return YES;
}

- (void)bannerViewActionDidFinish: (ADBannerView *)banner
{
    self.showingFullScreenAd = NO;
}

- (IBAction)highestRatedButtonTouchDown: (id)sender
{
    self.selectedTopMazeSummariesType = MATopMazeSummariesHighestRated;
    
    [self refreshSegments];
    [self.tableView reloadData];
    [self refreshActivityIndicatorView];
    
    if ([self.mazeManager isDownloadingTopMazeSummariesOfType: MATopMazeSummariesHighestRated] == NO)
    {
        [self downloadTopMazeSummariesWithType: MATopMazeSummariesHighestRated];
    }
}

- (IBAction)newestButtonTouchDown: (id)sender
{
    self.selectedTopMazeSummariesType = MATopMazeSummariesNewest;

    [self refreshSegments];
    [self.tableView reloadData];
    [self refreshActivityIndicatorView];

    if ([self.mazeManager isDownloadingTopMazeSummariesOfType: MATopMazeSummariesNewest] == NO)
    {
        [self downloadTopMazeSummariesWithType: MATopMazeSummariesNewest];
    }
}

- (IBAction)yoursButtonTouchDown: (id)sender
{
    self.selectedTopMazeSummariesType = MATopMazeSummariesYours;

    [self refreshSegments];
    [self.tableView reloadData];
    [self refreshActivityIndicatorView];

    if ([self.mazeManager isDownloadingTopMazeSummariesOfType: MATopMazeSummariesYours] == NO)
    {
        [self downloadTopMazeSummariesWithType: MATopMazeSummariesYours];
    }
}

- (void)downloadTopMazeSummariesWithType: (MATopMazeSummariesType)topMazeSummariesType
{
    [self.mazeManager downloadTopMazeSummariesWithType: topMazeSummariesType completionHandler: ^(NSError *error)
     {
         if (error == nil)
         {
             if (self.selectedTopMazeSummariesType == topMazeSummariesType)
             {
                 [self.tableView reloadData];
                 [self refreshActivityIndicatorView];
             }
             
             if ([self.mazeManager topMazeSummariesOfType: MATopMazeSummariesHighestRated] == nil &&
                 [self.mazeManager isDownloadingTopMazeSummariesOfType: MATopMazeSummariesHighestRated] == NO)
             {
                 [self downloadTopMazeSummariesWithType: MATopMazeSummariesHighestRated];
             }
             
             if ([self.mazeManager topMazeSummariesOfType: MATopMazeSummariesNewest] == nil &&
                 [self.mazeManager isDownloadingTopMazeSummariesOfType: MATopMazeSummariesNewest] == NO)
             {
                 [self downloadTopMazeSummariesWithType: MATopMazeSummariesNewest];
             }
             
             if ([self.mazeManager topMazeSummariesOfType: MATopMazeSummariesYours] == nil &&
                 [self.mazeManager isDownloadingTopMazeSummariesOfType: MATopMazeSummariesYours] == NO)
             {
                 [self downloadTopMazeSummariesWithType: MATopMazeSummariesYours];
             }
         }
         else
         {
             [self.downloadTopMazeSummariesErrorAlertView show];
         }
     }];
}

- (void)refreshSegments
{
	if (self.selectedTopMazeSummariesType == MATopMazeSummariesHighestRated)
    {
		self.highestRatedImageView.image = [UIImage imageNamed: @"btnHighestRatedOrange.png"];
    }
	else
    {
		self.highestRatedImageView.image = [UIImage imageNamed: @"btnHighestRatedBlue.png"];
    }
    
	if (self.selectedTopMazeSummariesType == MATopMazeSummariesNewest)
    {
		self.newestImageView.image = [UIImage imageNamed: @"btnNewestOrange.png"];
    }
	else
    {
		self.newestImageView.image = [UIImage imageNamed: @"btnNewestBlue.png"];
    }
    
	if (self.selectedTopMazeSummariesType == MATopMazeSummariesYours)
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
	
    NSArray *topMazeSummaries = [self.mazeManager topMazeSummariesOfType: self.selectedTopMazeSummariesType];
    
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
    
    NSArray *topMazeSummaries = [self.mazeManager topMazeSummariesOfType: self.selectedTopMazeSummariesType];

    MAMazeSummary *mazeSummary1 = [topMazeSummaries objectAtIndex: 2 * indexPath.row];
    
    MAMazeSummary *mazeSummary2 = nil;
    if (2 * indexPath.row + 1 <= topMazeSummaries.count - 1)
    {
        mazeSummary2 = [topMazeSummaries objectAtIndex: 2 * indexPath.row + 1];
    }
    
    [cell setupWithDelegate: self
                webServices: self.webServices
                mazeManager: self.mazeManager
               mazeSummary1: mazeSummary1
               mazeSummary2: mazeSummary2];
    
    return cell;
}

- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath 
{
	MATopMazeTableViewCell *cell = (MATopMazeTableViewCell *)[self.tableView cellForRowAtIndexPath: indexPath];
	
	int i = indexPath.row * 2 + (cell.selectedColumn - 1);
	
    NSArray *topMazeSummaries = [self.mazeManager topMazeSummariesOfType: self.selectedTopMazeSummariesType];

	if (i < topMazeSummaries.count)
	{
        self.gameViewController.mazeSummary = [topMazeSummaries objectAtIndex: i];
        
        [self.mainViewController transitionFromViewController: self
                                             toViewController: self.gameViewController
                                                   transition: MATransitionFlipFromRight];
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
        if (error == nil)
        {
            BOOL refreshMazeSummaries = NO;
            
            NSArray *topMazeSummaries = [self.mazeManager topMazeSummariesOfType: self.selectedTopMazeSummariesType];

            for (MAMazeSummary *mazeSummary in topMazeSummaries)
            {
                if ([mazeSummary.mazeId isEqualToString: mazeId] == YES)
                {
                    refreshMazeSummaries = YES;
                }
            }
            
            if (refreshMazeSummaries == YES)
            {
                [self downloadTopMazeSummariesWithType: self.selectedTopMazeSummariesType];
            }
        }
        else
        {
            [self.saveMazeRatingErrorAlertView show];
        }
    }];
}

- (void)alertView: (UIAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    if (alertView == self.downloadTopMazeSummariesErrorAlertView)
    {
        ;
    }
    else if (alertView == self.saveMazeRatingErrorAlertView)
    {
        ;
    }
    else
    {
        [MAUtilities logWithClass: [self class] format: [NSString stringWithFormat: @"AlertView not handled. AlertView: %@", alertView]];
    }
}

- (void)refreshActivityIndicatorView
{
    if ((self.selectedTopMazeSummariesType == MATopMazeSummariesHighestRated && [self.mazeManager topMazeSummariesOfType: MATopMazeSummariesHighestRated] == nil) ||
        (self.selectedTopMazeSummariesType == MATopMazeSummariesNewest && [self.mazeManager topMazeSummariesOfType: MATopMazeSummariesNewest] == nil) ||
        (self.selectedTopMazeSummariesType == MATopMazeSummariesYours && [self.mazeManager topMazeSummariesOfType: MATopMazeSummariesYours] == nil))
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
            if (error == nil)
            {
                if (userMazes.count == 0)
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
                    for (MAMaze *userMaze in userMazes)
                    {
                        [self.mazeManager addMaze: userMaze];
                    }
                    
                    self.mazeManager.isFirstUserMazeSizeChosen = YES;
                    
                    self.designViewController.maze = self.mazeManager.firstUserMaze;
                    
                    [self.mainViewController transitionFromViewController: self
                                                         toViewController: self.designViewController
                                                               transition: MATransitionCrossDissolve];
                }
            }
            else
            {
                [self.downloadUserMazeErrorAlertView show];
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
            self.designViewController.maze = self.mazeManager.firstUserMaze;

            [self.mainViewController transitionFromViewController: self
                                                 toViewController: self.designViewController
                                                       transition: MATransitionCrossDissolve];
        }
    }
}

@end























