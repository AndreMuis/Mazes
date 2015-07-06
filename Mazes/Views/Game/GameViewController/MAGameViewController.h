//
//  MAGameViewController.h
//  Mazes
//
//  Created by Andre Muis on 7/5/15.
//  Copyright (c) 2015 Andre Muis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MAWorld;

@interface MAGameViewController : UIViewController

+ (instancetype)gameViewController;

- (void)setupWithWorld: (MAWorld *)world;

@end
