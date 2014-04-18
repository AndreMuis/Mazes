//
//  MAButtonStyle.h
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MAColors;

@interface MAButtonStyle : NSObject

@property (readonly, strong, nonatomic) UIColor *backgroundColor;
@property (readonly, assign, nonatomic) CGFloat borderWidth;
@property (readonly, strong, nonatomic) UIColor *borderColor;
@property (readonly, assign, nonatomic) CGFloat cornerRadius;

@property (readonly, strong, nonatomic) UIColor *titleColor;
@property (readonly, strong, nonatomic) UIFont *titleFont;

+ (MAButtonStyle *)buttonStyle;

@end
