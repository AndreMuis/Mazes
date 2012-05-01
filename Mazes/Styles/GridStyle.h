//
//  GridStyle.h
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Colors.h"

@interface GridStyle : NSObject

@property (assign, nonatomic) float segmentLengthShort;
@property (assign, nonatomic) float segmentLengthLong;
@property (assign, nonatomic) float textureHighlightWidth;
@property (assign, nonatomic) float locationHighlightWidth;
@property (assign, nonatomic) float wallHighlightWidth;
@property (retain, nonatomic) UIColor *borderColor;
@property (retain, nonatomic) UIColor *backgroundColor;
@property (retain, nonatomic) UIColor *doNothingColor;
@property (retain, nonatomic) UIColor *startColor;
@property (retain, nonatomic) UIColor *endColor;
@property (retain, nonatomic) UIColor *startOverColor;
@property (retain, nonatomic) UIColor *teleportationColor;
@property (retain, nonatomic) UIColor *messageColor;
@property (retain, nonatomic) UIColor *arrowColor;
@property (retain, nonatomic) UIColor *textureHighlightColor;
@property (retain, nonatomic) UIColor *locationHighlightColor;
@property (assign, nonatomic) float teleportFontSize;
@property (retain, nonatomic) UIColor *teleportIdColor;
@property (retain, nonatomic) UIColor *noWallColor;
@property (retain, nonatomic) UIColor *solidColor;
@property (retain, nonatomic) UIColor *invisibleColor;
@property (retain, nonatomic) UIColor *fakeColor;	
@property (retain, nonatomic) UIColor *cornerColor;

@end
