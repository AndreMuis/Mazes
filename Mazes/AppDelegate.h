//
//  AppDelegate.h
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Sound.h"

@class Communication;
@class WebServices;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    Communication *comm;
    WebServices *webServices;
    
    Sound *sound;
    
    AVAudioPlayer *player;
}

@property (strong, nonatomic) IBOutlet UIWindow *window;
@property (strong, nonatomic) IBOutlet UINavigationController *navigationController;

- (void)loadMazeEdit;
- (void)loadMazeEditResponse;

- (void)loadMazeEditLocations;
- (void)loadMazeEditLocationsResponse;
  
@end
