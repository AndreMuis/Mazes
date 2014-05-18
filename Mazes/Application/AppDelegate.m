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

@property (readonly, strong, nonatomic) Reachability *reachability;
@property (readonly, strong, nonatomic) MAWebServices *webServices;

@property (readonly, strong, nonatomic) MAEventManager *eventManager;
@property (readonly, strong, nonatomic) MAMazeManager *mazeManager;
@property (readonly, strong, nonatomic) MASoundManager *soundManager;
@property (readonly, strong, nonatomic) MATextureManager *textureManager;

@property (readonly, strong, nonatomic) MACreateViewController *createViewController;
@property (readonly, strong, nonatomic) MADesignViewController *designViewController;
@property (readonly, strong, nonatomic) MAGameViewController *gameViewController;
@property (readonly, strong, nonatomic) MAMainViewController *mainViewController;
@property (readonly, strong, nonatomic) MATopMazesViewController *topMazesViewController;

@property (readwrite, assign, nonatomic) BOOL versionChecked;

@property (readonly, strong, nonatomic) UIAlertView *appVersionOutdatedAlertView;
@property (readonly, strong, nonatomic) UIAlertView *autologinErrorAlertView;
@property (readonly, strong, nonatomic) UIAlertView *downloadTexturesErrorAlertView;
@property (readonly, strong, nonatomic) UIAlertView *downloadSoundsErrorAlertView;

@end

@implementation AppDelegate

// [label sizeToFit];
// view layout and setup code should (in my opinion) always go in UIView subclasses.
// http://www.alexruperez.com/ios-coding-best-practices
// asl_log
// NSUbiquitousKeyValueStoreDidChangeExternallyNotification

- (BOOL)application: (UIApplication *)application didFinishLaunchingWithOptions: (NSDictionary *)launchOptions
{
    self.versionChecked = NO;
    
    _appVersionOutdatedAlertView = [[UIAlertView alloc] initWithTitle: @""
                                                              message: @""
                                                             delegate: self
                                                    cancelButtonTitle: @"OK"
                                                    otherButtonTitles: nil];
    
    _autologinErrorAlertView = [[UIAlertView alloc] initWithTitle: @""
                                                          message: @""
                                                         delegate: self
                                                cancelButtonTitle: @"Retry"
                                                otherButtonTitles: nil];
    
    _downloadTexturesErrorAlertView = [[UIAlertView alloc] initWithTitle: @""
                                                                 message: @""
                                                                delegate: self
                                                       cancelButtonTitle: @"Retry"
                                                       otherButtonTitles: nil];

    _downloadSoundsErrorAlertView = [[UIAlertView alloc] initWithTitle: @""
                                                               message: @""
                                                              delegate: self
                                                     cancelButtonTitle: @"Retry"
                                                     otherButtonTitles: nil];
    
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
    [Crashlytics startWithAPIKey: MACrashlyticsAPIKey];
}

- (void)setupAppObjects
{
    _reachability = [Reachability reachabilityWithHostname: MAReachabilityHostname];
    _webServices = [[MAWebServices alloc] initWithReachability: self.reachability];
    
    _eventManager = [[MAEventManager alloc] init];
    _mazeManager = [[MAMazeManager alloc] initWithWebServices: self.webServices];
    
    _soundManager = [MASoundManager soundManagerWithWebServices: self.webServices];
    
    _textureManager = [MATextureManager textureManagerWithWebServices: self.webServices];
    
    _mainViewController = [[MAMainViewController alloc] init];
    
    _createViewController = [[MACreateViewController alloc] initWithMazeManager: self.mazeManager
                                                                 textureManager: self.textureManager];
    
    _designViewController = [[MADesignViewController alloc] initWithReachability: self.reachability
                                                                     webServices: self.webServices
                                                                    eventManager: self.eventManager
                                                                     mazeManager: self.mazeManager
                                                                    soundManager: self.soundManager
                                                                  textureManager: self.textureManager];
    
    _gameViewController = [[MAGameViewController alloc] initWithReachability: self.reachability
                                                                 webServices: self.webServices
                                                                 mazeManager: self.mazeManager
                                                              textureManager: self.textureManager
                                                                soundManager: self.soundManager];
    
    _topMazesViewController = [[MATopMazesViewController alloc] initWithReachability: self.reachability
                                                                         webServices: self.webServices
                                                                         mazeManager: self.mazeManager
                                                                      textureManager: self.textureManager
                                                                        soundManager: self.soundManager];
    
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
            
            [self downloadTextures];
            [self downloadSounds];
        }
        else
        {
            NSString *requestErrorMessage = [MAUtilities requestErrorMessageWithRequestDescription: MARequestDescriptionGeneric
                                                                                      reachability: self.reachability
                                                                                      userCanRetry: YES];
            self.autologinErrorAlertView.message = requestErrorMessage;
            
            [self.autologinErrorAlertView show];
        }
    }];
}

