//
//  MAPopupView.h
//  Mazes
//
//  Created by Andre Muis on 10/21/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@class MAButton;
@class MAStyles;

typedef void (^PopupViewDismissedHandler)();

@interface MAPopupView : UIView

- (void)setupWithParentView: (UIView *)parentView;

- (void)showWithDismissedHandler: (PopupViewDismissedHandler)dismissedHandler;

- (void)centerInParentView;

- (CGFloat)cancelButtonWidth: (MAButton *)cancelButton;

- (void)animateUp;
- (void)animateDown;

@end















