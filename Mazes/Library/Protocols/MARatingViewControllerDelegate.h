//
//  MARatingViewControllerDelegate.h
//  Mazes
//
//  Created by Andre Muis on 5/19/14.
//  Copyright (c) 2014 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MARatingViewController;
@class MAWorld;

@protocol MARatingViewControllerDelegate <NSObject>

@required

- (void)ratingViewController: (MARatingViewController *)ratingViewController
        didChangeRatingValue: (float)ratingValue
                    forWorld: (MAWorld *)world;

@end

