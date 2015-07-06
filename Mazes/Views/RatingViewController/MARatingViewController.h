//
//  MARatingViewController.h
//  Mazes
//
//  Created by Andre Muis on 1/2/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MAWorld;

@protocol MARatingViewControllerDelegate;

@interface MARatingViewController : UIViewController

+ (instancetype)ratingViewControllerWithDelegate: (id<MARatingViewControllerDelegate>)delegate
                                           world: (MAWorld *)world;

- (instancetype)initWithDelegate: (id<MARatingViewControllerDelegate>)delegate
                           world: (MAWorld *)world;

@end
