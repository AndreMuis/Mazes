//
//  AppDelegate.m
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import "AppDelegate.h"

#import "MAColors.h"
#import "MAConstants.h"
#import "MACreateViewController.h"
#import "MADesignViewController.h"
#import "MAEventManager.h"
#import "MAGameViewController.h"
#import "MAInfoPopupView.h"
#import "MALatestVersion.h"
#import "MAMainViewController.h"
#import "MAMazeManager.h"
#import "MASettings.h"
#import "MASoundManager.h"
#import "MAStyles.h"
#import "MATextureManager.h"
#import "MATopMazesViewController.h"
#import "MAUserCounter.h"
#import "MAUtilities.h"
#import "MAWebServices.h"

@interface AppDelegate () <UIAlertViewDelegate>

@property (readonly, strong, nonatomic) MAWebServices *webServices;
@property (readonly, strong, nonatomic) Reachability *reachability;

@property (readonly, strong, nonatomic) MAEventManager *eventManager;
@property (readonly, strong, nonatomic) MAMazeManager *mazeManager;
@property (readonly, strong, nonatomic) MASoundManager *soundManager;
@property (readonly, strong, nonatomic) MATextureManager *textureManager;

@property (readonly, strong, nonatomic) MACreateViewController *createViewController;
@property (readonly, strong, nonatomic) MADesignViewController *designViewController;
@property (readonly, strong, nonatomic) MAGameViewController *gameViewController;
@property (readonly, strong, nonatomic) MAMainViewController *mainViewController;
@property (readonly, strong, nonatomic) MATopMazesViewController *topMazesViewController;

@property (readonly, strong, nonatomic) ADBannerView *bannerView;

@property (readwrite, assign, nonatomic) BOOL versionChecked;

@property (readonly, strong, nonatomic) UIAlertView *appVersionOutdatedAlertView;
@property (readonly, strong, nonatomic) UIAlertView *noInternetAlertView;
@property (readonly, strong, nonatomic) UIAlertView *autologinErrorAlertView;
@property (readonly, strong, nonatomic) UIAlertView *checkVersionErrorAlertView;

@end

@implementation AppDelegate

- (BOOL)application: (UIApplication *)application didFinishLaunchingWithOptions: (NSDictionary *)launchOptions
{
    self.versionChecked = NO;
    
    _appVersionOutdatedAlertView = [[UIAlertView alloc] initWithTitle: @""
                                                              message: @""
                                                             delegate: self
                                                    cancelButtonTitle: @"OK"
                                                    otherButtonTitles: nil];

    _noInternetAlertView = [[UIAlertView alloc] initWithTitle: @""
                                                      message: MANoInternetMessage
                                                     delegate: self
                                            cancelButtonTitle: @"OK"
                                            otherButtonTitles: nil];

    _autologinErrorAlertView = [[UIAlertView alloc] initWithTitle: @""
                                                          message: MARequestErrorMessage
                                                         delegate: self
                                                cancelButtonTitle: @"Cancel"
                                                otherButtonTitles: @"Retry", nil];
    
    _checkVersionErrorAlertView = [[UIAlertView alloc] initWithTitle: @""
                                                             message: MARequestErrorMessage
                                                            delegate: self
                                                   cancelButtonTitle: @"Cancel"
                                                   otherButtonTitles: @"Retry", nil];

    [self startAnalytics];
    [self startCrashReporting];
    
    [self setupAppObjects];

    [self setupKVO];
    
    [self autologin];
    
    [self setupReachability];
    
    [self setupUI];

    return YES;
}

- (void)startAnalytics
{
    [Flurry startSession: MAFlurryAPIKey];
}

- (void)startCrashReporting
{
    #ifndef DEBUG
    [Crittercism enableWithAppID: MACrittercismAppId];
    #endif
}

- (void)setupAppObjects
{
    _reachability = [Reachability reachabilityWithHostname: MAReachabilityHostname];
    _webServices = [[MAWebServices alloc] initWithReachability: self.reachability];
    
    _eventManager = [[MAEventManager alloc] init];
    _mazeManager = [[MAMazeManager alloc] initWithWebServices: self.webServices];
    
    _soundManager = [MASoundManager soundManagerWithReachability: self.reachability
                                                     webServices: self.webServices];
    
    _textureManager = [MATextureManager textureManagerWithReachability: self.reachability
                                                           webServices: self.webServices];
    
    _bannerView = [[ADBannerView alloc] init];
    
    _mainViewController = [[MAMainViewController alloc] init];
    
    _createViewController = [[MACreateViewController alloc] initWithMazeManager: self.mazeManager
                                                                 textureManager: self.textureManager];
    
    _designViewController = [[MADesignViewController alloc] initWithWebServices: self.webServices
                                                                   eventManager: self.eventManager
                                                                    mazeManager: self.mazeManager
                                                                   soundManager: self.soundManager
                                                                 textureManager: self.textureManager];
    
    _gameViewController = [[MAGameViewController alloc] initWithWebServices: self.webServices
                                                                mazeManager: self.mazeManager
                                                             textureManager: self.textureManager
                                                               soundManager: self.soundManager
                                                                 bannerView: self.bannerView];
    
    _topMazesViewController = [[MATopMazesViewController alloc] initWithWebServices: self.webServices
                                                                        mazeManager: self.mazeManager
                                                                     textureManager: self.textureManager
                                                                       soundManager: self.soundManager
                                                                         bannerView: self.bannerView];
    
    self.createViewController.designViewController = self.designViewController;
    self.createViewController.mainViewController = self.mainViewController;
    self.createViewController.topMazesViewController = self.topMazesViewController;
    
    self.designViewController.mainViewController = self.mainViewController;
    self.designViewController.createViewController = self.createViewController;
    self.designViewController.topMazesViewController = self.topMazesViewController;
    
    self.gameViewController.mainViewController = self.mainViewController;
    self.gameViewController.topMazesViewController = self.topMazesViewController;
    
    self.mainViewController.rootViewController = self.topMazesViewController;
    
    self.topMazesViewController.createViewController = self.createViewController;
    self.topMazesViewController.designViewController = self.designViewController;
    self.topMazesViewController.gameViewController = self.gameViewController;
    self.topMazesViewController.mainViewController = self.mainViewController;
}

