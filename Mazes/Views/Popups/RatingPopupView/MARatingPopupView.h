//
//  MARatingPopupView.h
//  Mazes
//
//  Created by Andre Muis on 10/11/12.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MAPopupView.h"
#import "MARatingView.h"

@class MARatingView;
@class MAStyles;

@interface MARatingPopupView : MAPopupView

+ (MARatingPopupView *)ratingPopupViewWithParentView: (UIView *)parentView
                                              rating: (float)rating;

- (void)setupWithParentView: (UIView *)parentView
                     rating: (float)rating;

- (void)showWithDismissedHandler: (PopupViewDismissedHandler)dismissedHandler;

@end
