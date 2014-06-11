//
//  MAGameScreenStyle.h
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MAColors;

@interface MAGameScreenStyle : NSObject

@property (readonly, strong, nonatomic) UIColor *titleBackgroundColor;
@property (readonly, strong, nonatomic) UIFont *titleFont;
@property (readonly, strong, nonatomic) UIColor *titleTextColor;
    
@property (readonly, strong, nonatomic) UIColor *instructionsBackgroundColor;
@property (readonly, strong, nonatomic) UIColor *instructionsTextColor;
@property (readonly, strong, nonatomic) UIColor *borderColor;
@property (readonly, strong, nonatomic) UIColor *messageBackgroundColor;
@property (readonly, strong, nonatomic) UIColor *messageTextColor;

+ (MAGameScreenStyle *)gameScreenStyle;

@end
