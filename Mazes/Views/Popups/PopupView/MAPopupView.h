//
//  MAPopupView.h
//  Mazes
//
//  Created by Andre Muis on 10/21/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@class MAStyles;

typedef void (^PopupViewDismissedHandler)();

@interface MAPopupView : UIView

@property (readonly, strong, nonatomic) MAStyles *styles;

- (void)showWithStyles: (MAStyles *)styles
            parentView: (UIView *)parentView
      dismissedHandler: (PopupViewDismissedHandler)dismissedHandler;

- (void)animateUp;
- (void)animateDown;

@end















