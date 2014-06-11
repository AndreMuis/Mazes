//
//  MACreateScreenStyle.h
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MAColors;

@interface MACreateScreenStyle : NSObject

@property (readonly, assign, nonatomic) CGFloat pickerWidth;
@property (readonly, strong, nonatomic) UIColor *pickerBackgroundColor;
@property (readonly, strong, nonatomic) UIColor *pickerBorderColor;
@property (readonly, assign, nonatomic) CGFloat pickerBorderWidth;

@property (readonly, assign, nonatomic) CGFloat pickerRowHeight;
@property (readonly, strong, nonatomic) UIColor *pickerRowBackgroundColor;
@property (readonly, strong, nonatomic) UIColor *pickerRowTextColor;
@property (readonly, strong, nonatomic) UIFont *pickerRowFont;

@property (readonly, strong, nonatomic) UIColor *messageBackgroundColor;
@property (readonly, strong, nonatomic) UIColor *messageEnabledTextColor;
@property (readonly, strong, nonatomic) UIColor *messageDisabledTextColor;

@property (readonly, strong, nonatomic) UIColor *floorPlanBorderColor;

+ (MACreateScreenStyle *)createScreenStyle;

@end
