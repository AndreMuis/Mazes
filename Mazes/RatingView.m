//
//  RatingView.m
//  Mazes
//
//  Created by Andre Muis on 12/30/10.
//  Copyright 2010 Andre Muis. All rights reserved.
//

#import "RatingView.h"

#import "GameViewController.h"
#import "Globals.h"
#import "MainListViewController.h"
#import "Styles.h"
#import "Utilities.h"

@implementation RatingView

- (void)drawRect: (CGRect)rect 
{
	userRect = rect;
	
    switch (self.mode)
    {
        case MARatingModeDoNothing:
            self.userInteractionEnabled = NO;
            break;
            
        case MARatingModeDisplayAvg:
            [self drawStarsRect: rect color: [Styles shared].ratingView.displayAvgColor];
            break;
            
        case MARatingModeDisplayUser:
            [self drawStarsRect: rect color: [Styles shared].ratingView.displayUserColor];
            break;
            
        case MARatingModeRecordPopover:
            [self drawStarsRect: rect color: [Styles shared].ratingView.recordPopoverColor];
            break;
            
        case MARatingModeRecordEnd:
            [self drawStarsRect: rect color: [Styles shared].ratingView.recordEndColor];
            break;
            
        default:
            [Utilities logWithClass: [self class] format: @"mode set to an illegal value: %d", self.mode];
            break;
    }
}

- (void)drawStarsRect: (CGRect)rect color: (UIColor *)color
{
	self.starWidth = rect.size.width / 5.0;
	self.starHeight = rect.size.height;
	
	for (float i = 1.0; i <= 5.0; i = i + 1.0)
	{
		float starX = self.starWidth * (i - 1);
		float starY = rect.origin.y;
		
		if (i <= self.rating)
		{
			[Utilities drawStarInRect: CGRectMake(starX, starY, self.starWidth, self.starHeight)
                             clipRect: CGRectZero
                                color: color
                              outline: NO];
		}
		else if (i > ceilf(self.rating))
		{
			[Utilities drawStarInRect: CGRectMake(starX, starY, self.starWidth, self.starHeight)
                             clipRect: CGRectZero
                                color: color
                              outline: YES];
		}
		else
		{
			float fract = self.rating - floorf(self.rating);
			
			[Utilities drawStarInRect: CGRectMake(starX, starY, self.starWidth, self.starHeight)
                             clipRect: CGRectMake(starX, starY, fract * self.starWidth, self.starHeight)
                                color: color
                              outline: NO];
			
			[Utilities drawStarInRect: CGRectMake(starX, starY, self.starWidth, self.starHeight)
                             clipRect: CGRectMake(starX + fract * self.starWidth, starY, self.starWidth - fract * self.starWidth, self.starHeight)
                                color: color
                              outline: YES];
		}
	}
}

// touches for User Rating Views are handled in MainListTableViewCell.m
- (void)touchesBegan: (NSSet *)touches withEvent: (UIEvent *)event 
{	
	[super touchesBegan: touches withEvent: event];
	
	// applies to rating view in popover
	if (self.mode == MARatingModeRecordPopover || self.mode == MARatingModeRecordEnd)
	{
		CGPoint touchPoint = [[touches anyObject] locationInView: self];

		int stars = 0;
		for (int i = 0; i < 5; i = i + 1)
		{
			if (touchPoint.x >= i * self.starWidth && touchPoint.x <= (i + 1) * self.starWidth)
            {
				stars = i + 1;
            }
		}
		
		[self setRating2: stars];
	}
}

- (void)showRatingPopover
{
	UIViewController* viewController = [[UIViewController alloc] initWithNibName: @"RatingPopoverViewController" bundle: nil];
	viewController.view.backgroundColor = [Styles shared].ratingView.popupBackgroundColor;
	
	RatingView *ratingView = (RatingView *)[viewController.view.subviews objectAtIndex: 0];
	ratingView.backgroundColor = [Styles shared].ratingView.popupBackgroundColor;
	ratingView.mode = MARatingModeRecordPopover;
	ratingView.mazeId = self.mazeId;
	ratingView.rating = self.rating;
	
	UIPopoverController* thePopoverController = [[UIPopoverController alloc] initWithContentViewController: viewController];
	
	thePopoverController.popoverContentSize = CGSizeMake(viewController.view.frame.size.width, viewController.view.frame.size.height);
	thePopoverController.delegate = ratingView;
	
	[thePopoverController presentPopoverFromRect: self.bounds inView: self permittedArrowDirections: UIPopoverArrowDirectionAny animated: YES];
	
	ratingView.popoverController = thePopoverController;
}

- (void)setRating2: (float)aRating
{
    /*
	rating = aRating;
	[self setNeedsDisplay];
	
	comm = [[Communication alloc] initWithDelegate: self Selector: @selector(setRatingResponse) Action: @"SetMazeRating" WaitMessage: @"Saving"];

	[XML addNodeDoc: comm.requestDoc Parent: [XML getRootNodeDoc: comm.requestDoc] NodeName: @"MazeId" NodeValue: [NSString stringWithFormat: @"%d", mazeId]];
	[XML addNodeDoc: comm.requestDoc Parent: [XML getRootNodeDoc: comm.requestDoc] NodeName: @"UserId" NodeValue: UNIQUE_ID];
	[XML addNodeDoc: comm.requestDoc Parent: [XML getRootNodeDoc: comm.requestDoc] NodeName: @"Rating" NodeValue: [NSString stringWithFormat: @"%f", rating]];

	[comm post];
    */
}

- (void)setRatingResponse
{	
	if (self.mode == MARatingModeRecordPopover)
	{
		[self.popoverController dismissPopoverAnimated: YES];
		
		//[[MainListViewController shared] loadMazeList];
	}
	else if (self.mode == MARatingModeRecordEnd)
	{
		[[GameViewController shared] dismissEndAlertView];
	}
}

@end






















