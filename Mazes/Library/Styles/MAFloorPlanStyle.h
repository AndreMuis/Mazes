//
//  MAFloorPlanStyle.h
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MAColors;

@interface MAFloorPlanStyle : NSObject

@property (readonly, strong, nonatomic) UIColor *borderColor;
@property (readonly, strong, nonatomic) UIColor *backgroundColor;

@property (readonly, assign, nonatomic) float segmentLengthShort;
@property (readonly, assign, nonatomic) float segmentLengthLong;

@property (readonly, strong, nonatomic) UIColor *doNothingColor;
@property (readonly, strong, nonatomic) UIColor *startColor;
@property (readonly, strong, nonatomic) UIColor *endColor;
@property (readonly, strong, nonatomic) UIColor *startOverColor;
@property (readonly, strong, nonatomic) UIColor *teleportationColor;
@property (readonly, strong, nonatomic) UIColor *messageColor;

@property (readonly, strong, nonatomic) UIColor *arrowColor;

@property (readonly, strong, nonatomic) UIFont *teleportFont;
@property (readonly, strong, nonatomic) UIColor *teleportIdColor;

@property (readonly, strong, nonatomic) UIColor *noWallColor;
@property (readonly, strong, nonatomic) UIColor *solidColor;
@property (readonly, strong, nonatomic) UIColor *invisibleColor;
@property (readonly, strong, nonatomic) UIColor *fakeColor;

@property (readonly, strong, nonatomic) UIColor *highlightColor;
@property (readonly, strong, nonatomic) UIColor *textureHighlightColor;

@property (readonly, assign, nonatomic) float locationHighlightWidth;
@property (readonly, assign, nonatomic) float wallHighlightWidth;

@property (readonly, strong, nonatomic) UIColor *cornerColor;

+ (MAFloorPlanStyle *)floorPlanStyle;

@end


