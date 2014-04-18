//
//  MAStyles.h
//  Mazes
//
//  Created by Andre Muis on 1/30/11.
//  Copyright 2011 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MAActivityIndicatorStyle;
@class MAButtonStyle;
@class MACreateScreenStyle;
@class MADesignScreenStyle;
@class MAFloorPlanStyle;
@class MAFoundExitPopupStyle;
@class MAGameScreenStyle;
@class MAMainScreenStyle;
@class MAMapStyle;
@class MAPopupStyle;
@class MARatingPopupStyle;
@class MATopMazesScreenStyle;

@interface MAStyles : NSObject 

@property (strong, nonatomic) UIFont *defaultFont;

@property (readonly, strong, nonatomic) MAActivityIndicatorStyle *activityIndicator;
@property (readonly, strong, nonatomic) MAButtonStyle *button;
@property (readonly, strong, nonatomic) MACreateScreenStyle *createScreen;
@property (readonly, strong, nonatomic) MADesignScreenStyle *designScreen;
@property (readonly, strong, nonatomic) MAFloorPlanStyle *floorPlan;
@property (readonly, strong, nonatomic) MAFoundExitPopupStyle *foundExitPopup;
@property (readonly, strong, nonatomic) MAGameScreenStyle *gameScreen;
@property (readonly, strong, nonatomic) MAMainScreenStyle *mainScreen;
@property (readonly, strong, nonatomic) MAMapStyle *map;
@property (readonly, strong, nonatomic) MAPopupStyle *popup;
@property (readonly, strong, nonatomic) MARatingPopupStyle *ratingPopup;
@property (readonly, strong, nonatomic) MATopMazesScreenStyle *topMazesScreen;

+ (MAStyles *)styles;

@end
