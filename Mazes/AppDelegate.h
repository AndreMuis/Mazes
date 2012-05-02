//
//  AppDelegate.h
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <RestKit/RestKit.h>

#import "Communication.h"
#import "Tester.h"
#import "Textures.h"
#import "Sounds.h"

#import "DataAccess.h"

@class Maze;
@class TopListsViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, RKObjectLoaderDelegate>
{
    Communication *comm;
}

@property (strong, nonatomic) IBOutlet UIWindow *window;
@property (strong, nonatomic) IBOutlet UINavigationController *navigationController;

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
  
@end
