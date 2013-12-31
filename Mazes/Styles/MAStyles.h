//
//  MAStyles.h
//  Mazes
//
//  Created by Andre Muis on 1/30/11.
//  Copyright 2011 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MAActivityIndicatorStyle;
@class MACanvasStyle;
@class MAColors;
@class MADesignScreenStyle;
@class MAFoundExitPopupStyle;
@class MAGameScreenStyle;
@class MAMainScreenStyle;
@class MAMapStyle;
@class MAPopupStyle;
@class MARatingPopupStyle;
@class MATopMazesScreenStyle;

@interface MAStyles : NSObject 

@property (strong, nonatomic) UIFont *defaultFont;

@property (strong, nonatomic) MAActivityIndicatorStyle *activityIndicator;
@property (strong, nonatomic) MACanvasStyle *canvas;
@property (strong, nonatomic) MADesignScreenStyle *designScreen;
@property (strong, nonatomic) MAFoundExitPopupStyle *foundExitPopup;
@property (strong, nonatomic) MAGameScreenStyle *gameScreen;
@property (strong, nonatomic) MAMainScreenStyle *mainScreen;
@property (strong, nonatomic) MAMapStyle *map;
@property (strong, nonatomic) MAPopupStyle *popup;
@property (strong, nonatomic) MARatingPopupStyle *ratingPopup;
@property (strong, nonatomic) MATopMazesScreenStyle *topMazesScreen;

- (id)initWithColors: (MAColors *)colors;

@end
