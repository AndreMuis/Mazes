//
//  MARatingPopupStyle.h
//  Mazes
//
//  Created by Andre Muis on 10/20/13.
//  Copyright (c) 2013 Andre Muis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MAColors;

@interface MARatingPopupStyle : NSObject

@property (readonly, strong, nonatomic) UIColor *ratingStarColor;

@property (readonly, strong, nonatomic) UIColor *textColor;
@property (readonly, strong, nonatomic) UIFont *font;

@property (readonly, assign, nonatomic) UIEdgeInsets cancelButtonTitleEdgeInsets;

+ (MARatingPopupStyle *)ratingPopupStyle;

@end
