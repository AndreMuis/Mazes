//
//  MAFoundExitPopupView.h
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

@interface MAFoundExitPopupView : MAPopupView <MARatingViewDelegate>

+ (MAFoundExitPopupView *)foundExitPopupView;

- (void)showWithStyles: (MAStyles *)styles
            parentView: (UIView *)parentView
    ratingViewDelegate: (id<MARatingViewDelegate>)ratingViewDelegate
                rating: (float)rating
      dismissedHandler: (PopupViewDismissedHandler)dismissedHandler;

@end
