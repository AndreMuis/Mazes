//
//  Styles.h
//  Mazes
//
//  Created by Andre Muis on 1/30/11.
//  Copyright 2011 Andre Muis. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ActivityViewStyle.h"
#import "EditViewStyle.h"
#import "EndAlertViewStyle.h"
#import "GameViewStyle.h"
#import "GridStyle.h"
#import "MainViewStyle.h"
#import "MapStyle.h"
#import "MainListViewStyle.h"
#import "RatingViewStyle.h"

@interface Styles : NSObject 

@property (strong, nonatomic) UIFont *defaultFont;

@property (strong, nonatomic) ActivityViewStyle *activityView;
@property (strong, nonatomic) EditViewStyle *editView;
@property (strong, nonatomic) EndAlertViewStyle *endAlertView;
@property (strong, nonatomic) GameViewStyle *gameView;
@property (strong, nonatomic) GridStyle *grid;
@property (strong, nonatomic) MainViewStyle *mainView;
@property (strong, nonatomic) MapStyle *map;
@property (strong, nonatomic) MainListViewStyle *mainListView;
@property (strong, nonatomic) RatingViewStyle *ratingView;

+ (Styles *)shared;

@end
