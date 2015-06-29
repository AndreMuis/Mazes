//
//  MAStyles.h
//  Mazes
//
//  Created by Andre Muis on 1/30/11.
//  Copyright 2011 Andre Muis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MAActivityIndicatorStyle;
@class MAButtonStyle;
@class MAGameScreenStyle;
@class MAInfoPopupStyle;
@class MAMainScreenStyle;
@class MAMapStyle;
@class MAPopupStyle;
@class MARatingPopoverStyle;
@class MARatingPopupStyle;
@class MATopMazesScreenStyle;

@interface MAStyles : NSObject 

@property (strong, nonatomic) UIFont *defaultFont;

@property (readonly, strong, nonatomic) MAActivityIndicatorStyle *activityIndicator;
@property (readonly, strong, nonatomic) MAButtonStyle *button;
@property (readonly, strong, nonatomic) MAGameScreenStyle *gameScreen;
@property (readonly, strong, nonatomic) MAInfoPopupStyle *infoPopup;
@property (readonly, strong, nonatomic) MAMainScreenStyle *mainScreen;
@property (readonly, strong, nonatomic) MAMapStyle *map;
@property (readonly, strong, nonatomic) MAPopupStyle *popup;
@property (readonly, strong, nonatomic) MARatingPopoverStyle *ratingPopover;
@property (readonly, strong, nonatomic) MARatingPopupStyle *ratingPopup;
@property (readonly, strong, nonatomic) MATopMazesScreenStyle *topMazesScreen;

+ (MAStyles *)styles;

@end
