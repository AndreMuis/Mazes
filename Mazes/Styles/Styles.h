//
//  Styles.h
//  iPad_Mazes
//
//  Created by Andre Muis on 1/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ActivityViewStyle.h"
#import "BannerViewStyle.h"
#import "EditViewStyle.h"
#import "EndAlertViewStyle.h"
#import "GameViewStyle.h"
#import "GridStyle.h"
#import "MapStyle.h"
#import "MazeListStyle.h"
#import "RatingViewStyle.h"
#import "ScreenStyle.h"

@interface Styles : NSObject 

@property (nonatomic, retain) UIFont *defaultFont;

@property (retain, nonatomic) ActivityViewStyle *activityView;
@property (retain, nonatomic) BannerViewStyle *bannerView;
@property (retain, nonatomic) EditViewStyle *editView;
@property (retain, nonatomic) EndAlertViewStyle *endAlertView;
@property (retain, nonatomic) GameViewStyle *gameView;
@property (retain, nonatomic) GridStyle *grid;
@property (retain, nonatomic) MapStyle *map;
@property (retain, nonatomic) MazeListStyle *mazeList;
@property (retain, nonatomic) RatingViewStyle *ratingView;
@property (retain, nonatomic) ScreenStyle *screen;

+ (Styles *)shared;

@end
