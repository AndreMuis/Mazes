//
//  GameViewStyle.h
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Colors.h"

@interface GameViewStyle : NSObject

@property (retain, nonatomic) UIColor *titleBackgroundColor;
@property (retain, nonatomic) UIFont *titleFont;
@property (retain, nonatomic) UIColor *titleTextColor;
	
@property (retain, nonatomic) UIColor *helpBackgroundColor;
@property (retain, nonatomic) UIColor *helpTextColor;
@property (retain, nonatomic) UIColor *borderColor;
@property (retain, nonatomic) UIColor *messageBackgroundColor;
@property (retain, nonatomic) UIColor *messageTextColor;

@end
