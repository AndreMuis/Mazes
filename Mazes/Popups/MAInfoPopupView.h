//
//  MAInfoPopupView.h
//  Mazes
//
//  Created by Andre Muis on 10/21/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MAPopupView.h"

@class MAStyles;

@interface MAInfoPopupView : MAPopupView

+ (MAInfoPopupView *)infoPopupView;

- (void)showWithStyles: (MAStyles *)styles
            parentView: (UIView *)parentView
               message: (NSString *)message
     cancelButtonTitle: (NSString *)cancelButtonTitle
      dismissedHandler: (PopupViewDismissedHandler)dismissedHandler;

@end
