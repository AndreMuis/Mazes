//
//  MAMapStyle.h
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MAColors;

@interface MAMapStyle : NSObject

@property (readonly, assign, nonatomic) float wallWidth;
@property (readonly, assign, nonatomic) float locationLength;

@property (readonly, strong, nonatomic) UIColor *backgroundColor;

@property (readonly, strong, nonatomic) UIColor *doNothingColor;
@property (readonly, strong, nonatomic) UIColor *startColor;
@property (readonly, strong, nonatomic) UIColor *endColor;
@property (readonly, strong, nonatomic) UIColor *startOverColor;
@property (readonly, strong, nonatomic) UIColor *teleportationColor;

@property (readonly, strong, nonatomic) UIColor *wallColor;
@property (readonly, strong, nonatomic) UIColor *noWallColor;
@property (readonly, strong, nonatomic) UIColor *invisibleColor;    

+ (MAMapStyle *)mapStyle;

@end
