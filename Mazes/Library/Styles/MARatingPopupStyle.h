//
//  MARatingPopupStyle.h
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MAColors;

@interface MARatingPopupStyle : NSObject

@property (strong, nonatomic) UIColor *backgroundColor;

+ (MARatingPopupStyle *)ratingPopupStyle;

@end
