//
//  AppDelegate.m
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import "AppDelegate.h"

#import "Crittercism.h"
#import "Flurry.h"

#import "GameViewController.h"

#import "MACloud.h"
#import "MAConstants.h"
#import "MALocation.h"
#import "MAMainViewController.h"
#import "MAMaze.h"
#import "MASoundManager.h"
#import "MASound.h"
#import "MATextureManager.h"
#import "MATexture.h"
#import "MATopMazesViewController.h"
#import "MAUserManager.h"
#import "MAUser.h"
#import "MAUtilities.h"
#import "MAVersionManager.h"
#import "MAVersion.h"

#import "MATest.h"

@interface AppDelegate ()

@property (nonatomic, strong) MAMaze *maze;
@property (nonatomic, strong) PFQuery *mazeQuery;

@end

@implementation AppDelegate

- (id)init
{
    self = [super init];
	
	if (self)
	{
        _bannerView = [[ADBannerView alloc] init];
        _bannerView.delegate = self;
	}
    
    return self;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Flurry startSession: [MAConstants shared].flurryAPIKey];

    #ifndef DEBUG
    [Crittercism enableWithAppID: [MAConstants shared].crittercismAppId];
    #endif
    
    // Parse
    [MALocation registerSubclass];
    [MAMaze registerSubclass];
    [MASound registerSubclass];
    [MATexture registerSubclass];
    [MAUser registerSubclass];
    [MAVersion registerSubclass];

    [MATest registerSubclass];
    
    [Parse setApplicationId: [MAConstants shared].parseApplicationId
                  clientKey: [MAConstants shared].parseClientKey];
    
    [PFAnalytics trackAppOpenedWithLaunchOptions: launchOptions];
    
    
    self.window = [[UIWindow alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
    
    self.window.rootViewController = [MAMainViewController shared];
    [self.window makeKeyAndVisible];
    
    [[MAVersionManager shared] downloadWithCompletionHandler: ^(MAVersion *version)
    {
        [self versionDownloaded: version];
    }];
    
    [[MASoundManager shared] downloadWithCompletionHandler:^
    {
        if ([MASoundManager shared].count > 0 && [MATextureManager shared].count > 0)
        {
            [[GameViewController shared] setup];
            
            [self test];
        }
    }];

    [[MATextureManager shared] downloadWithCompletionHandler:^
    {
        if ([MASoundManager shared].count > 0 && [MATextureManager shared].count > 0)
        {
            [[GameViewController shared] setup];
            
            [self test];
        }
    }];

    [[MAUserManager shared] getCurrentUserWithCompletionHandler:^
    {
        [[MATopMazesViewController shared] refreshCurrentMazes];

        [self test];
    }];
    
    return YES;
}

- (void)test
{
    if ([MASoundManager shared].count > 0 && [MATextureManager shared].count > 0 && [MAUserManager shared].currentUser != nil)
    {
        NSLog(@"sounds = %d", [MASoundManager shared].count);
        NSLog(@"textures = %d", [MATextureManager shared].count);
        NSLog(@"current user = %@", [MAUserManager shared].currentUser);
        
        /*
        self.maze = [MAMaze object];

        self.maze.user = [MAUserManager shared].currentUser;
        self.maze.name = @"Andre's Maze";
        self.maze.rows = [NSNumber numberWithInt: 3];
        self.maze.columns = [NSNumber numberWithInt: 4];
        self.maze.public = [NSNumber numberWithBool: YES];
        self.maze.backgroundSound = [[MASoundManager shared] soundWithObjectId: @"FQMGEca3Vy"];
        self.maze.wallTexture = [[MATextureManager shared] textureWithObjectId: @"cbsJjC84oh"];
        self.maze.floorTexture = [[MATextureManager shared] textureWithObjectId: @"MlchXCbQSI"];
        self.maze.ceilingTexture = [[MATextureManager shared] textureWithObjectId: @"sqrne1z3Z1"];

        [self.maze saveInBackground];

        self.mazeQuery = [MAMaze query];

        [self.mazeQuery getObjectInBackgroundWithId: @"o9lPBXCjS3" block: ^(PFObject *object, NSError *error)
        {
            MAMaze *maze = (MAMaze *)object;
            
            NSLog(@"maze = %@", maze);

            MALocation *location = [MALocation object];
            
            location.maze = maze;
            location.xx = 10;
            location.yy = 11;
            location.direction = 12;
            location.wallNorth = 13;
            location.wallWest = 14;
            location.action = 15;
            location.message = @"message";
            location.teleportId = 16;
            location.teleportX = 17;
            location.teleportY = 18;
            location.wallNorthTexture = [[MATextureManager shared] textureWithObjectId: @"cbsJjC84oh"];
            location.wallWestTexture = [[MATextureManager shared] textureWithObjectId: @"MlchXCbQSI"];
            location.floorTexture = [[MATextureManager shared] textureWithObjectId: @"sqrne1z3Z1"];
            location.ceilingTexture = [[MATextureManager shared] textureWithObjectId: @"NdTbggxoQg"];
            location.visited = YES;
            location.wallNorthHit = YES;
            location.wallWestHit = YES;
            
            [location saveInBackground];
        }];
        */
    }
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

- (void)versionDownloaded: (MAVersion *)version
{
    NSNumber *appVersion = @([[[[NSBundle mainBundle] infoDictionary] objectForKey: @"CFBundleShortVersionString"] floatValue]);
    
    // NSLog(@"appVersion = %@, version = %@", appVersion, version.number);
    
    if ([appVersion floatValue] < version.number)
    {
        NSString *message = [NSString stringWithFormat: @"This app is Version %0.1f. Version %0.1f is now available. It is recommended that you upgrade to the latest version.", [appVersion floatValue], version.number];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @""
                                                            message: message
                                                           delegate: nil
                                                  cancelButtonTitle: @"OK"
                                                  otherButtonTitles: nil];
        
        [alertView show];
    }
}

- (void)applicationDidReceiveMemoryWarning: (UIApplication *)application
{
    [MAUtilities logWithClass: [self class] format: @"applicationDidReceiveMemoryWarning:"];
}

@end
















