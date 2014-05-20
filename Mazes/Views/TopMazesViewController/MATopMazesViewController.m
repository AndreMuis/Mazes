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
#import "MAGameKit.h"
#import "MAGameKitDelegate.h"
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

@interface MATopMazesViewController () <UITableViewDataSource, UITableViewDelegate, MAGameKitDelegate>

@property (readonly, strong, nonatomic) Reachability *reachability;
@property (readonly, strong, nonatomic) MAWebServices *webServices;

@property (readonly, strong, nonatomic) MAGameKit *gameKit;
@property (readonly, strong, nonatomic) MAMazeManager *mazeManager;
@property (readonly, strong, nonatomic) MASoundManager *soundManager;
@property (readonly, strong, nonatomic) MAStyles *styles;
@property (readonly, strong, nonatomic) MATextureManager *textureManager;

@property (readwrite, strong, nonatomic) ADBannerView *bannerView;

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

- (id)initWithReachability: (Reachability *)reachability
               webServices: (MAWebServices *)webServices
               mazeManager: (MAMazeManager *)mazeManager
            textureManager: (MATextureManager *)textureManager
              soundManager: (MASoundManager *)soundManager
{
    self = [[MATopMazesViewController alloc] initWithNibName: NSStringFromClass([self class]) bundle: nil];
    
    if (self)
    {
        _reachability = reachability;
        _webServices = webServices;
        
        _gameKit = [MAGameKit gameKitWithDelegate: self];
        _mazeManager = mazeManager;
        _soundManager = soundManager;
        _styles = [MAStyles styles];
        _textureManager = textureManager;
        
        _bannerView = nil;
        
        _selectedTopMazeSummariesType = MATopMazeSummariesHighestRated;
        _topMazeCellIdentifier = @"TopMazeTableViewCell";
        
        _downloadTopMazeSummariesErrorAlertView = [[UIAlertView alloc] initWithTitle: @""
                                                                             message: @""
                                                                            delegate: nil
                                                                   cancelButtonTitle: @"OK"
                                                                   otherButtonTitles: nil];
        
        _saveMazeRatingErrorAlertView = [[UIAlertView alloc] initWithTitle: @""
                                                                   message: @""
                                                                  delegate: nil
                                                         cancelButtonTitle: @"OK"
                                                         otherButtonTitles: nil];
        
        _downloadUserMazeErrorAlertView = [[UIAlertView alloc] initWithTitle: @""
                                                                     message: @""
                                                                    delegate: nil
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
        [MAUtilities logWithClass: [self class]
                          message: @"Change of value for object's keyPath not handled."
                       parameters: @{@"keyPath" : keyPath,
                                     @"object" : object}];
    }
}

#pragma mark - UIViewController

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

    if (self.bannerView == nil)
    {
        self.bannerView = [[ADBannerView alloc] init];
    }

    if (self.bannerView.bannerViewActionInProgress == NO)
    {
        [self refreshSegments];
        [self refreshActivityIndicatorView];

        if ([self.mazeManager isDownloadingTopMazeSummariesOfType: self.selectedTopMazeSummariesType] == NO &&
            self.webServices.isLoggedIn == YES)
        {
            [self downloadTopMazeSummariesWithType: self.selectedTopMazeSummariesType];
        }

        self.bannerView.delegate = self;
        
        
        
        [self.gameKit setupAuthenticateHandler];
        
        
        
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (self.bannerView.bannerLoaded == YES && [self.bannerView isDescendantOfView: self.view] == NO)
    {
        [self addBannerView];
    }
}

#pragma mark - ADBannerViewDelegate

- (void)bannerViewDidLoadAd: (ADBannerView *)banner
{
    if ([self.bannerView isDescendantOfView: self.view] == NO)
    {
        [self addBannerView];
    }
}

- (void)bannerView: (ADBannerView *)banner didFailToReceiveAdWithError: (NSError *)error
{
    [MAUtilities logWithClass: [self class]
                      message: @"BannerView did fail to receive ad."
                   parameters: @{@"error" : error}];
}

#pragma mark -

- (void)addBannerView
{
    self.bannerView.frame = CGRectMake(self.bannerView.frame.origin.x,
                                       self.tableView.frame.origin.y + self.tableView.frame.size.height,
                                       self.bannerView.frame.size.width,
                                       self.bannerView.frame.size.height);
    
    [self.view addSubview: self.bannerView];
}

- (void)removeAndDestroyBannerView
{
    [self.bannerView removeFromSuperview];
    self.bannerView.delegate = nil;
    self.bannerView = nil;
}


- (IBAction)highestRatedButtonTouchDown: (id)sender
{
    self.selectedTopMazeSummariesType = MATopMazeSummariesHighestRated;
    
    [self refreshSegments];
    [self.tableView reloadData];
    [self refreshActivityIndicatorView];
    
    if ([self.mazeManager isDownloadingTopMazeSummariesOfType: MATopMazeSummariesHighestRated] == NO && self.webServices.isLoggedIn == YES)
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

    if ([self.mazeManager isDownloadingTopMazeSummariesOfType: MATopMazeSummariesNewest] == NO && self.webServices.isLoggedIn == YES)
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

    if ([self.mazeManager isDownloadingTopMazeSummariesOfType: MATopMazeSummariesYours] == NO && self.webServices.isLoggedIn == YES)
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
             if (topMazeSummariesType == self.selectedTopMazeSummariesType)
             {
                 NSString *requestErrorMessage = [MAUtilities requestErrorMessageWithRequestDescription: MARequestDescriptionDownloadTopMazesSummaries
                                                                                           reachability: self.reachability
                                                                                           userCanRetry: YES];
                 self.downloadTopMazeSummariesErrorAlertView.message = requestErrorMessage;
             
                 [self.downloadTopMazeSummariesErrorAlertView show];
             }
         }
     }];
}

