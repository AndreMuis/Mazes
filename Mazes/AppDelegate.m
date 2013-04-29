//
//  AppDelegate.m
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import "AppDelegate.h"

#import "Constants.h"
#import "Crittercism.h"
#import "CurrentUser.h"
#import "Flurry.h"
#import "Sounds.h"
#import "Textures.h"
#import "MainViewController.h"
#import "MainListViewController.h"
#import "Utilities.h"
#import "User.h"
#import "Version.h"

@interface AppDelegate ()

@property (strong, nonatomic) NSOperationQueue *operationQueue;

@end

@implementation AppDelegate

- (id)init
{
    self = [super init];
	
	if (self)
	{
        _operationQueue = [[NSOperationQueue alloc] init];
        
        _bannerView = [[ADBannerView alloc] init];
        _bannerView.delegate = self;
	}
    
    return self;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // only need to expose public methods
    
    [Flurry startSession: [Constants shared].flurryAPIKey];

    #ifndef DEBUG
    [Crittercism enableWithAppID: [Constants shared].crittercismAppId];
    #endif
    
    [MagicalRecord setupCoreDataStack];
    
    #if TARGET_IPHONE_SIMULATOR
    //[CurrentUser shared].id = 6766;
    
    [CurrentUser shared].id = 100000;
    
    #endif
    
    self.window = [[UIWindow alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
    
    self.window.rootViewController = [MainViewController shared];
    [self.window makeKeyAndVisible];

    [self getVersion];
    
    [[Sounds shared] download];
    
    [[Textures shared] download];

    // iPad UDID: 7db970c5dc91e0129515c096ae1b07f8fd04ec3f
    // [Utilities cleariCloudStore];

    #if !TARGET_IPHONE_SIMULATOR
    if ([CurrentUser shared].id == 0)
    {
        [self getUser];
    }
    #endif    
    
    return YES;
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

- (void)getVersion
{
    [self.operationQueue addOperation: [[ServerOperations shared] getVersionOperationWithDelegate: self]];
}

- (void)getUser
{
    #pragma GCC diagnostic ignored "-Wdeprecated-declarations"
    [self.   operationQueue addOperation: [[ServerOperations shared] getUserOperationWithDelegate: self
                                                                                           udid: [UIDevice currentDevice].uniqueIdentifier]];
    #pragma GCC diagnostic warning "-Wdeprecated-declarations"
}

- (void)serverOperationsGetVersion: (Version *)version error: (NSError *)error
{
    float appVersion = [[[[NSBundle mainBundle] infoDictionary] objectForKey: @"CFBundleShortVersionString"] floatValue];
    
    //NSLog(@"appVersion = %f, currentVersion = %f", appVersion, currentVersion);
    
    if (error == nil)
    {
        if (appVersion < version.number)
        {
            NSString *message = [NSString stringWithFormat: @"This app is Version %0.1f. Version %0.1f is now available. It is recommended that you upgrade to the latest version.", appVersion, version.number];
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @""
                                                                message: message
                                                               delegate: nil
                                                      cancelButtonTitle: @"OK"
                                                      otherButtonTitles: nil];
            
            [alertView show];
        }
    }
    else
    {
        [self performSelector: @selector(getVersion) withObject: nil afterDelay: [Constants shared].serverRetryDelaySecs];
    }
}

- (void)serverOperationsGetUser: (User *)user error: (NSError *)error
{
    if (error == nil)
    {
        [CurrentUser shared].id = user.id;
        
        NSLog(@"id after %d", [CurrentUser shared].id);
        
        [[MainListViewController shared] getMazeLists];
    }
    else
    {
        [self performSelector: @selector(getUser) withObject: nil afterDelay: [Constants shared].serverRetryDelaySecs];
    }    
}

- (void)applicationDidReceiveMemoryWarning: (UIApplication *)application
{
    [Utilities logWithClass: [self class] format: @"applicationDidReceiveMemoryWarning:"];
}

@end
















