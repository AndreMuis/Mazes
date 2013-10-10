//
//  MAGameViewStyle.h
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MAColors;

@interface MAGameViewStyle : NSObject

@property (strong, nonatomic) UIColor *titleBackgroundColor;
@property (strong, nonatomic) UIFont *titleFont;
@property (strong, nonatomic) UIColor *titleTextColor;
	
@property (strong, nonatomic) UIColor *helpBackgroundColor;
@property (strong, nonatomic) UIColor *helpTextColor;
@property (strong, nonatomic) UIColor *borderColor;
@property (strong, nonatomic) UIColor *messageBackgroundColor;
@property (strong, nonatomic) UIColor *messageTextColor;

- (id)initWithColors: (MAColors *)colors;

@end
