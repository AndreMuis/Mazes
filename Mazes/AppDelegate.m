//
//  AppDelegate.m
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import "AppDelegate.h"

#import <AMFatFractal/AMFatFractal.h>
#import <CrittercismSDK/Crittercism.h>
#import <FlurrySDK/Flurry.h>

#import "MACloud.h"
#import "MAColors.h"
#import "MAConstants.h"
#import "MACreateViewController.h"
#import "MAEditViewController.h"
#import "MAEvents.h"
#import "MAGameViewController.h"
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

#import "MALocation.h"

@interface AppDelegate ()

@property (readonly, strong, nonatomic) AMFatFractal *amFatFractal;
@property (readonly, strong, nonatomic) FFUser *currentUser;

@property (readonly, strong, nonatomic) MACloud *cloud;
@property (readonly, strong, nonatomic) MAColors *colors;
@property (readonly, strong, nonatomic) MAConstants *constants;
@property (readonly, strong, nonatomic) MAEvents *events;
@property (readonly, strong, nonatomic) MAMazeManager *mazeManager;
@property (readonly, strong, nonatomic) MASettings *settings;
@property (readonly, strong, nonatomic) MASoundManager *soundManager;
@property (readonly, strong, nonatomic) MATextureManager *textureManager;

@property (readonly, strong, nonatomic) MACreateViewController *createViewController;
@property (readonly, strong, nonatomic) MAEditViewController *editViewController;
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

    self.cloud.username = @"TestUser3";
    self.cloud.password = @"password";
    
    [self loginWithCompletionHandler: ^
     {
         self.mazeManager.currentUser = self.currentUser;
         
         self.topMazesViewController.currentUser = self.currentUser;
         [self.topMazesViewController downloadTopMazeItems];
         
         [self checkVersion];
         [self downloadTextures];
         [self downloadSounds];
     }];
    
    [self setupUI];

    /*
     for (int i = 1; i <= 43; i = i + 1)
     {
     NSLog(@"%@", [MAUtilities uuid]);
     }
     */
    
    return YES;
}

- (void)startAnalytics
{
    [Flurry startSession: self.constants.flurryAPIKey];
}

- (void)startCrashReporting
{
    #ifndef DEBUG
    [Crittercism enableWithAppID: [MAConstants shared].crittercismAppId];
    #endif
}

- (void)setupAppObjects
{
    _constants = [[MAConstants alloc] init];
    
    _amFatFractal = [[AMFatFractal alloc] initWithBaseSSLURL: [self.constants.baseSSLURL absoluteString]
                                           retryDelaySeconds: self.constants.serverRetryDelaySecs];
    _currentUser = nil;
    
    _cloud = [[MACloud alloc] init];
    _colors = [[MAColors alloc] init];
    _events = [[MAEvents alloc] initWithConstants: self.constants];
    _mazeManager = [[MAMazeManager alloc] initWithAMFatFractal: self.amFatFractal];
    _settings = [[MASettings alloc] init];
    _soundManager = [[MASoundManager alloc] initWithAMFatFractal: self.amFatFractal];
    _styles = [[MAStyles alloc] initWithConstants: self.constants colors: self.colors];
    _textureManager = [[MATextureManager alloc] initWithAMFatFractal: self.amFatFractal];
    
    _bannerView = [[ADBannerView alloc] init];
    self.bannerView.delegate = self;
    
    _createViewController = [[MACreateViewController alloc] initWithConstants: self.constants
                                                                  mazeManager: self.mazeManager
                                                               textureManager: self.textureManager
                                                                       styles: self.styles];
    
    _editViewController = [[MAEditViewController alloc] initWithConstants: self.constants
                                                                   events: self.events
                                                              mazeManager: self.mazeManager
                                                             soundManager: self.soundManager
                                                           textureManager: self.textureManager
                                                                 settings: self.settings
                                                                   colors: self.colors
                                                                   styles: self.styles];
    
    _gameViewController = [[MAGameViewController alloc] initWithConstants: self.constants
                                                             soundManager: self.soundManager
                                                                   styles: self.styles
                                                           textureManager: self.textureManager
                                                               bannerView: self.bannerView];
    
    _mainViewController = [[MAMainViewController alloc] initWithStyles: self.styles];
    
    _topMazesViewController = [[MATopMazesViewController alloc] initWithAMFatFractal: self.amFatFractal
                                                                           constants: self.constants
                                                                         mazeManager: self.mazeManager
                                                                      textureManager: self.textureManager
                                                                        soundManager: self.soundManager
                                                                              styles: self.styles
                                                                          bannerView: self.bannerView];
    
    self.createViewController.editViewController = self.editViewController;
    self.createViewController.mainViewController = self.mainViewController;
    self.createViewController.topMazesViewController = self.topMazesViewController;
    
    self.editViewController.mainViewController = self.mainViewController;
    self.editViewController.createViewController = self.createViewController;
    self.editViewController.topMazesViewController = self.topMazesViewController;
    
    self.gameViewController.mainViewController = self.mainViewController;
    self.gameViewController.topMazesViewController = self.topMazesViewController;
    
    self.mainViewController.rootViewController = self.topMazesViewController;
    
    self.topMazesViewController.createViewController = self.createViewController;
    self.topMazesViewController.editViewController = self.editViewController;
    self.topMazesViewController.gameViewController = self.gameViewController;
    self.topMazesViewController.mainViewController = self.mainViewController;
}

