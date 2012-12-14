//
//  Colors.h
//  Mazes
//
//  Created by Andre Muis on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Colors : NSObject
{
	UIColor *transparentColor;
	UIColor *blackColor; 
    UIColor *whiteColor;
    UIColor *whiteOpaqueColor; 
    UIColor *lightGrayColor;
    UIColor *darkGrayColor;
    UIColor *darkBrownColor; 
    UIColor *redColor;
    UIColor *greenColor; 
    UIColor *blueColor;
    UIColor *darkBlueColor; 
    UIColor *lightYellowColor; 
    UIColor *yellowColor;
    UIColor *darkYellowColor; 
    UIColor *orangeColor;
    UIColor *lightOrangeColor; 
    UIColor *orangeRedColor;
    UIColor *purpleColor;
    UIColor *lightPurpleColor;
}

@property (nonatomic, retain) UIColor *transparentColor;
@property (nonatomic, retain) UIColor *blackColor; 
@property (nonatomic, retain) UIColor *whiteColor;
@property (nonatomic, retain) UIColor *whiteOpaqueColor; 
@property (nonatomic, retain) UIColor *lightGrayColor;
@property (nonatomic, retain) UIColor *darkGrayColor;
@property (nonatomic, retain) UIColor *darkBrownColor; 
@property (nonatomic, retain) UIColor *redColor;
@property (nonatomic, retain) UIColor *greenColor; 
@property (nonatomic, retain) UIColor *blueColor;
@property (nonatomic, retain) UIColor *darkBlueColor; 
@property (nonatomic, retain) UIColor *lightYellowColor; 
@property (nonatomic, retain) UIColor *yellowColor;
@property (nonatomic, retain) UIColor *darkYellowColor; 
@property (nonatomic, retain) UIColor *orangeColor;
@property (nonatomic, retain) UIColor *lightOrangeColor; 
@property (nonatomic, retain) UIColor *orangeRedColor;
@property (nonatomic, retain) UIColor *purpleColor;
@property (nonatomic, retain) UIColor *lightPurpleColor;

+ (Colors *)shared;

@end
