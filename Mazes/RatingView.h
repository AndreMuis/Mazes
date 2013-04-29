//
//  RatingView.h
//  Mazes
//
//  Created by Andre Muis on 12/30/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RatingView;

typedef enum : int
{
	MARatingViewUnknown = 0,
	MARatingViewDisplayOnly = 1,
	MARatingViewEditable = 2,
	MARatingViewSelectable = 3
} MARatingViewType;

@protocol MARatingViewDelegate <NSObject>
@required
- (void)ratingView: (RatingView *)ratingView ratingChanged: (float)newRating;
@end

@interface RatingView : UIView <MARatingViewDelegate , UIPopoverControllerDelegate>

- (void)setupWithDelegate: (id<MARatingViewDelegate>)aDelegate rating: (float)aRating type: (MARatingViewType)aType starColor: (UIColor *)aStarColor;

@end
