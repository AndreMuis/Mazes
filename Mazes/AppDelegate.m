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

@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

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
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil) {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil) {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Mazes" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Mazes.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
