//
//  MARatingView.h
//  Mazes
//
//  Created by Andre Muis on 12/30/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MARatingViewDelegate;

@interface MARatingView : UIView

+ (instancetype)ratingView;

- (void)setupWithStarColor: (UIColor *)starColor
              outlineWidth: (float)outlineWidth;

- (void)setupWithDelegate: (id<MARatingViewDelegate>)delegate
              ratingValue: (float)ratingValue
                starColor: (UIColor *)starColor
             outlineWidth: (float)outlineWidth;

- (void)addToParentView: (UIView *)parentView;

- (void)refreshWithRatingValue: (float)ratingValue;

@end