- (void)setupKVO
{
    [self.webServices addObserver: self.topMazesViewController
                       forKeyPath: MAWebServicesIsLoggedInKeyPath
                          options: NSKeyValueObservingOptionNew
                          context: NULL];
    
    [self.textureManager addObserver: self.gameViewController
                          forKeyPath: MASoundManagerCountKeyPath
                             options: NSKeyValueObservingOptionNew
                             context: NULL];
    
    [self.soundManager addObserver: self.gameViewController
                        forKeyPath: MATextureManagerCountKeyPath
                           options: NSKeyValueObservingOptionNew
                           context: NULL];
}

- (void)autologin
{
    [self.webServices autologinWithCompletionHandler: ^(NSError *error)
     {
         if (error == nil)
         {
             [self checkVersion];
             [self.textureManager downloadTextures];
             [self.soundManager downloadSounds];
         }
         else if (self.reachability.isReachable == YES)
         {
             [self.autologinErrorAlertView show];
         }
     }];
}

- (void)setupReachability
{
    __weak AppDelegate *weakAppDelegate = self;
    
    self.reachability.reachableBlock = ^(Reachability *reachability)
    {
        if (weakAppDelegate.webServices.isLoggingIn == NO)
        {
            if (weakAppDelegate.webServices.isLoggedIn == NO)
            {
                [weakAppDelegate autologin];
            }
            else
            {
                if (weakAppDelegate.versionChecked == NO)
                {
                    [weakAppDelegate checkVersion];
                }
                
                if (weakAppDelegate.textureManager.count == 0)
                {
                    [weakAppDelegate.textureManager downloadTextures];
                }

                if (weakAppDelegate.soundManager.count == 0)
                {
                    [weakAppDelegate.soundManager downloadSounds];
                }
            }
        }
    };
    
    self.reachability.unreachableBlock = ^(Reachability *reachability)
    {
        [weakAppDelegate.noInternetAlertView show];
    };
    
    [self.reachability startNotifier];
}

- (void)checkVersion
{
    [self.webServices getLatestVersionWithCompletionHandler: ^(MALatestVersion *latestVersion, NSError *error)
    {
        if (error == nil)
        {
            float appVersion = [[[[NSBundle mainBundle] infoDictionary] objectForKey: @"CFBundleShortVersionString"] floatValue];
             
            // NSLog(@"appVersion = %f, latestVersion = %f", appVersion, latestVersion.number);
             
            if (appVersion < latestVersion.latestVersion)
            {
                NSString *message = [NSString stringWithFormat: @"This app is version %0.1f. Version %0.1f is now available."
                                     "It is recommended that you upgrade to the latest version.", appVersion, latestVersion.latestVersion];
                
                self.appVersionOutdatedAlertView.message = message;
                
                [self.appVersionOutdatedAlertView show];
            }
        }
        else if (self.reachability.isReachable == YES)
        {
            [self.checkVersionErrorAlertView show];
        }
    }];
}

- (void)alertView: (UIAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    if (alertView == self.appVersionOutdatedAlertView)
    {
        ;
    }
    else if (alertView == self.noInternetAlertView)
    {
        ;
    }
    else if (alertView == self.autologinErrorAlertView && buttonIndex == 1)
    {
        [self autologin];
    }
    else if (alertView == self.checkVersionErrorAlertView && buttonIndex == 1)
    {
        [self checkVersion];
    }
    else
    {
        [MAUtilities logWithClass: [self class] format: [NSString stringWithFormat: @"AlertView not handled. AlertView: %@", alertView]];
    }
}

- (void)setupUI
{
    self.window = [[UIWindow alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
    
    self.window.rootViewController = self.mainViewController;
    [self.window makeKeyAndVisible];
}

- (void)applicationDidReceiveMemoryWarning: (UIApplication *)application
{
    [MAUtilities logWithClass: [self class] format: @"applicationDidReceiveMemoryWarning:"];
}

@end



















