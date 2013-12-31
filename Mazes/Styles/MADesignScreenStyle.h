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

@property (strong, nonatomic) UIColor *panelBackgroundColor;
@property (strong, nonatomic) UIColor *tabDarkColor;

@property (strong, nonatomic) UIColor *tableHeaderBackgroundColor;
@property (strong, nonatomic) UIColor *tableHeaderTextColor;
@property (assign, nonatomic) NSTextAlignment tableHeaderTextAlignment;
@property (strong, nonatomic) UIFont *tableHeaderFont;

@property (strong, nonatomic) UIColor *tableViewBackgroundColor;
@property (strong, nonatomic) UIColor *tableViewDisabledBackgroundColor;

@property (assign, nonatomic) int tableViewBackgroundSoundRows;

@property (strong, nonatomic) UIColor *texturesViewBackgroundColor;
@property (assign, nonatomic) float texturesPopoverWidth;
@property (assign, nonatomic) float texturesPopoverHeight;
@property (assign, nonatomic) float textureImageLength;
@property (assign, nonatomic) int texturesPerRow;

@property (strong, nonatomic) UIColor *buttonsViewBackgroundColor;

@property (strong, nonatomic) UIColor *messageBackgroundColor;
@property (strong, nonatomic) UIColor *messageTextColor;

- (id)initWithColors: (MAColors *)colors;

@end
