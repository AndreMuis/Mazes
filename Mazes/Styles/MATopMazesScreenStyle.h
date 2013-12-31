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

@property (strong, nonatomic) UIColor *tableBackgroundColor;
@property (strong, nonatomic) UIColor *textColor;

@property (strong, nonatomic) UIColor *averageRatingStarColor;
@property (strong, nonatomic) UIColor *userRatingStarColor;

- (id)initWithColors: (MAColors *)colors;

@end
