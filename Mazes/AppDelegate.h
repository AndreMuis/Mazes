//
//  AppDelegate.h
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

#import <RestKit/RestKit.h>

#import "ServerOperations.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, MAServerOperationsGetVersionDelegate, MAServerOperationsGetUserDelegate, ADBannerViewDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ADBannerView *bannerView;

@end
