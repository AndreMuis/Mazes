//
//  MAStyles.h
//  Mazes
//
//  Created by Andre Muis on 1/30/11.
//  Copyright 2011 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MAActivityViewStyle;
@class MAColors;
@class MAConstants;
@class MAEditViewStyle;
@class MAEndAlertViewStyle;
@class MAGameViewStyle;
@class MAGridStyle;
@class MAMainListViewStyle;
@class MAMainViewStyle;
@class MAMapStyle;
@class MARatingViewStyle;

@interface MAStyles : NSObject 

@property (strong, nonatomic) UIFont *defaultFont;

@property (strong, nonatomic) MAActivityViewStyle *activityView;
@property (strong, nonatomic) MAEditViewStyle *editView;
@property (strong, nonatomic) MAEndAlertViewStyle *endAlertView;
@property (strong, nonatomic) MAGameViewStyle *gameView;
@property (strong, nonatomic) MAGridStyle *grid;
@property (strong, nonatomic) MAMainViewStyle *mainView;
@property (strong, nonatomic) MAMapStyle *map;
@property (strong, nonatomic) MAMainListViewStyle *mainListView;
@property (strong, nonatomic) MARatingViewStyle *ratingView;

- (id)initWithConstants: (MAConstants *)constants colors: (MAColors *)colors;

@end
