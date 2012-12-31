//
//  AppDelegate.h
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CoreData+MagicalRecord.h"

#import "Sound.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    Sound *sound;
}

@property (strong, nonatomic) UIWindow *window;

- (void)loadMazeEdit;
- (void)loadMazeEditResponse;

- (void)loadMazeEditLocations;
- (void)loadMazeEditLocationsResponse;

@end
