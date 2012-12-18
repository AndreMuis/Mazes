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
	
	if (mode == [Constants shared].RatingMode.DoNothing)
	{
		self.userInteractionEnabled = NO;
	}
	else if (mode == [Constants shared].RatingMode.DisplayAvg)
	{
		[self drawStarsRect: rect Color: [Styles shared].ratingView.displayAvgColor];
	}
	else if (mode == [Constants shared].RatingMode.DisplayUser)
	{
		[self drawStarsRect: rect Color: [Styles shared].ratingView.displayUserColor];
	}
	else if (mode == [Constants shared].RatingMode.RecordPopover)
	{
		[self drawStarsRect: rect Color: [Styles shared].ratingView.recordPopoverColor];
	}
	else if (mode == [Constants shared].RatingMode.RecordEnd)
	{
		[self drawStarsRect: rect Color: [Styles shared].ratingView.recordEndColor];
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
			[Utilities drawStarInRect: CGRectMake(starX, starY, starWidth, starHeight)
                             clipRect: CGRectZero
                                color: color
                              outline: NO];
		}
		else if (i > ceilf(rating))
		{
			[Utilities drawStarInRect: CGRectMake(starX, starY, starWidth, starHeight)
                             clipRect: CGRectZero
                                color: color
                              outline: YES];
		}
		else
		{
			float fract = rating - floorf(rating);
			
			[Utilities drawStarInRect: CGRectMake(starX, starY, starWidth, starHeight)
                             clipRect: CGRectMake(starX, starY, fract * starWidth, starHeight)
                                color: color
                              outline: NO];
			
			[Utilities drawStarInRect: CGRectMake(starX, starY, starWidth, starHeight)
                             clipRect: CGRectMake(starX + fract * starWidth, starY, starWidth - fract * starWidth, starHeight)
                                color: color
                              outline: YES];
		}
	}
}

// touches for User Rating Views are handled in TopListsTableViewCell.m
- (void)touchesBegan: (NSSet *)touches withEvent: (UIEvent *)event 
{	
	[super touchesBegan: touches withEvent: event];
	
	// applies to rating view in popover
	if (mode == [Constants shared].RatingMode.RecordPopover || mode == [Constants shared].RatingMode.RecordEnd)
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
	viewController.view.backgroundColor = [Styles shared].ratingView.popupBackgroundColor;
	
	RatingView *ratingView = (RatingView *)[viewController.view.subviews objectAtIndex: 0];
	ratingView.backgroundColor = [Styles shared].ratingView.popupBackgroundColor;
	ratingView.Mode = [Constants shared].RatingMode.RecordPopover;
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
	if (mode == [Constants shared].RatingMode.RecordPopover)
	{
		[self.popoverController dismissPopoverAnimated: YES];
		
		[[MainListViewController shared] loadMazeList];
	}
	else if (mode == [Constants shared].RatingMode.RecordEnd)
	{
		[[Globals shared].gameViewController dismissEndAlertView];
	}
}

@end
