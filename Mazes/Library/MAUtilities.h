//
//  MAUtilities.h
//  Mazes
//
//  Created by Andre Muis on 12/10/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Reachability/Reachability.h>

@class AppDelegate;
@class MAFloorPlanStyle;

@interface MAUtilities : NSObject 

+ (void)logWithClass: (Class)class message: (NSString *)message parameters: (NSDictionary *)parameters;

+ (void)addChildViewController: (UIViewController *)childViewController
        toParentViewController: (UIViewController *)parentViewController
               placeholderView: (UIView *)placeholderView;

+ (NSString *)requestErrorMessageWithRequestDescription: (NSString *)requestDescription
                                           reachability: (Reachability *)reachability
                                           userCanRetry: (BOOL)userCanRetry;

+ (double)radiansFromDegrees: (double)degrees;
+ (double)degreesFromRadians: (double)radians;

+ (NSString *)createUUIDString;

+ (NSString *)randomNumericStringWithLength: (NSUInteger)length;

+ (void)drawBorderInsideRect: (CGRect)rect withWidth: (CGFloat)width color: (UIColor *)color;

+ (void)drawStarInRect: (CGRect)rect clipRect: (CGRect)clipRect color: (UIColor *)color outline: (BOOL)outline;

+ (UIImage *)createDirectionArrowImageWidth: (CGFloat)width height: (CGFloat)height;

+ (void)drawArrowInRect: (CGRect)rect angleDegrees: (double)angle scale: (float)scale floorPlanStyle: (MAFloorPlanStyle *)floorPlanStyle;

+ (void)rotateX: (float *)x y: (float *)y angleDegrees: (double)dangle;

@end
