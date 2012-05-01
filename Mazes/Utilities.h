//
//  Utilities.h
//  iPad_Mazes
//
//  Created by Andre Muis on 12/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Globals.h"

@class AppDelegate;
@class Styles;

@interface Utilities : NSObject 
{
}

+ (NSString *)getLanguageCode;
+ (NSString *)getLanguageNameFromCode: (NSString *)languageCode;

+ (void)createActivityView;

+ (void)showActivityViewWithMessage: (NSString *)message;
+ (void)hideActivityView;

+ (void)ShowAlertWithDelegate: (id)delegate Message: (NSString *)message CancelButtonTitle: (NSString *)cancelButtonTitle OtherButtonTitle: (NSString *)otherButtonTitle Tag: (int)tag Bounds: (CGRect)bounds;

+ (void)drawBorderInsideRect: (CGRect)rect WithWidth: (CGFloat)width Color: (UIColor *)color;

+ (void)drawStarInRect: (CGRect)rect ClipRect: (CGRect)clipRect UIColor: (UIColor *)uiColor Outline: (BOOL)outline;

+ (void)RotateImageView: (UIImageView *)imageView AngleDegrees: (CGFloat)angleDegrees;

+ (UIImage *)CreateDirectionArrowImageWidth: (CGFloat)width Height: (CGFloat)height;

+ (void)drawArrowInRect: (CGRect)rect AngleDegrees: (double)angle Scale: (float)scale;

+ (void)RotateX: (float *)x Y: (float *)y AngleDegrees: (double)dangle;

+ (double)RadiansFromDegrees: (double)degrees;
+ (double)DegreesFromRadians: (double)radians;

+ (NSString *)URLEncode: (NSString *)string;

@end
