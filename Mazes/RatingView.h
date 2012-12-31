//
//  RatingView.h
//  Mazes
//
//  Created by Andre Muis on 12/30/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
	MARatingModeDoNothing = 1,
	MARatingModeDisplayAvg = 2,
	MARatingModeDisplayUser = 3,
	MARatingModeRecordPopover = 4,
	MARatingModeRecordEnd = 5
} MARatingModeType;

@interface RatingView : UIView <UIPopoverControllerDelegate>
{
	CGRect userRect;
}

@property (assign, nonatomic) MARatingModeType mode;
@property (assign, nonatomic) int mazeId;
@property (assign, nonatomic) float rating;

@property (assign, nonatomic) float starWidth;
@property (assign, nonatomic) float starHeight;

@property (strong, nonatomic) UIPopoverController *popoverController;

- (void)drawStarsRect: (CGRect)rect color: (UIColor *)color;

- (void)showRatingPopover;

- (void)setRating2: (float)rating;
- (void)setRatingResponse;

@end
