//
//  AppDelegate.m
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import "AppDelegate.h"

#import "MAConstants.h"



#import "MACurrentUser.h"
#import "MAWorldManager.h"
#import "MAWorld.h"


@interface AppDelegate ()

@property (readonly, strong, nonatomic) MAWorldManager *worldManager;

@end

@implementation AppDelegate

- (BOOL)application: (UIApplication *)application didFinishLaunchingWithOptions: (NSDictionary *)launchOptions
{
    [Crashlytics startWithAPIKey: MACrashlyticsAPIKey];
    
    
    
    /*
    _worldManager = [MAWorldManager worldManager];
     
    [[MACurrentUser shared] fetchUserRecordIDWithCompletionHandler: ^(NSError *error)
    {
        MAWorld *world = nil;
        
        world = [MAWorld worldWithUserRecordName: [MACurrentUser shared].recordname
                                            name: @"Andre's World 1"
                                            rows: 3
                                         columns: 3
                                        isPublic: YES];

        [self.worldManager saveWithWorld: world
                       completionHandler: ^(MAWorld *world, NSError *error)
        {
            NSLog(@"%@", error);
        }];
        
        world = [MAWorld worldWithUserRecordName: [MACurrentUser shared].recordname
                                            name: @"Andre's World 2"
                                            rows: 3
                                         columns: 3
                                        isPublic: YES];
        
        [self.worldManager saveWithWorld: world
                       completionHandler: ^(MAWorld *world, NSError *error)
        {
            NSLog(@"%@", error);
        }];

        world = [MAWorld worldWithUserRecordName: [MACurrentUser shared].recordname
                                            name: @"Andre's World 3"
                                            rows: 3
                                         columns: 3
                                        isPublic: YES];

        [self.worldManager saveWithWorld: world
                       completionHandler: ^(MAWorld *world, NSError *error)
        {
            NSLog(@"%@", error);
        }];
    }];
    */
    
    return YES;
}

@end



















