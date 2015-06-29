//
//  MAGameKit.m
//  Mazes
//
//  Created by Andre Muis on 5/19/14.
//  Copyright (c) 2014 Andre Muis. All rights reserved.
//

#import "MAGameKit.h"

#import "MAGameKitDelegate.h"

@interface MAGameKit () <GKGameCenterControllerDelegate>

@property (readonly, weak, nonatomic) id<MAGameKitDelegate> delegate;

@property (readwrite, assign, nonatomic) NSUInteger mazeCompletionCount;

@end

@implementation MAGameKit

+ (instancetype)gameKit
{
    MAGameKit *gameKit = [[MAGameKit alloc] initWithDelegate: nil];
    
    return gameKit;
}

+ (instancetype)gameKitWithDelegate: (id<MAGameKitDelegate>)delegate
{
    MAGameKit *gameKit = [[MAGameKit alloc] initWithDelegate: delegate];
    
    return gameKit;
}

- (instancetype)initWithDelegate: (id<MAGameKitDelegate>)delegate
{
    self = [super init];
    
    if (self)
    {
        _delegate = delegate;
        
        _mazeCompletionCount = 0;
    }
    
    return self;
}

- (BOOL)isLocalPlayerAuthenticateHandlerSetup
{
    return [GKLocalPlayer localPlayer].authenticateHandler != nil;
}

- (BOOL)isLocalPlayerAuthenticated
{
    return [GKLocalPlayer localPlayer].authenticated;
}

- (void)setupAuthenticateHandler
{
    [GKLocalPlayer localPlayer].authenticateHandler = ^(UIViewController *viewController, NSError *error)
    {
        if (error == nil)
        {
            if (viewController != nil)
            {
                [self.delegate gameKit: self didReceiveAuthenticationViewController: viewController];
            }
            else
            {
                [self.delegate gameKitLocalPlayerAuthenticationComplete: self];
            }
        }
        else
        {
            [self.delegate gameKit: self didFailLocalPlayerAuthenticationWithError: error];
        }
    };
}

- (void)downloadMazeCompletionCountWithCompletion: (DownloadMazeCompletionCountCompletionHandler)handler
{
    /*
    [self.webServices getMazeCompletionCountWithUserName: self.webServices.loggedInUser.userName
                                       completionHandler: ^(NSUInteger count, NSError *error)
    {
        self.mazeCompletionCount = count;

        handler(error);
    }];
    */
}

- (void)reportMazeCompletionCountWithCompletion: (ReportMazeCompletionCountCompletionHandler)handler
{
    GKScore *score = [[GKScore alloc] init];
    score.value = self.mazeCompletionCount;
    
    [GKScore reportScores: @[score] withCompletionHandler: ^(NSError *error)
    {
        handler(error);
    }];
}

- (void)displayLeaderboardWithPresentingViewController: (UIViewController *)presentingViewController
{
    GKGameCenterViewController *leaderboardViewController = [[GKGameCenterViewController alloc] init];
    
    leaderboardViewController.viewState = GKGameCenterViewControllerStateLeaderboards;
    leaderboardViewController.gameCenterDelegate = self;
    
    [presentingViewController presentViewController: leaderboardViewController
                                           animated: YES
                                         completion: nil];
}

#pragma mark - GKGameCenterControllerDelegate

- (void)gameCenterViewControllerDidFinish: (GKGameCenterViewController *)gameCenterViewController
{
    [gameCenterViewController dismissViewControllerAnimated: YES
                                                 completion: nil];
}

#pragma mark -

@end




















