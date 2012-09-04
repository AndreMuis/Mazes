//
//  AppDelegate.h
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Communication.h"
#import "DataAccess.h"
#import "Tester.h"
#import "Version.h"
#import "Textures.h"
#import "Sounds.h"

@class Maze;
@class TopListsViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, LoadVersionDelegate>
{
    Communication *comm;
}

@property (strong, nonatomic) IBOutlet UIWindow *window;
@property (strong, nonatomic) IBOutlet UINavigationController *navigationController;

- (void)setupUserDefaults;
- (void)setupBannerView;

- (void)setLanguage;
- (void)setLanguageResponse;

- (void)loadMazeEdit;
- (void)loadMazeEditResponse;

- (void)loadMazeEditLocations;
- (void)loadMazeEditLocationsResponse;
  
@end
