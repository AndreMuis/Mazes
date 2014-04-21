//
//  MADesignScreenStyle.h
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MAColors;

@interface MADesignScreenStyle : NSObject

@property (readonly, strong, nonatomic) UIColor *panelBackgroundColor;
@property (readonly, strong, nonatomic) UIColor *tabDarkColor;

@property (readonly, strong, nonatomic) UIColor *tableHeaderBackgroundColor;
@property (readonly, strong, nonatomic) UIColor *tableHeaderTextColor;
@property (readonly, assign, nonatomic) NSTextAlignment tableHeaderTextAlignment;
@property (readonly, strong, nonatomic) UIFont *tableHeaderFont;

@property (readonly, strong, nonatomic) UIColor *tableViewBackgroundColor;
@property (readonly, strong, nonatomic) UIColor *tableViewDisabledBackgroundColor;

@property (readonly, assign, nonatomic) int tableViewBackgroundSoundRows;

@property (readonly, strong, nonatomic) UIColor *texturePlaceholderBackgroundColor;

@property (readonly, strong, nonatomic) UIColor *texturesViewBackgroundColor;
@property (readonly, assign, nonatomic) float texturesPopoverWidth;
@property (readonly, assign, nonatomic) float texturesPopoverHeight;
@property (readonly, assign, nonatomic) float textureImageLength;
@property (readonly, assign, nonatomic) int texturesPerRow;

@property (readonly, strong, nonatomic) UIColor *messageBackgroundColor;
@property (readonly, strong, nonatomic) UIColor *messageTextColor;

+ (MADesignScreenStyle *)designScreenStyle;

@end
