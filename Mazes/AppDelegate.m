//
//  AppDelegate.m
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

#import "AppDelegate.h"

#import "Communication.h"
#import "Game.h"
#import "Maze.h"
#import "Sounds.h"
#import "Tester.h"
#import "Textures.h"
#import "TopListsViewController.h"
#import "Version.h"
#import "WebServices.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	BOOL testing = NO;

    if (testing == YES)
    {
        Tester *test = [[Tester alloc] init];
        [test FloatRounding];
     
        return YES;
    }
     
    //self.window.rootViewController = self.navigationController;
    //[self.window makeKeyAndVisible];

    [Utilities createActivityView];
    
    [[Game shared] checkVersion];

    [[Sounds shared] load];
    
    [[Textures shared] load];
    
    return YES;
}

- (void)loadMazeEdit
{
    comm = [[Communication alloc] initWithDelegate: self Selector: @selector(loadMazeEditResponse) Action: @"GetMazeByUserId" WaitMessage: @"Loading"];

    [XML addNodeDoc: comm.requestDoc Parent: [XML getRootNodeDoc: comm.requestDoc] NodeName: @"UserId" NodeValue: UNIQUE_ID];
    
    [comm post];
}

- (void)loadMazeEditResponse
{
    if (comm.errorOccurred == NO)
    {
        if ([XML isDocEmpty: comm.responseDoc] == NO)
        {
            [[Globals instance].mazeEdit populateFromXML: comm.responseDoc];

            [self loadMazeEditLocations];
        }
        else 
        {
            [[Globals instance].topListsViewController loadMazeList];
        }
    }
    else 
    {
        [[Globals instance].topListsViewController loadMazeList];
    }
}

- (void)loadMazeEditLocations
{
    comm = [[Communication alloc] initWithDelegate: self Selector: @selector(loadMazeEditLocationsResponse) Action: @"GetLocations" WaitMessage: @"Loading"];	

    [XML addNodeDoc: comm.requestDoc Parent: [XML getRootNodeDoc: comm.requestDoc] NodeName: @"MazeId" NodeValue: [NSString stringWithFormat: @"%d", [Globals instance].mazeEdit.mazeId]];

    [comm post];
}

- (void)loadMazeEditLocationsResponse
{
    if (comm.errorOccurred == NO)
    {		
        [[Globals instance].mazeEdit.locations populateWithXML: comm.responseDoc];
    }

    [[Globals instance].topListsViewController loadMazeList];
}

- (void)applicationDidReceiveMemoryWarning: (UIApplication *)application
{
    NSLog(@"delegate received memory warning.");
}

@end