- (void)downloadTextures
{
    [self.textureManager downloadTexturesWithCompletionHandler: ^(NSError *error)
    {
        if (error == nil)
        {
            ;
        }
        else if (self.downloadSoundsErrorAlertView.visible == NO)
        {
            NSString *requestErrorMessage = [MAUtilities requestErrorMessageWithRequestDescription: MARequestDescriptionGeneric
                                                                                      reachability: self.reachability
                                                                                      userCanRetry: YES];
            self.downloadTexturesErrorAlertView.message = requestErrorMessage;
            
            [self.downloadTexturesErrorAlertView show];
        }
    }];
}

- (void)downloadSounds
{
    [self.soundManager downloadSoundsWithCompletionHandler: ^(NSError *error)
    {
        if (error == nil)
        {
            ;
        }
        else if (self.downloadTexturesErrorAlertView.visible == NO)
        {
            NSString *requestErrorMessage = [MAUtilities requestErrorMessageWithRequestDescription: MARequestDescriptionGeneric
                                                                                      reachability: self.reachability
                                                                                      userCanRetry: YES];
            self.downloadSoundsErrorAlertView.message = requestErrorMessage;

            [self.downloadSoundsErrorAlertView show];
        }
    }];
}

- (void)setupReachability
{
    [self.reachability startNotifier];
}

- (void)checkVersion
{
    [self.webServices getLatestVersionWithCompletionHandler: ^(MALatestVersion *latestVersion, NSError *error)
    {
        if (error == nil)
        {
            float appVersion = [[[[NSBundle mainBundle] infoDictionary] objectForKey: @"CFBundleShortVersionString"] floatValue];
             
            if (appVersion < latestVersion.latestVersion)
            {
                NSString *message = [NSString stringWithFormat: @"This app is version %0.1f. Version %0.1f is now available. "
                                     "It is recommended that you upgrade to the latest version.", appVersion, latestVersion.latestVersion];
                
                self.appVersionOutdatedAlertView.message = message;
                
                [self.appVersionOutdatedAlertView show];
            }
        }
        else
        {
            ;
        }
    }];
}

- (void)alertView: (UIAlertView *)alertView didDismissWithButtonIndex: (NSInteger)buttonIndex
{
    if (alertView == self.appVersionOutdatedAlertView)
    {
        ;
    }
    else if (alertView == self.autologinErrorAlertView)
    {
        [self autologin];
    }
    else if ((alertView == self.downloadTexturesErrorAlertView) ||
             (alertView == self.downloadSoundsErrorAlertView))
    {
        if (self.soundManager.count == 0)
        {
            [self downloadSounds];
        }
        
        if (self.textureManager.count == 0)
        {
            [self downloadTextures];
        }
    }
    else
    {
        [MAUtilities logWithClass: [self class]
                          message: @"alertView not handled."
                       parameters: @{@"alertView" : alertView}];
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
    [MAUtilities logWithClass: [self class]
                      message: @"applicationDidReceiveMemoryWarning"
                   parameters: @{}];
}

@end



















