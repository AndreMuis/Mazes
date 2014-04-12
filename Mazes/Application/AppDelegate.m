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

@interface AppDelegate ()

@property (readonly, strong, nonatomic) Reachability *reachability;

@property (readonly, strong, nonatomic) MAColors *colors;
@property (readonly, strong, nonatomic) MAEventManager *eventManager;
@property (readonly, strong, nonatomic) MASettings *settings;
@property (readonly, strong, nonatomic) MASoundManager *soundManager;
@property (readonly, strong, nonatomic) MATextureManager *textureManager;

@property (readonly, strong, nonatomic) MACreateViewController *createViewController;
@property (readonly, strong, nonatomic) MADesignViewController *designViewController;
@property (readonly, strong, nonatomic) MAGameViewController *gameViewController;
@property (readonly, strong, nonatomic) MAMainViewController *mainViewController;
@property (readonly, strong, nonatomic) MATopMazesViewController *topMazesViewController;

@property (readonly, strong, nonatomic) ADBannerView *bannerView;

@end

@implementation AppDelegate

- (BOOL)application: (UIApplication *)application didFinishLaunchingWithOptions: (NSDictionary *)launchOptions
{
    [self startAnalytics];
    [self startCrashReporting];
    
    [self setupAppObjects];
    
    [self setupReachability];

    [self autologin];
    
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
    
    _colors = [[MAColors alloc] init];
    _eventManager = [[MAEventManager alloc] init];
    _mazeManager = [[MAMazeManager alloc] initWithWebServices: self.webServices];
    _settings = [[MASettings alloc] init];
    _soundManager = nil;
    _styles = [[MAStyles alloc] initWithColors: self.colors];
    _textureManager = nil;
    
    _bannerView = [[ADBannerView alloc] init];
    self.bannerView.delegate = self;
    
    _createViewController = [[MACreateViewController alloc] initWithMazeManager: self.mazeManager
                                                                 textureManager: self.textureManager
                                                                         styles: self.styles];
    
    _designViewController = [[MADesignViewController alloc] initWithWebServices: self.webServices
                                                                   eventManager: self.eventManager
                                                                    mazeManager: self.mazeManager
                                                                   soundManager: self.soundManager
                                                                 textureManager: self.textureManager
                                                                       settings: self.settings
                                                                         colors: self.colors
                                                                         styles: self.styles];
    
    _gameViewController = [[MAGameViewController alloc] initWithWebServices: self.webServices
                                                                mazeManager: self.mazeManager
                                                             textureManager: self.textureManager
                                                               soundManager: self.soundManager
                                                                     styles: self.styles
                                                                 bannerView: self.bannerView];
    
    _mainViewController = [[MAMainViewController alloc] initWithStyles: self.styles
                                                                colors: self.colors];
    
    _topMazesViewController = [[MATopMazesViewController alloc] initWithWebServices: self.webServices
                                                                        mazeManager: self.mazeManager
                                                                     textureManager: self.textureManager
                                                                       soundManager: self.soundManager
                                                                             styles: self.styles
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

- (void)setupReachability
{
    __weak AppDelegate *weakAppDelegate = self;
    
    self.reachability.reachableBlock = ^(Reachability *reachability)
    {
        if (weakAppDelegate.webServices.hasAttemptedFirstLogin == YES)
        {
            if (weakAppDelegate.webServices.loggedIn == NO)
            {
                [weakAppDelegate autologin];
            }
            else
            {
                if (weakAppDelegate.webServices.versionChecked == NO)
                {
                    [weakAppDelegate checkVersion];
                }
                
                if (weakAppDelegate.textureManager == nil)
                {
                    [weakAppDelegate downloadTextures];
                }

                if (weakAppDelegate.soundManager == nil)
                {
                    [weakAppDelegate downloadSounds];
                }
            }
        }
    };
    
    self.reachability.unreachableBlock = ^(Reachability *reachability)
    {
        UIAlertView *noInternetAlertView = [[UIAlertView alloc] initWithTitle: @""
                                                                      message: MANoInternetMessage
                                                                     delegate: nil
                                                            cancelButtonTitle: @"OK"
                                                            otherButtonTitles: nil];
        [noInternetAlertView show];
    };
    
    [self.reachability startNotifier];
}

- (void)autologin
{
    [self.webServices autologinWithCompletionHandler: ^(NSError *error)
    {
        if (error == nil)
        {
            [self.topMazesViewController downloadTopMazeSummaries];
             
            [self checkVersion];
            [self downloadTextures];
            [self downloadSounds];
        }
        else if (self.reachability.isReachable == YES)
        {
            UIAlertView *requestErrorUnknownAlertView = [[UIAlertView alloc] initWithTitle: @""
                                                                                   message: MARequestErrorUnknownMessage
                                                                                  delegate: nil
                                                                         cancelButtonTitle: @"OK"
                                                                         otherButtonTitles: nil];
            [requestErrorUnknownAlertView show];
        }
    }];
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
                
                UIAlertView *appVersionOutdatedAlertView = [[UIAlertView alloc] initWithTitle: @""
                                                                                      message: message
                                                                                     delegate: nil
                                                                            cancelButtonTitle: @"OK"
                                                                            otherButtonTitles: nil];
                [appVersionOutdatedAlertView show];
            }
        }
        else if (self.reachability.isReachable == YES)
        {
            UIAlertView *requestErrorUnknownAlertView = [[UIAlertView alloc] initWithTitle: @""
                                                                                   message: MARequestErrorUnknownMessage
                                                                                  delegate: nil
                                                                         cancelButtonTitle: @"OK"
                                                                         otherButtonTitles: nil];
            [requestErrorUnknownAlertView show];
        }
    }];
}

