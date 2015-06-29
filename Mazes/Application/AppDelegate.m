//
//  AppDelegate.m
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import "AppDelegate.h"

#import "MAConstants.h"
#import "MATopMazesViewController.h"

@implementation AppDelegate

- (BOOL)application: (UIApplication *)application didFinishLaunchingWithOptions: (NSDictionary *)launchOptions
{
    [Crashlytics startWithAPIKey: MACrashlyticsAPIKey];
    
    return YES;
}

@end



















