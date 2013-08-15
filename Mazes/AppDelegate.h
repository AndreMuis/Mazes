//
//  AppDelegate.h
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Parse/Parse.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, ADBannerViewDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ADBannerView *bannerView;

@end
