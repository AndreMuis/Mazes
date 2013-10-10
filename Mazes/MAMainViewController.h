//
//  MAMainViewController.h
//  Mazes
//
//  Created by Andre Muis on 12/28/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MAViewController.h"

@class MAStyles;

typedef enum : int
{
    MATransitionNone = 0,
    MATransitionCrossDissolve = UIViewAnimationOptionTransitionCrossDissolve,
    MATransitionFlipFromTop = UIViewAnimationOptionTransitionFlipFromTop,
    MATransitionFlipFromBottom = UIViewAnimationOptionTransitionFlipFromBottom,
    MATransitionFlipFromLeft = UIViewAnimationOptionTransitionFlipFromLeft,
    MATransitionFlipFromRight = UIViewAnimationOptionTransitionFlipFromRight,
    MATransitionCurlUp = UIViewAnimationOptionTransitionCurlUp,
    MATransitionCurlDown = UIViewAnimationOptionTransitionCurlDown,
    MATransitionTranslateBothUp = 100,
    MATransitionTranslateBothDown = 101,
    MATransitionTranslateBothLeft = 102,
    MATransitionTranslateBothRight = 103
} MATransitionType;

@interface MAMainViewController : MAViewController

@property (readwrite, strong, nonatomic) UIViewController *rootViewController;

- (id)initWithStyles: (MAStyles *)styles;

- (void)transitionFromViewController: (UIViewController *)fromViewController
                    toViewController: (UIViewController *)toViewController
                          transition: (MATransitionType)transition;

@end
