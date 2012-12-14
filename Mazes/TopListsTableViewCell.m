//
//  MazesTableViewCell.m
//  iPad Mazes
//
//  Created by Andre Muis on 4/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TopListsTableViewCell.h"

#import "RatingView.h"

@implementation TopListsTableViewCell

@synthesize nameLabel1; 
@synthesize viewRatingAvg1; 
@synthesize lblNumRatings1; 
@synthesize viewRatingUser1; 
@synthesize dateLabel1;
@synthesize imageViewBackground2; 
@synthesize nameLabel2;
@synthesize viewRatingAvg2; 
@synthesize lblNumRatings2; 
@synthesize viewRatingUser2; 
@synthesize dateLabel2;
@synthesize touchColumn;

- (void)touchesBegan: (NSSet *)touches withEvent: (UIEvent *)event 
{
	UITouch *touch = [touches anyObject];
	CGPoint touchPoint = [touch locationInView: self];
	
	// if touch is in Expanded User Rating View cancel touches and call rating popup
	if ([self TouchPoint: touchPoint InViewRatingUser: viewRatingUser1] == YES)
	{
		if (viewRatingUser1.mode == [Constants shared].RatingMode.DisplayUser)
        {
			[viewRatingUser1 ShowRatingPopover];
        }
		else
        {
			[super touchesBegan: touches withEvent: event];
        }
	}
	else if ([self TouchPoint: touchPoint InViewRatingUser: viewRatingUser2] == YES)
	{
		if (viewRatingUser2.mode == [Constants shared].RatingMode.DisplayUser)
        {
			[viewRatingUser2 ShowRatingPopover];
        }
		else
        {
			[super touchesBegan: touches withEvent: event];		
        }
	}
	else 
	{
		[super touchesBegan: touches withEvent: event];					
	}
	
	if (touchPoint.x < self.frame.size.width / 2.0)
		self.touchColumn = 1;
	else 
		self.touchColumn = 2;
}

- (BOOL)TouchPoint: (CGPoint)touchPoint InViewRatingUser: (RatingView *)viewRatingUser
{
	float x = viewRatingUser.frame.origin.x - viewRatingUser.starWidth / 2.0;
	float y = viewRatingUser.frame.origin.y - viewRatingUser.starHeight / 2.0;
	float width = viewRatingUser.frame.size.width + viewRatingUser.starWidth;
	float height = self.frame.size.height - y;
	
	CGRect expandedRect = CGRectMake(x, y, width, height);

	BOOL touchedInView = (CGRectContainsPoint(expandedRect, touchPoint));
	
	return touchedInView;
}

@end


