//
//  RatingView.h
//  iPad_Mazes
//
//  Created by Andre Muis on 12/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Globals.h"
#import "Communication.h"
#import "Styles.h"
#import "TopListsViewController.h"
#import "GameViewController.h"

@interface RatingView : UIView <UIPopoverControllerDelegate>
{
	Communication *comm;
	
	CGRect userRect;
	
	int mode;
	int mazeId;
	float rating;
		
	float starWidth, starHeight;
	
	UIPopoverController *popoverController;
}

@property (nonatomic) int mode;
@property (nonatomic) int mazeId;
@property (nonatomic) float rating;

@property (nonatomic) float starWidth;
@property (nonatomic) float starHeight;

@property (nonatomic, retain) UIPopoverController *popoverController;

- (void)drawStarsRect: (CGRect)rect Color: (UIColor *)color;

- (void)ShowRatingPopover;

- (void)SetRating: (float)rating;
- (void)setRatingResponse;

@end
