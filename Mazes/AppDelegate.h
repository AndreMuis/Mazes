//
//  AppDelegate.h
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Sound.h"

@class WebServices;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    WebServices *webServices;
    
    Sound *sound;
}

@property (strong, nonatomic) IBOutlet UIWindow *window;

- (void)loadMazeEdit;
- (void)loadMazeEditResponse;

- (void)loadMazeEditLocations;
- (void)loadMazeEditLocationsResponse;

@end
