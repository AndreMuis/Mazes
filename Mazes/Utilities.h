//
//  Utilities.h
//  Mazes
//
//  Created by Andre Muis on 12/10/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Globals.h"

@class AppDelegate;
@class Styles;

@interface Utilities : NSObject 

+ (void)logWithClass: (Class)class format: (NSString *)formatString, ...;

+ (void)drawBorderInsideRect: (CGRect)rect withWidth: (CGFloat)width color: (UIColor *)color;

+ (void)drawStarInRect: (CGRect)rect clipRect: (CGRect)clipRect color: (UIColor *)color outline: (BOOL)outline;

+ (void)rotateImageView: (UIImageView *)imageView angleDegrees: (CGFloat)angleDegrees;

+ (UIImage *)createDirectionArrowImageWidth: (CGFloat)width height: (CGFloat)height;

+ (void)drawArrowInRect: (CGRect)rect angleDegrees: (double)angle scale: (float)scale;

+ (void)rotateX: (float *)x y: (float *)y angleDegrees: (double)dangle;

+ (double)radiansFromDegrees: (double)degrees;
+ (double)degreesFromRadians: (double)radians;

@end
