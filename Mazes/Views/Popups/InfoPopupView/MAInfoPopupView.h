//
//  MAInfoPopupView.h
//  Mazes
//
//  Created by Andre Muis on 10/21/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MAPopupView.h"

@interface MAInfoPopupView : MAPopupView

+ (MAInfoPopupView *)infoPopupViewWithParentView: (UIView *)parentView
                                         message: (NSString *)message
                               cancelButtonTitle: (NSString *)cancelButtonTitle;

- (void)setupWithParentView: (UIView *)parentView
                    message: (NSString *)message
          cancelButtonTitle: (NSString *)cancelButtonTitle;

- (void)showWithDismissedHandler: (PopupViewDismissedHandler)dismissedHandler;

@end
