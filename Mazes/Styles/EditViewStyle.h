//
//  EditViewStyle.h
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Colors.h"

@interface EditViewStyle : NSObject

@property (retain, nonatomic) UIColor *panelBackgroundColor;
@property (retain, nonatomic) UIColor *tabDarkColor;
@property (retain, nonatomic) UIColor *tableHeaderBackgroundColor;
@property (retain, nonatomic) UIColor *tableHeaderTextColor;
@property (assign, nonatomic) UITextAlignment tableHeaderTextAlignment;
@property (retain, nonatomic) UIFont *tableHeaderFont;
@property (retain, nonatomic) UIColor *tableViewBackgroundColor;
@property (retain, nonatomic) UIColor *tableViewDisabledBackgroundColor;	
@property (assign, nonatomic) int tableViewBackgroundSoundRows;
@property (retain, nonatomic) UIColor *viewTexturesBackgroundColor;
@property (assign, nonatomic) float popoverTexturesWidth;
@property (assign, nonatomic) float popoverTexturesHeight;
@property (assign, nonatomic) float textureImageLength;
@property (assign, nonatomic) int texturesPerRow;
@property (retain, nonatomic) UIColor *viewButtonsBackgroundColor;
@property (retain, nonatomic) UIColor *messageBackgroundColor;
@property (retain, nonatomic) UIColor *messageTextColor;

@end
