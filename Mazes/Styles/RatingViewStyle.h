//
//  RatingViewStyle.h
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Colors.h"

@interface RatingViewStyle : NSObject

@property (strong, nonatomic) UIColor *popupBackgroundColor;

@property (strong, nonatomic) UIColor *averageRatingStarColor;
@property (strong, nonatomic) UIColor *userRatingStarColor;
@property (strong, nonatomic) UIColor *selectableStarColor;
@property (strong, nonatomic) UIColor *mazeFinishedStarColor;

@end