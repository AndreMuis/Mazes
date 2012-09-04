//
//  AppDelegate.m
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "Maze.h"
#import "TopListsViewController.h"

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

    [self setupUserDefaults];

    [self setupBannerView];

    [Utilities createActivityView];

    //[self setLanguage];

    [[Globals instance].dataAccess getVersionWithDelegate: self];
        
    if ([Globals instance].sounds.count == 0)
    {
        [[Globals instance].dataAccess loadSounds];
    }

    NSLog(@"%@", [[Globals instance].textures getTextures]);
    
    [[Globals instance].dataAccess loadTextures];
    return YES;
}

- (void)setupUserDefaults
{
    NSDictionary *defaults = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithBool: YES], @"UseTutorial", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults: defaults];
}

- (void)setupBannerView
{
    NSNumber *free = (NSNumber *)[[[NSBundle mainBundle] infoDictionary] objectForKey: @"Free"];
    
    if ([free boolValue] == YES)
    {	
        [Globals instance].bannerView.requiredContentSizeIdentifiers = [NSSet setWithObject: ADBannerContentSizeIdentifierPortrait];
        [Globals instance].bannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;

        [Globals instance].bannerView.delegate = nil;
    }
}

- (void)loadVersionSucceededWithVersion: (Version *)currentVersion
{
    //NSLog(@"%@", [XML convertDocToString: comm.responseDoc]);

    float appVersion = [[[[NSBundle mainBundle] infoDictionary] objectForKey: @"CFBundleVersion"] floatValue];

    //NSLog(@"appVersion = %f, currentVersion = %f", appVersion, currentVersion);

    if (appVersion < currentVersion.number)
    {
        NSString *message = [NSString stringWithFormat: @"This app is Version %0.1f. Version %0.1f is now available. It is recommended that you upgrade to the latest version.", appVersion, currentVersion.number];
        
        [Utilities ShowAlertWithDelegate: nil Message: message CancelButtonTitle: @"OK" OtherButtonTitle: @"" Tag: 1 Bounds: CGRectZero];
    }
}

- (void)loadVersionFailed
{
    DLog(@"Unable to load version.");
}

- (void)setLanguage
{
    comm = [[Communication alloc] initWithDelegate: self Selector: @selector(setLanguageResponse) Action: @"SetLanguage" WaitMessage: @"Loading"];

    [XML addNodeDoc: comm.requestDoc Parent: [XML getRootNodeDoc: comm.requestDoc] NodeName: @"DeviceId" NodeValue: UNIQUE_ID];
    [XML addNodeDoc: comm.requestDoc Parent: [XML getRootNodeDoc: comm.requestDoc] NodeName: @"LanguageCode" NodeValue: [Utilities getLanguageCode]];

    [comm post];	
}

- (void)setLanguageResponse
{
    // [self checkVersion];
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
