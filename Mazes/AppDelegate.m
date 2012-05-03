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
    
    [[Globals instance].dataAccess getVersion];

	
    
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURLString: @"http://173.45.249.212:3000"];
    
    objectManager.objectStore = [RKManagedObjectStore objectStoreWithStoreFilename: @"Mazes.sqlite"];
    
    RKManagedObjectMapping* soundMapping = [RKManagedObjectMapping mappingForClass: [Sound class] inManagedObjectStore: objectManager.objectStore];
    soundMapping.primaryKeyAttribute = @"soundId";
    [soundMapping mapKeyPath: @"id" toAttribute: @"soundId"];
    [soundMapping mapKeyPath: @"name" toAttribute: @"name"];
    
    [objectManager.mappingProvider setObjectMapping: soundMapping forResourcePathPattern: @"/sounds"];
    

    [objectManager loadObjectsAtResourcePath: @"/sounds" delegate:self];
    
    return YES;
}



- (void)objectLoader: (RKObjectLoader*)objectLoader didLoadObjects: (NSArray*)objects 
{
    NSLog(@"Loaded statuses: %@", objects);

    NSFetchRequest *request = [Sound fetchRequest];
    //NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey: @"createdAt" ascending: NO];
    //[request setSortDescriptors:[NSArray arrayWithObject:descriptor]];

    NSLog(@"%d", [Sound objectsWithFetchRequest: request].count);
}

- (void)objectLoader: (RKObjectLoader*)objectLoader didFailWithError: (NSError*)error 
{
    NSLog(@"%@", error);
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

- (void)setLanguage
{
    comm = [[Communication alloc] initWithDelegate: self Selector: @selector(setLanguageResponse) Action: @"SetLanguage" WaitMessage: @"Loading"];

    [XML addNodeDoc: comm.requestDoc Parent: [XML getRootNodeDoc: comm.requestDoc] NodeName: @"DeviceId" NodeValue: UNIQUE_ID];
    [XML addNodeDoc: comm.requestDoc Parent: [XML getRootNodeDoc: comm.requestDoc] NodeName: @"LanguageCode" NodeValue: [Utilities getLanguageCode]];

    [comm post];	
}

- (void)setLanguageResponse
{
    [self checkVersion];
}

- (void)checkVersion
{
    comm = [[Communication alloc] initWithDelegate: self Selector: @selector(checkVersionResponse) Action: @"GetVersion" WaitMessage: @"Loading"];
 
    [comm post];	
}
 
- (void)checkVersionResponse
{
    if (comm.errorOccurred == NO)
    {
        //NSLog(@"%@", [XML convertDocToString: comm.responseDoc]);

        float appVersion = [[[[NSBundle mainBundle] infoDictionary] objectForKey: @"CFBundleVersion"] floatValue];

        float currentVersion = [[XML getNodeValueFromDoc: comm.responseDoc Node: [XML getRootNodeDoc: comm.responseDoc] XPath: "/Response/Version"] floatValue];

        //NSLog(@"appVersion = %f, currentVersion = %f", appVersion, currentVersion);

        if (appVersion < currentVersion)
        {
            NSString *message = [NSString stringWithFormat: @"This app is Version %0.1f. Version %0.1f is now available. It is recommended that you upgrade to the latest version.", appVersion, currentVersion];

            [Utilities ShowAlertWithDelegate: self Message: message CancelButtonTitle: @"OK" OtherButtonTitle: @"" Tag: 1 Bounds: CGRectZero];
        }
        else 
        {
            [self loadSounds];
        }
    }
    else 
    {		

        [self loadSounds];
    }
}
 
 - (void)alertView: (UIAlertView *)alertView didDismissWithButtonIndex: (NSInteger)buttonIndex
{
    [self loadSounds];
}

- (void)loadSounds
{
    comm = [[Communication alloc] initWithDelegate: self Selector: @selector(loadSoundsResponse) Action: @"GetSounds" WaitMessage: @"Loading"];

    [comm post];	
}

- (void)loadSoundsResponse
{   
    if (comm.errorOccurred == NO)
    {
        [Globals instance].sounds = [[Sounds alloc] initWithXML: comm.responseDoc];
    }

    [self loadTextures];
}

- (void)loadTextures
{
    comm = [[Communication alloc] initWithDelegate: self Selector: @selector(loadTexturesResponse) Action: @"GetTextures" WaitMessage: @"Loading"];

    [comm post];
}

- (void)loadTexturesResponse
{
    if (comm.errorOccurred == NO)
    {
        [Globals instance].textures = [[Textures alloc] initWithXML: comm.responseDoc];
    }

    [self loadMazeEdit];
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

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
}

@end