- (void)downloadTextures
{
    [self.webServices getTexturesWithCompletionHandler: ^(NSArray *textures, NSError *error)
    {
        if (error == nil)
        {
            _textureManager = [[MATextureManager alloc] initWithTextures: textures];
            
            [self.gameViewController setup];
        }
        else if (self.reachability.isReachable == YES)
        {
            UIAlertView *requestErrorUnknownAlertView = [[UIAlertView alloc] initWithTitle: @""
                                                                                   message: MARequestErrorUnknownMessage
                                                                                  delegate: nil
                                                                         cancelButtonTitle: @"OK"
                                                                         otherButtonTitles: nil];
            [requestErrorUnknownAlertView show];
        }
    }];
}

- (void)downloadSounds
{
    [self.webServices getSoundsWithCompletionHandler: ^(NSArray *sounds, NSError *error)
    {
        if (error == nil)
        {
            _soundManager = [[MASoundManager alloc] initWithSounds: sounds];
            
            [self.gameViewController setup];
        }
        else if (self.reachability.isReachable == YES)
        {
            UIAlertView *requestErrorUnknownAlertView = [[UIAlertView alloc] initWithTitle: @""
                                                                                   message: MARequestErrorUnknownMessage
                                                                                  delegate: nil
                                                                         cancelButtonTitle: @"OK"
                                                                         otherButtonTitles: nil];
            [requestErrorUnknownAlertView show];
        }
    }];
}

- (void)setupUI
{
    self.window = [[UIWindow alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
    
    self.window.rootViewController = self.mainViewController;
    [self.window makeKeyAndVisible];
}

- (void)bannerViewDidLoadAd: (ADBannerView *)banner
{
    [Flurry logEvent: @"bannerViewDidLoadAd:"
      withParameters: @{[[NSLocale currentLocale] localeIdentifier] : @"localeIdentifier"}];
}

- (void)bannerView: (ADBannerView *)banner didFailToReceiveAdWithError: (NSError *)error
{
    [Flurry logEvent: @"bannerView: didFailToReceiveAdWithError:"
      withParameters: @{[[NSLocale currentLocale] localeIdentifier] : @"localeIdentifier", [error localizedDescription] : @"error"}];
}

- (void)applicationDidReceiveMemoryWarning: (UIApplication *)application
{
    [MAUtilities logWithClass: [self class] format: @"applicationDidReceiveMemoryWarning:"];
}

@end



















