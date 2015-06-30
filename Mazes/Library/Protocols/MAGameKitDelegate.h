//
//  MAGameKitDelegate.h
//  Mazes
//
//  Created by Andre Muis on 5/19/14.
//  Copyright (c) 2014 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MAGameKit;

@protocol MAGameKitDelegate <NSObject>

@optional
- (void)gameKit: (MAGameKit *)gameKit didReceiveAuthenticationViewController: (UIViewController *)authenticationViewController;

- (void)gameKitLocalPlayerAuthenticationComplete: (MAGameKit *)gameKit;

- (void)gameKit: (MAGameKit *)gameKit didFailLocalPlayerAuthenticationWithError: (NSError *)error;

@end
