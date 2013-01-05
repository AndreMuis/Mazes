//
//  AppDelegate.h
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ServerOperations.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, MAServerOperationsGetVersionDelegate, MAServerOperationsGetUserDelegate, ADBannerViewDelegate>
{
    NSOperationQueue *operationQueue;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ADBannerView *bannerView;

- (void)getVersion;

- (void)getUser;

@end
