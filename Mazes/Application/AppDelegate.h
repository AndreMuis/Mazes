//
//  AppDelegate.h
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CrittercismSDK/Crittercism.h>
#import <FlurrySDK/Flurry.h>
#import <Reachability/Reachability.h>

@class MAMazeManager;
@class MAStyles;
@class MAWebServices;

@interface AppDelegate : UIResponder <UIApplicationDelegate, ADBannerViewDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) MAWebServices *webServices;

@property (readonly, strong, nonatomic) MAMazeManager *mazeManager;
@property (readonly, strong, nonatomic) MAStyles *styles;

@end
