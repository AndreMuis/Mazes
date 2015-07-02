//
//  MARatingViewDelegate.h
//  Mazes
//
//  Created by Andre Muis on 5/19/14.
//  Copyright (c) 2014 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MARatingView;

@protocol MARatingViewDelegate <NSObject>

@required

- (void)ratingView: (MARatingView *)ratingView
  didTapWithRating: (float)rating;

@end
