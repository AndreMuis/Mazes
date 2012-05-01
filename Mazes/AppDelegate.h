//
//  AppDelegate.h
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Communication.h"
#import "Tester.h"
#import "Textures.h"
#import "Sounds.h"

#import "DataAccess.h"

@class Maze;
@class TopListsViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    Communication *comm;
}

@property (strong, nonatomic) IBOutlet UIWindow *window;
@property (strong, nonatomic) IBOutlet UINavigationController *navigationController;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

 - (void)setupUserDefaults;
 - (void)setupBannerView;
 
 - (void)setLanguage;
 - (void)setLanguageResponse;

 - (void)checkVersion;
 - (void)checkVersionResponse;
 
 - (void)loadSounds;
 - (void)loadSoundsResponse;
 
 - (void)loadTextures;
 - (void)loadTexturesResponse;
 
 - (void)loadMazeEdit;
 - (void)loadMazeEditResponse;
 
 - (void)loadMazeEditLocations;
 - (void)loadMazeEditLocationsResponse;
  
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
