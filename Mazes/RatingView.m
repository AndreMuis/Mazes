//
//  RatingView.m
//  iPad_Mazes
//
//  Created by Andre Muis on 12/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RatingView.h"

@implementation RatingView

@synthesize mode; 
@synthesize mazeId; 
@synthesize rating; 
@synthesize starWidth; 
@synthesize starHeight; 
@synthesize popoverController;

- (void)drawRect: (CGRect)rect 
{
	userRect = rect;
	
	if (mode == [Constants instance].RatingMode.DoNothing)
	{
		self.userInteractionEnabled = NO;
	}
	else if (mode == [Constants instance].RatingMode.DisplayAvg)
	{
		[self drawStarsRect: rect Color: [Styles instance].ratingView.displayAvgColor];
	}
	else if (mode == [Constants instance].RatingMode.DisplayUser)
	{
		[self drawStarsRect: rect Color: [Styles instance].ratingView.displayUserColor];
	}
	else if (mode == [Constants instance].RatingMode.RecordPopover)
	{
		[self drawStarsRect: rect Color: [Styles instance].ratingView.recordPopoverColor];
	}
	else if (mode == [Constants instance].RatingMode.RecordEnd)
	{
		[self drawStarsRect: rect Color: [Styles instance].ratingView.recordEndColor];
	}
}

- (void)drawStarsRect: (CGRect)rect Color: (UIColor *)color
{
	starWidth = rect.size.width / 5.0;
	starHeight = rect.size.height;
	
	for (float i = 1.0; i <= 5.0; i = i + 1.0)
	{
		float starX = starWidth * (i - 1);
		float starY = rect.origin.y;
		
		if (i <= rating)
		{
			[Utilities drawStarInRect: CGRectMake(starX, starY, starWidth, starHeight) ClipRect: CGRectZero UIColor: color  Outline: NO];
		}
		else if (i > ceilf(rating))
		{
			[Utilities drawStarInRect: CGRectMake(starX, starY, starWidth, starHeight) ClipRect: CGRectZero UIColor: color  Outline: YES];
		}
		else
		{
			float fract = rating - floorf(rating);
			
			[Utilities drawStarInRect: CGRectMake(starX, starY, starWidth, starHeight) ClipRect: CGRectMake(starX, starY, fract * starWidth, starHeight) UIColor: color  Outline: NO];
			
			[Utilities drawStarInRect: CGRectMake(starX, starY, starWidth, starHeight) ClipRect: CGRectMake(starX + fract * starWidth, starY, starWidth - fract * starWidth, starHeight) UIColor: color  Outline: YES];
		}
	}
}

// touches for User Rating Views are handled in TopListsTableViewCell.m
- (void)touchesBegan: (NSSet *)touches withEvent: (UIEvent *)event 
{	
	[super touchesBegan: touches withEvent: event];
	
	// applies to rating view in popover
	if (mode == [Constants instance].RatingMode.RecordPopover || mode == [Constants instance].RatingMode.RecordEnd)
	{
		CGPoint touchPoint = [[touches anyObject] locationInView: self];

		int stars = 0;
		for (int i = 0; i < 5; i = i + 1)
		{
			if (touchPoint.x >= i * starWidth && touchPoint.x <= (i + 1) * starWidth)
            {
				stars = i + 1;
            }
		}
		
		[self SetRating: stars];
	}
}

- (void)ShowRatingPopover
{
	UIViewController* viewController = [[UIViewController alloc] initWithNibName: @"RatingPopoverViewController" bundle: nil];
	viewController.view.backgroundColor = [Styles instance].ratingView.popupBackgroundColor;
	
	RatingView *ratingView = (RatingView *)[viewController.view.subviews objectAtIndex: 0];
	ratingView.backgroundColor = [Styles instance].ratingView.popupBackgroundColor;
	ratingView.Mode = [Constants instance].RatingMode.RecordPopover;
	ratingView.MazeId = mazeId;
	ratingView.Rating = rating;
	
	UIPopoverController* thePopoverController = [[UIPopoverController alloc] initWithContentViewController: viewController];
	
	thePopoverController.popoverContentSize = CGSizeMake(viewController.view.frame.size.width, viewController.view.frame.size.height);
	thePopoverController.delegate = ratingView;
	
	[thePopoverController presentPopoverFromRect: self.bounds inView: self permittedArrowDirections: UIPopoverArrowDirectionAny animated: YES];
	
	ratingView.popoverController = thePopoverController;
}

- (void)SetRating: (float)aRating
{
	rating = aRating;
	[self setNeedsDisplay];
	
	comm = [[Communication alloc] initWithDelegate: self Selector: @selector(setRatingResponse) Action: @"SetMazeRating" WaitMessage: @"Saving"];

	[XML addNodeDoc: comm.requestDoc Parent: [XML getRootNodeDoc: comm.requestDoc] NodeName: @"MazeId" NodeValue: [NSString stringWithFormat: @"%d", mazeId]];
	[XML addNodeDoc: comm.requestDoc Parent: [XML getRootNodeDoc: comm.requestDoc] NodeName: @"UserId" NodeValue: UNIQUE_ID];
	[XML addNodeDoc: comm.requestDoc Parent: [XML getRootNodeDoc: comm.requestDoc] NodeName: @"Rating" NodeValue: [NSString stringWithFormat: @"%f", rating]];

	[comm post];
}

- (void)setRatingResponse
{	
	if (mode == [Constants instance].RatingMode.RecordPopover)
	{
		[self.popoverController dismissPopoverAnimated: YES];
		
		[[Globals instance].topListsViewController loadMazeList];
	}
	else if (mode == [Constants instance].RatingMode.RecordEnd)
	{
		[[Globals instance].gameViewController dismissEndAlertView];
	}
}

@end