- (void)refreshSegments
{
	if (self.selectedTopMazeSummariesType == MATopMazeSummariesHighestRated)
    {
		self.highestRatedImageView.image = [UIImage imageNamed: @"HighestRatedButtonOrangeHighlighted.png"];
    }
	else
    {
		self.highestRatedImageView.image = [UIImage imageNamed: @"HighestRatedButtonBlueUnhighlighted.png"];
    }
    
	if (self.selectedTopMazeSummariesType == MATopMazeSummariesNewest)
    {
		self.newestImageView.image = [UIImage imageNamed: @"NewestButtonOrangeHighlighted.png"];
    }
	else
    {
		self.newestImageView.image = [UIImage imageNamed: @"NewestButtonBlueUnhighlighted.png"];
    }
    
	if (self.selectedTopMazeSummariesType == MATopMazeSummariesYours)
    {
		self.yoursImageView.image = [UIImage imageNamed: @"YoursButtonOrangeHighlighted.png"];
    }
	else
    {
		self.yoursImageView.image = [UIImage imageNamed: @"YoursButtonBlueUnhighlighted.png"];
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
    if (2 * (NSUInteger)indexPath.row + 1 <= topMazeSummaries.count - 1)
    {
        mazeSummary2 = [topMazeSummaries objectAtIndex: 2 * indexPath.row + 1];
    }
    
    [cell setupWithDelegate: self
               mazeSummary1: mazeSummary1
               mazeSummary2: mazeSummary2];
    
    return cell;
}

- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath 
{
    if (self.mainViewController.isPerformingTransition == NO)
    {
        MATopMazeTableViewCell *cell = (MATopMazeTableViewCell *)[self.tableView cellForRowAtIndexPath: indexPath];
        
        NSUInteger i = indexPath.row * 2 + (cell.selectedColumn - 1);
        
        NSArray *topMazeSummaries = [self.mazeManager topMazeSummariesOfType: self.selectedTopMazeSummariesType];

        if (i < topMazeSummaries.count)
        {
            self.gameViewController.mazeSummary = [topMazeSummaries objectAtIndex: i];
            self.gameViewController.bannerView = self.bannerView;
            
            [self.mainViewController transitionFromViewController: self
                                                 toViewController: self.gameViewController
                                                       transition: MATransitionFlipFromRight
                                                       completion: ^{}];
        }
    }
}

- (void)topMazeTableViewCell: (MATopMazeTableViewCell *)topMazeTableViewCell
             didUpdateRating: (float)rating
               forMazeWithId: (NSString *)mazeId
                        name: (NSString *)mazeName
{
    [self.webServices saveMazeRatingWithUserName: self.webServices.loggedInUser.userName
                                          mazeId: mazeId
                                        mazeName: mazeName
                                          rating: rating
                               completionHandler: ^(NSString *mazeName, NSError *error)
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
            NSString *requestErrorMessage = [MAUtilities requestErrorMessageWithRequestDescription: MARequestDescriptionSaveMazeRating
                                                                                      reachability: self.reachability
                                                                                      userCanRetry: YES];
            
            requestErrorMessage = [NSString stringWithFormat: requestErrorMessage, mazeName];
            self.saveMazeRatingErrorAlertView.message = requestErrorMessage;

            [self.saveMazeRatingErrorAlertView show];
        }
    }];
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

- (void)gameKit: (MAGameKit *)gameKit didReceiveAuthenticationViewController: (UIViewController *)authenticationViewController
{
    
}

- (void)gameKitLocalPlayerAuthenticationComplete: (MAGameKit *)gameKit
{
}

- (void)gameKit: (MAGameKit *)gameKit didFailLocalPlayerAuthenticationWithError: (NSError *)error
{

}

- (IBAction)createButtonTouchDown: (id)sender
{
    if (self.webServices.isDownloadingUserMazes == NO && self.mainViewController.isPerformingTransition == NO)
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

                        [self transitiolnToCreateViewController];
                    }
                    else
                    {
                        for (MAMaze *userMaze in userMazes)
                        {
                            [self.mazeManager addMaze: userMaze];
                        }
                        
                        self.mazeManager.isFirstUserMazeSizeChosen = YES;
                        
                        [self transitiolnToDesignViewController];
                    }
                }
                else
                {
                    NSString *requestErrorMessage = [MAUtilities requestErrorMessageWithRequestDescription: MARequestDescriptionDownloadUserMaze
                                                                                              reachability: self.reachability
                                                                                              userCanRetry: YES];
                    self.downloadUserMazeErrorAlertView.message = requestErrorMessage;
                    
                    [self.downloadUserMazeErrorAlertView show];
                }
            }];
        }
        else
        {
            if (self.mazeManager.isFirstUserMazeSizeChosen == NO)
            {
                [self transitiolnToCreateViewController];
            }
            else
            {
                [self transitiolnToDesignViewController];
            }
        }
    }
}

- (void)transitiolnToCreateViewController
{
    self.createViewController.maze = self.mazeManager.firstUserMaze;

    [self.mainViewController transitionFromViewController: self
                                         toViewController: self.createViewController
                                               transition: MATransitionTranslateBothLeft
                                               completion: ^
    {
        [self removeAndDestroyBannerView];
    }];
}

- (void)transitiolnToDesignViewController
{
    self.designViewController.maze = self.mazeManager.firstUserMaze;
    
    [self.mainViewController transitionFromViewController: self
                                         toViewController: self.designViewController
                                               transition: MATransitionTranslateBothLeft
                                               completion: ^
     {
         [self removeAndDestroyBannerView];
     }];
}

@end