- (void)loginWithCompletionHandler: (void(^)())completionHandler
{
    if (self.cloud.username == nil)
    {
        [self.amFatFractal amGetObjectFromURI: @"/MAUserCounter"
                            completionHandler: ^(NSError *theErr, id theObj, NSHTTPURLResponse *theResponse)
         {
             if (theErr == nil && theResponse.statusCode == 200)
             {
                 MAUserCounter *userCounter = (MAUserCounter *)theObj;
                 
                 NSString *username = [NSString stringWithFormat: @"User%d", userCounter.count];
                 NSString *password = [MAUtilities randomStringWithLength: self.constants.randomPasswordLength];
                 
                 [self.amFatFractal loginWithUserName: username
                                          andPassword: password
                                           onComplete: ^(NSError *theErr, id theObj, NSHTTPURLResponse *theResponse)
                  {
                      if (theErr == nil && theResponse.statusCode == 200)
                      {
                          _currentUser = (FFUser *)theObj;
                          
                          self.cloud.username = username;
                          self.cloud.password = password;
                          
                          completionHandler();
                      }
                  }];
             }
         }];
    }
    else
    {
        [self.amFatFractal loginWithUserName: self.cloud.username
                                 andPassword: self.cloud.password
                                  onComplete: ^(NSError *theErr, id theObj, NSHTTPURLResponse *theResponse)
         {
             if (theErr == nil && theResponse.statusCode == 200)
             {                 
                 _currentUser = (FFUser *)theObj;

                 completionHandler();
             }
         }];
    }
}

- (void)checkVersion
{
    [self.amFatFractal amGetObjectFromURI: @"/MALatestVersion"
                        completionHandler: ^(NSError *theErr, id theObj, NSHTTPURLResponse *theResponse)
    {
        if (theErr == nil && theResponse.statusCode == 200)
        {
            MALatestVersion *latestVersion = (MALatestVersion *)theObj;
            
            float appVersion = [[[[NSBundle mainBundle] infoDictionary] objectForKey: @"CFBundleShortVersionString"] floatValue];
             
            // NSLog(@"appVersion = %f, latestVersion = %f", appVersion, latestVersion.number);
             
            if (appVersion < latestVersion.latestVersion)
            {
                NSString *message = [NSString stringWithFormat: @"This app is Version %0.1f. Version %0.1f is now available."
                                     "It is recommended that you upgrade to the latest version.", appVersion, latestVersion.latestVersion];
                 
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @""
                                                                    message: message
                                                                   delegate: nil
                                                          cancelButtonTitle: @"OK"
                                                          otherButtonTitles: nil];
                 
                [alertView show];
            }
        }
    }];
}

- (void)downloadTextures
{
    [self.textureManager downloadWithCompletionHandler: ^
    {
        [self.gameViewController setup];
    }];
}

- (void)downloadSounds
{
    [self.soundManager downloadWithCompletionHandler:^
    {
        [self.gameViewController setup];
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



















