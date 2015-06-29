//
//  MAPopupStyle.h
//  Mazes
//
//  Created by Andre Muis on 10/20/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MAColors;

@interface MAPopupStyle : NSObject

@property (readonly, strong, nonatomic) UIColor *translucentBackgroundColor;

@property (readonly, strong, nonatomic) UIColor *backgroundColor;
@property (readonly, assign, nonatomic) CGFloat cornerRadius;
@property (readonly, assign, nonatomic) CGFloat borderWidth;
@property (readonly, strong, nonatomic) UIColor *borderColor;

@property (readonly, assign, nonatomic) CGFloat initialScale;

@property (readonly, assign, nonatomic) NSTimeInterval initialAnimationDuration;
@property (readonly, assign, nonatomic) NSTimeInterval otherAnimationDuration;

@property (readonly, assign, nonatomic) CGFloat bounceScalePercent;

+ (MAPopupStyle *)popupStyle;

@end
