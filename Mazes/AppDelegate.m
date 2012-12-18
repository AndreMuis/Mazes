//
//  AppDelegate.m
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

#import "AppDelegate.h"

#import "Constants.h"
#import "Crittercism.h"
#import "Game.h"
#import "Flurry.h"
#import "Maze.h"
#import "Sounds.h"
#import "Textures.h"
#import "MainListViewController.h"
#import "Version.h"
#import "WebServices.h"
#import "User.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Flurry startSession: [Constants shared].flurryAPIKey];

    [Crittercism enableWithAppID: [Constants shared].crittercismAppId];
    
    self.window = [[UIWindow alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
    
    self.window.rootViewController = [MainListViewController shared];
    [self.window makeKeyAndVisible];

    [[Game shared] checkVersion];

    // [[Sounds shared] download];
    
    // [[Textures shared] load];
    
    self->webServices = [[WebServices alloc] init];
    
    return YES;
}

- (void)loadMazeEdit
{
    /*
    comm = [[Communication alloc] initWithDelegate: self Selector: @selector(loadMazeEditResponse) Action: @"GetMazeByUserId" WaitMessage: @"Loading"];

    [XML addNodeDoc: comm.requestDoc Parent: [XML getRootNodeDoc: comm.requestDoc] NodeName: @"UserId" NodeValue: UNIQUE_ID];
    
    [comm post];
    */
}

- (void)loadMazeEditResponse
{
    /*
    if (comm.errorOccurred == NO)
    {
        if ([XML isDocEmpty: comm.responseDoc] == NO)
        {
            [[Globals instance].mazeEdit populateFromXML: comm.responseDoc];

            [self loadMazeEditLocations];
        }
        else 
        {
            [[MainListViewController shared] loadMazeList];
        }
    }
    else 
    {
        [[MainListViewController shared] loadMazeList];
    }
    */
}

- (void)loadMazeEditLocations
{
    /*
    comm = [[Communication alloc] initWithDelegate: self Selector: @selector(loadMazeEditLocationsResponse) Action: @"GetLocations" WaitMessage: @"Loading"];	

    [XML addNodeDoc: comm.requestDoc Parent: [XML getRootNodeDoc: comm.requestDoc] NodeName: @"MazeId" NodeValue: [NSString stringWithFormat: @"%d", [Globals instance].mazeEdit.mazeId]];

    [comm post];
    */
}

- (void)loadMazeEditLocationsResponse
{
    /*
    if (comm.errorOccurred == NO)
    {		
        [[Globals instance].mazeEdit.locations populateWithXML: comm.responseDoc];
    }

    [[MainListViewController shared] loadMazeList];
    */
}

- (void)applicationDidReceiveMemoryWarning: (UIApplication *)application
{
    NSLog(@"delegate received memory warning.");
}

@end
















