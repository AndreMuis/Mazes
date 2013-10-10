//
//  MAUtilities.h
//  Mazes
//
//  Created by Andre Muis on 12/10/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppDelegate;
@class MAGridStyle;

@interface MAUtilities : NSObject 

+ (void)logWithClass: (Class)class format: (NSString *)formatString, ...;

+ (double)radiansFromDegrees: (double)degrees;
+ (double)degreesFromRadians: (double)radians;

+ (NSString *)uuid;

+ (NSString *)randomStringWithLength: (NSUInteger)length;

+ (void)drawBorderInsideRect: (CGRect)rect withWidth: (CGFloat)width color: (UIColor *)color;

+ (void)drawStarInRect: (CGRect)rect clipRect: (CGRect)clipRect color: (UIColor *)color outline: (BOOL)outline;

+ (UIImage *)createDirectionArrowImageWidth: (CGFloat)width height: (CGFloat)height;

+ (void)drawArrowInRect: (CGRect)rect angleDegrees: (double)angle scale: (float)scale gridStyle: (MAGridStyle *)gridStyle;

+ (void)rotateX: (float *)x y: (float *)y angleDegrees: (double)dangle;

@end
