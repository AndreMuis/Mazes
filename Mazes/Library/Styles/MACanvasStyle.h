//
//  MACanvasStyle.h
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MAColors;

@interface MACanvasStyle : NSObject

@property (assign, nonatomic) float segmentLengthShort;
@property (assign, nonatomic) float segmentLengthLong;
@property (assign, nonatomic) float textureHighlightWidth;
@property (assign, nonatomic) float locationHighlightWidth;
@property (assign, nonatomic) float wallHighlightWidth;
@property (strong, nonatomic) UIColor *borderColor;
@property (strong, nonatomic) UIColor *backgroundColor;
@property (strong, nonatomic) UIColor *doNothingColor;
@property (strong, nonatomic) UIColor *startColor;
@property (strong, nonatomic) UIColor *endColor;
@property (strong, nonatomic) UIColor *startOverColor;
@property (strong, nonatomic) UIColor *teleportationColor;
@property (strong, nonatomic) UIColor *messageColor;
@property (strong, nonatomic) UIColor *arrowColor;
@property (strong, nonatomic) UIColor *textureHighlightColor;
@property (strong, nonatomic) UIColor *locationHighlightColor;
@property (assign, nonatomic) float teleportFontSize;
@property (strong, nonatomic) UIColor *teleportIdColor;
@property (strong, nonatomic) UIColor *noWallColor;
@property (strong, nonatomic) UIColor *solidColor;
@property (strong, nonatomic) UIColor *invisibleColor;
@property (strong, nonatomic) UIColor *fakeColor;	
@property (strong, nonatomic) UIColor *cornerColor;

+ (MACanvasStyle *)canvasStyle;

@end
