//
//  MATopMazesScreenStyle.h
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MAColors;

@interface MATopMazesScreenStyle : NSObject

@property (readonly, strong, nonatomic) UIColor *tableBackgroundColor;
@property (readonly, strong, nonatomic) UIColor *textColor;

@property (readonly, strong, nonatomic) UIColor *averageRatingStarColor;
@property (readonly, strong, nonatomic) UIColor *userRatingStarColor;

+ (MATopMazesScreenStyle *)topMazesScreenStyle;

@end
