//
//  EditViewStyle.h
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 Andre Muis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Colors.h"

@interface EditViewStyle : NSObject

@property (strong, nonatomic) UIColor *panelBackgroundColor;
@property (strong, nonatomic) UIColor *tabDarkColor;
@property (strong, nonatomic) UIColor *tableHeaderBackgroundColor;
@property (strong, nonatomic) UIColor *tableHeaderTextColor;
@property (assign, nonatomic) UITextAlignment tableHeaderTextAlignment;
@property (strong, nonatomic) UIFont *tableHeaderFont;
@property (strong, nonatomic) UIColor *tableViewBackgroundColor;
@property (strong, nonatomic) UIColor *tableViewDisabledBackgroundColor;	
@property (assign, nonatomic) int tableViewBackgroundSoundRows;
@property (strong, nonatomic) UIColor *viewTexturesBackgroundColor;
@property (assign, nonatomic) float popoverTexturesWidth;
@property (assign, nonatomic) float popoverTexturesHeight;
@property (assign, nonatomic) float textureImageLength;
@property (assign, nonatomic) int texturesPerRow;
@property (strong, nonatomic) UIColor *viewButtonsBackgroundColor;
@property (strong, nonatomic) UIColor *messageBackgroundColor;
@property (strong, nonatomic) UIColor *messageTextColor;

@end
