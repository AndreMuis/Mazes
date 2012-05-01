//
//  MapStyle.h
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Constants.h"
#import "Colors.h"

@interface MapStyle : NSObject

@property (assign, nonatomic) float length;
@property (assign, nonatomic) float wallWidth;
@property (assign, nonatomic) float squareWidth;
@property (retain, nonatomic) UIColor *backgroundColor;
@property (retain, nonatomic) UIColor *doNothingColor;
@property (retain, nonatomic) UIColor *startColor;
@property (retain, nonatomic) UIColor *endColor;
@property (retain, nonatomic) UIColor *startOverColor;
@property (retain, nonatomic) UIColor *teleportationColor;
@property (retain, nonatomic) UIColor *wallColor;
@property (retain, nonatomic) UIColor *noWallColor;
@property (retain, nonatomic) UIColor *invisibleColor;	

@end
