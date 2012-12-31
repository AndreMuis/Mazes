//
//  MapStyle.h
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Constants.h"
#import "Colors.h"

@interface MapStyle : NSObject

@property (assign, nonatomic) float length;
@property (assign, nonatomic) float wallWidth;
@property (assign, nonatomic) float squareWidth;
@property (strong, nonatomic) UIColor *backgroundColor;
@property (strong, nonatomic) UIColor *doNothingColor;
@property (strong, nonatomic) UIColor *startColor;
@property (strong, nonatomic) UIColor *endColor;
@property (strong, nonatomic) UIColor *startOverColor;
@property (strong, nonatomic) UIColor *teleportationColor;
@property (strong, nonatomic) UIColor *wallColor;
@property (strong, nonatomic) UIColor *noWallColor;
@property (strong, nonatomic) UIColor *invisibleColor;	

@end
